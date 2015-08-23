#!/usr/bin/perl -w
use IO::Handle;

($pid) = @ARGV;
print "pid= $pid\n";

         system(" sudo kill -2 $pid ");
        sleep 1;
        print"psbegin\n";
 my $p=       `ps -eF|grep tcpdump`;
        print "$p \n";
        print "psend\n";

        
        exit;




