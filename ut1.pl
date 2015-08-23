#!/usr/bin/perl -w
use IO::Handle;

($ip, $log_name, $tout) = @ARGV;
#print "ip= $ip\nfile: $log_name\n";
my $ppid=getppid();
#print "ppid= $ppid\n";
if ($pid = fork) {
#	print "parent: pid for child:$pid\n";
waitpid ($pid,0);
exit;
} else {
    	die "cannot fork: $!" unless defined $pid;
# child here;
         system(" sudo /usr/sbin/tcpdump -vvv -s0 host $ip 2>/dev/null -w $log_name &");
        sleep 1;
        print"psbegin\n";
 my $p=       `ps -eF|grep tcpdump`;
        print "$p \n";
        print "psend\n";
        sleep 1;
        `kill -2 $ppid`;
        sleep $tout;
     $p= `ps -eF|grep $log_name|grep tcpdump|grep $log_name|grep $ip`;
    #  print "$p \n";
      foreach ($p) {
      if ($_ = ~/(pcap)(\s+)(\d+)/)
      {
      #  print $3 . "\n";
       `sudo kill -2 $3 `;
       exit;
      }
      }
        exit;
}



