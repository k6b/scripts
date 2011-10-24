#!/usr/bin/perl
# thx sticky
use Geo::IP;

sub dongz
{
    my $input =  $ARGV[0];
    my $gi    = Geo::IP->new;
    if ($input =~ /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/)
    {
        my $country = $gi->country_code_by_addr($input);

        if ($country =~ /[A-Z]{2}/)
        {
            print "$input -> $country\n";
        }
        else
        {
            print "Sorry! No data was returned.\n";
        }
    }
    elsif (lc($input) =~ /[a-z]/)
    {
        $country = $gi->country_code_by_name($input);

        if ($country =~ /[A-Z]{2}/)
        {
            print "$input -> $country\n";
        }
        else
        {
            print "Sorry! No data was returned.\n";
        }
    }
    else
    {
    print "Maybe you should supply an argument.\n";

    }

} 

&dongz;

