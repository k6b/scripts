#!/usr/local/bin/perl

# backup - by k6b - perl version - 02.04.12

use POSIX;
use Net::FTP;
use File::Temp qw/ tempdir /;
use File::Find;
use File::Path qw/ make_path /;
use File::Basename;
use Archive::Tar;

# Define some variables

my %param = (
	ftpuser	=>	'',
	ftppass	=>	'',
	ftphost	=>	'',
	sqluser	=>	'',
	sqlpw	=>	'',
	);

# set the backup time variable

if (@ARGV) {
	for (@ARGV[0]) {
		if (/m/) {
			$time = "monthly";
			$otime = time - 31536000;
		} elsif (/d/) {
			$time = "daily";
			$otime = time - 2592000;
		} elsif (/w/) {
			$time = "weekly";
			$otime = time - 7796000;
		} else {
			print "usage\n";
			exit;
			}
		}
	if (@ARGV[1] == "1") {
		print "DEBUG\n";
		$debug = "yes";
		}
} else {
	print "usage:\n";
	exit;
	}

# subroutine to print more verbosely

sub DPrint {
	for (@ARGV) {
		if (/1/) {
			print "@_";
			}
		}
	}


# find the date

my $date = strftime( '%m.%d.%y', localtime );

DPrint("Date: $date\n");


# Files to transfer

# I stole this whole sub routine.

sub DirList {
	my $DIR="/home/@_[0]";
	find ({wanted=>\&TreatThisFile,preprocess=>\&PreTreatThisDirectory},$DIR);

	foreach my $s_Directory (sort {uc $a cmp uc $b} keys %$rhha) { # In directory order
		foreach my $s_Extension (sort {$a cmp $b} keys %{$rhha->{$s_Directory}}) { # In extension order (already uc'd)
			foreach my $s_Filename (sort {uc $a cmp uc $b} @{$rhha->{$s_Directory}{$s_Extension}}) { #
				my $directories = "$s_Directory$s_Filename";
				if ($directories =~ m/@_/) {
					push(@dirss, $directories);
					}
				}
			}
		}

	sub PreTreatThisDirectory {
		# Don't add this directory if it already has been added
		$f_DoNotInsert=exists $rhha->{$File::Find::dir};
		return @_;
		}

	sub TreatThisFile {
		my($s_Path);
		if (-d ($s_Path=$File::Find::name)) { # A directory ...
		} else { # A file ...
			my($s_Name,$s_Directory,$s_Extension)=fileparse($s_Path,'\.[^.]*');
			push(@{$rhha->{$s_Directory}{uc $s_Extension}},"$s_Name$s_Extension") unless ($f_DoNotInsert);
			}
		}
	}

# Create a temp directory

my $tempdir = tempdir( CLEANUP => 1 );

# list of users to backup

($name, $passwd, $gid, $members) = getgrnam('backup');

# split the members of the backup group by ' '

my @users = split(' ', $members);

# prep the temp directory

make_path("$tempdir/$time");
make_path("$tempdir/mysql/$time");

# create a tar for each user

foreach my $user (@users) {
	DPrint("User: $user: Listing files.\n");
	DirList( "$user");
	DPrint("User: $user: Adding files to archive.\n");
	my $tar = Archive::Tar->new();
	$tar->add_files( @dirss );
	DPrint("User: $user: Compressing archive.\n");
	$tar->write("$tempdir/$time/$user.$date.tar.gz", 'COMPRESS_GZIP');
	DPrint("User: $user: Archive location: $tempdir/$time/$user.$date.tar.gz\n");
	undef @dirss;
	}

# get a list of databases on the machine
# I'll figure out a more 'perl' way to do this later

@databases = `mysql --skip-column-name -u $param{sqluser} --password="$param{sqlpw}" -e "show databases" | sed '/information/d'`;

chomp(@databases);

foreach $db (@databases) {
	DPrint("DB: Dumping database: $db\n");
	`mysqldump -u $param{sqluser} --password="$param{sqlpw}" $db | gzip > $tempdir/mysql/$time/$db.$date.sql.gz`;
	}


# make a list of backups to transfer

@filesxfer = <$tempdir/$time/*>;
DPrint("Files to transfer:\n");
foreach $xferfile (@filesxfer) {
	DPrint("\t$xferfile\n");
	}

# Make a list of DB dumps to transfer

@dbsxfer = <$tempdir/mysql/$time/*>;
DPrint("DBs to transfer:\n");
foreach $xferdbs (@dbsxfer) {
	DPrint("\t$xferdbs\n");
	}

# Begin the FTP transfer

$ftp	=	Net::FTP->new($param{ftphost}, Debug => 0)
	or die "Cannot connect to $ftphost: $@\n";
	DPrint("FTP: Connecting to $param{ftphost}\n");

$ftp	->	login($param{ftpuser}, $param{ftppass})
	or die "Cannot login\n ", $ftp->message;
	DPrint("FTP: Logging in.\n");

$ftp	->	cwd("/$time")
	or die "Cannot change working directory\n ", $ftp->message;
	DPrint("FTP: CWD: /$time\n");

foreach $xferfile (@filesxfer) {
	$ftp	->	put("$xferfile")
		or die "Cannot put file: $xferfile\n ";
	DPrint("FTP: Transferring: $xferfile \n");
	}
	DPrint("FTP: Done transferring backups\n");

@files = $ftp   ->      ls("/$time/")
	or die "Cannot ls dir\n";
	foreach $file (@files) {
		if ($file =~ m/^\.|^\.\./) {
			next;
			}

		$rtime = $ftp   ->      mdtm("/$time/$file")
			or die "FTP: Cannot get MDTM on $file\n";
		if ($rtime < $otime) {
			push(@oldfiles, $file);
			DPrint("FTP: Found file: /$time/$file\n");
			}
		}

foreach $oldfile (@oldfiles) {
	$ftp   ->      delete("/$time/$oldfile")
	                       or die "FTP: Cannot remove $oldfile\n";
	DPrint("FTP: Deleting /$time/$oldfile\n");
	}

$ftp	->	cwd("/mysql/$time")
	or die "Cannot change working directory\n";
	DPrint("FTP: CWD: /mysql/$time\n");

foreach $xferdbs (@dbsxfer) {
	$ftp	->	put("$xferdbs")
		or die "Cannot put db: $xferdb\n";
	DPrint("FTP: Transferring: $xferdbs\n");
	}
	DPrint("FTP: Done transferring dbs\n");

@dbs = $ftp   ->      ls("/mysql/$time/")
	or die "Cannot ls dir\n";
	foreach $db (@dbs) {
		if ($db =~ m/^\.|^\.\./) {
			next;
			}

	$rtime = $ftp   ->      mdtm("/mysql/$time/$db")
		or die "FTP: Cannot get MDTM on $db\n";
		if ($rtime < $otime) {
			push(@olddbs, $db);
			DPrint("FTP: Found database: /mysql/$time/$db\n");
			}
		}

foreach $olddb (@olddbs) {
	$ftp   ->      delete("/mysql/$time/$olddb")
	                       or die "FTP: Cannot remove $oldfile\n";
	DPrint("FTP: Deleting /mysql/$time/$olddb\n");
	}

$ftp	->	quit;
