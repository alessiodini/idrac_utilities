#!/usr/bin/perl

#Alessio Dini, 21/09/2017
#Script che si collega alle iDRAC e cambia la password dell'utente root in F0rz4

use Net::OpenSSH;;

if(@ARGV < 1)
{
    print "Sintassi: $0 <ip_vm>\n";
    exit -1;
}

my $count = 1;
my $host = $ARGV[0];
my $password = 'calvin';
my $timeout = 10;
my $username = 'root';

my %param=(
    user => $username,
    password=> $password,
    timeout => 10,
    port => '22',
    master_opts => [-o => "StrictHostKeyChecking=no"]
    );

print "\n\nConnection to host $host\n";
my $ssh = Net::OpenSSH->new($host,%param);

$ssh->error and die "Unable to connect to remote host: " . $ssh->error;

while ($count < 17)
{
        my $ale  = " racadm getconfig -g cfgUserAdmin -i $count ";
        my $fale = $ssh->capture($ale);
        if ($fale =~ /UserName=root/)
        {
                my $pwd  = " racadm config -g cfgUserAdmin -o cfgUserAdminPassword -i $count F0rz4 ";
                my $fpwd = $ssh->capture($pwd);
                if ($fpwd =~ /successfully/)
                {
                        print "Reset password succesfully executed on $host - index $count\n";
                        exit;
                }
                else
                {
                        print "Host $host: User root found on index $count but something went wrong\n";
                        exit;
                }
        }
        $fale == "";
        $count++;
}
