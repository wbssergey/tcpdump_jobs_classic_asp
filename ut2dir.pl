#!/usr/bin/perl -w
use IO::Handle;
($mask) = @ARGV;
        
 my @p=       `ls -l $mask`;

       print "lsbegin\n";

       foreach $k (@p) {
        if ($k=~/^\s*\S*\s*\d+(\s+\S+\s+\S+\s+)(\d+)\s+(\w+)\W+(\d+)\s+([\w,:]+)\W+(.*)$/)
        {
        print "atr".$1."size".$2."time".$3." ".$4." ".$5."file".$6."endzfile\n";
        };
       };
       print "lsend\n";

#        print "\n";
#        print "psbegin\n";
#        print "@p \n";
#        print "psend\n";
       
        exit;




