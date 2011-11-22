#! /bin/sh
# script to find the number of IPs banned by fail2ban
# by k6b kyle@kyleberry.org
#

#####
# First, we'll define a few functions so we don't have to
# do the same thing over and over again.
#####

# We need to look through fail2ban.log and find IPs that
# have been banned more than once, we can do this by
# using a regex through this function instead of an IP.
# Then we feed the function the IP's we found to gather
# more information.

ipfind () {
    awk "/Ban\ $1/"'{ a[$7]++ }
        { for ( i in a ) { if ( a[i]-1 ) print i, a[i] }}' /var/log/fail2ban.log |
    awk '{ a[$1] < $NF? a[$1] = $NF : "" } END { for ( i in a ) { print i, "\t" a[i] }}' |
    awk '{print $1,$2}'
}

# Use geoiplookup and some awk/sed magic to return just
# the country of origin of the IP in question.

geoip () {
    geoiplookup $1 | awk -F , '{print $2}' | sed s/\ //
}

# We also need to create a list of the IPs that are currently
# banned. We'll process this information later.

recent () {
    egrep "\ Ban\ " /var/log/fail2ban.log | tail -n $total
}

#####
# Now we'll define some global variables
#####

# Find the number of IPs banned
# Added sanity check for systems with no IPs banned

bans=$(awk '/\ Ban / { nmatches++ } { if ( nmatches==0 ) nmatches=0 } END { print nmatches }' /var/log/fail2ban.log)

# This is the regex we use to find IPs with ipfind () here
# we make a list of the IPs banned more than once we're only
# interested in the first colum here.

iplist=$(ipfind [0-9]++.[0-9]++.[0-9]++.[0-9]++ | awk '{ print $1 }')

# Here we find the number of IPs currently banned by using the
# number we found earlier and subtracting it from the number of
# Unbans reported by fail2ban. I'm sure there's a better way to
# find this number.
# Added sanity check for systems with no IPs banned.

total=$(($bans - $(awk '/\ Unban / { nmatches++ } { if ( nmatches == 0 ) nmatches=0 } END { print nmatches }' /var/log/fail2ban.log)))

#####
# Begin the script
#####

# Check to make sure we are running as root

if [[ $EUID -ne 0 ]]; then
    echo Must be run as root!
    exit 0
fi

# Print some text

echo -e '\n'"\033[4m\033[1mFail2Ban\033[0m"'\n'

# Use proper grammer :)

if [[ $bans -eq 0 ]]
then
    echo -e No IPs have been banned.
elif [[ $bans -ne 1 ]]
then
    echo -e $bans IPs have been banned.
    echo -e '\n'"\033[4mIP\t\tBans\tCountry\033[0m"
else
    echo -e $bans IP has been banned.
    echo -e '\n'"\033[4mIP\t\tBans\tCountry\033[0m"
fi


# Use the list of IPs we found to generate a list of IP's that
# have been banned more than once, along with the number of times
# it's been banned and it's country of origin.

for i in $iplist
do
   echo -e $(ipfind $i | awk '{ print $1 }')'\t'$(ipfind $i | awk '{ print $2 }')'\t'$(geoip $i)
done

# We want to print the number of IPs that are currently banned,
# but we should use proper grammar. (Because why not?)

if [[ $total -ne "1" ]]
then
    echo -e '\n'Currently $total IPs are banned.'\n'
else
    echo -e '\n'Currently $total IP is banned.'\n'
fi

# If we have an IP currently banned, let's make another list showing
# the IP, the date and time of it's ban, and it's country of origin.

if [[ $total -ne "0" ]]
then

    # Generate a list of the currently banned IPs

    ips=$(recent | awk '{print $7}')

    # Print some more text

    echo -e "\033[4mCurrently Banned\033[0m"'\n'
    echo -e "\033[4mIP\t\tDate\t\tTime\t\tCountry\033[0m"

        # Use the list of IPs to find more information about the
        # currently banned IPs

        for i in $ips
        do

            # Find the date and time

            date=$(recent | awk "/$i/"'{print $1}')
            time=$(recent | awk "/$i/"'{print $2}' | cut -d , -f 1)
#            service=$(recent | awk "/$i/"'{print $5}' | sed 's/-iptables//')

            # Print out the list of currently banned IPs

            echo -e $i'\t'$date'\t'$time'\t'$(geoip $i)
        done
    echo
fi
