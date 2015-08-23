#!/usr/bin/perl -w
use IO::Handle;


        print"psbegin\n";
 my $p=       `ps -eF|grep tcpdump`;
        print "$p \n";
        print "psend\n";

        
        exit;




