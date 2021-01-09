#!/usr/bin/ruby
require 'pty'
require 'tty-progressbar'
require 'pastel'

#Starting color variables
$pastel = Pastel.new
cyan  = $pastel.on_cyan(" ")
red   = $pastel.on_red(" ")


#Simple, TCP Scan
def scan(line)

#Regex to get scan % progress
  $progress =  line.match(/About (.*)%/)

#SYN SCAN
    if ($progress != nil) and line.include? "SYN Stealth Scan Timing:" 
          $novo_status = $progress.to_a[1].to_i
          $synscan.current = $novo_status
    elsif ($progress != nil) and line.include? "UDP Scan Timing:" 
          $novo_status = $progress.to_a[1].to_i
          $synscan.current = $novo_status
    elsif ($progress != nil) and line.include? "ARP Ping Timing" 
          $novo_status = $progress.to_a[1].to_i
          $synscan.current = $novo_status
    end

#SERVICE SCAN
    if ($progress != nil) and line.include? "Service scan Timing:" 
      $novo_status = $progress.to_a[1].to_i
      $synscan.current = 100
      $servicescan.current = $novo_status
    end

#NSE SCAN
    if ($progress != nil) and line.include? "NSE Timing:" and !line.match(/NSE Timing: About 0.00% done/)
      $novo_status = $progress.to_a[1].to_i
      $servicescan.current = 100
      $nsescan.current = $novo_status
    end

 #Print open ports with color
    if !line.match(/\d.\d\d%|undergoing|rDNS record|Starting Nmap|retransmission/) and !line.match(/open/)
      $bars.finish
      puts line.chomp
    end

 #Print all other results 
    if !line.match(/\d.\d\d%|undergoing|rDNS record|Starting Nmap|retransmission/) and line.include? "open"
      $bars.finish
      puts $pastel.green.bold(line.chomp)
    end

  #Zero to scan bars and initial msg
    if line.match(/Starting Nmap/) 
      puts $pastel.cyan "[!]Starting Nmap Scan\t[#{ARGV[1]}]"
      $synscan.current = 0
      $servicescan.current = 0
      $nsescan.current = 0
    end

end

#ARGV for simple scan
if  ARGV[0] == "-s" and  ARGV[1] != nil
$cmd = "nmap -sV -sC -T4 -n -oN Simple_Scan_#{ARGV[1]}.txt -oX nmap_#{ARGV[1]}_simple.xml #{ARGV[1]}" #-sV -sC -n
#Bars Setup
$bars = TTY::ProgressBar::Multi.new("Main  Progress [:bar] :percent, :elapsed",head:'>', width: 100)
$synscan = $bars.register("SYN Scan     [:bar] :percent", total: 100)
$servicescan = $bars.register("Service Scan [:bar] :percent", total: 100)
$nsescan = $bars.register("NSE Scan     [:bar] :percent", total: 100)
  PTY.spawn( $cmd ) do |stdout, stdin, pid|
    stdout.each do |line|
    stdin.puts '  '
    scan(line)
#If match, END.
    if line.include? "Nmap done:"
    break
    end
   end
  end
end

#ARGV for tcp scan
if  ARGV[0] == "-c" and  ARGV[1] != nil
$cmd = "nmap -A -p- -T4 -oN TCP_Scan_#{ARGV[1]}.txt -oX nmap_#{ARGV[1]}_tcp.xml #{ARGV[1]}" #
#Bars Setup
$bars = TTY::ProgressBar::Multi.new("Main  Progress [:bar] :percent, :elapsed",head:'>', width: 100)
$synscan = $bars.register("SYN Scan     [:bar] :percent", total: 100)
$servicescan = $bars.register("Service Scan [:bar] :percent", total: 100)
$nsescan = $bars.register("NSE Scan     [:bar] :percent", total: 100)
  PTY.spawn( $cmd ) do |stdout, stdin, pid|
    stdout.each do |line|
    stdin.puts '  '
    scan(line)
#If match, END.
      if line.include? "Nmap done:"
      break
      end
    end
  end
end

#ARGV for 1000 UDP ports
if  ARGV[0] == "-u" and  ARGV[1] != nil
$cmd = "nmap -A -sU -T4 -F -oN UDP_Scan_#{ARGV[1]}.txt -oX nmap_#{ARGV[1]}_udp.xml #{ARGV[1]}"
#Bars Setup
$bars = TTY::ProgressBar::Multi.new("Main  Progress [:bar] :percent, :elapsed",head:'>', width: 100)
$synscan = $bars.register("UDP Scan     [:bar] :percent", total: 100)
$servicescan = $bars.register("Service Scan [:bar] :percent", total: 100)
$nsescan = $bars.register("NSE Scan     [:bar] :percent", total: 100)
  PTY.spawn( $cmd ) do |stdout, stdin, pid|
    stdout.each do |line|
    stdin.puts '  '
    scan(line)
#If match, END.
      if line.include? "Nmap done:"
      break
      end
    end
  end
end

#ARGV for all UDP ports
if  ARGV[0] == "-a" and  ARGV[1] != nil
$cmd = "nmap -A -sU -T4 -p- -oN UDP_All_Scan_#{ARGV[1]}.txt -oX nmap_#{ARGV[1]}_udp_all.xml #{ARGV[1]}"
#Bars Setup
$bars = TTY::ProgressBar::Multi.new("Main  Progress [:bar] :percent, :elapsed",head:'>', width: 100)
$synscan = $bars.register("UDP Scan     [:bar] :percent", total: 100)
$servicescan = $bars.register("Service Scan [:bar] :percent", total: 100)
$nsescan = $bars.register("NSE Scan     [:bar] :percent", total: 100)
  PTY.spawn( $cmd ) do |stdout, stdin, pid|
    stdout.each do |line|
    stdin.puts '  '
    scan(line)
#If match, END.
      if line.include? "Nmap done:"
      break
      end
    end
  end
end

#ARGV for vuln scan
if  ARGV[0] == "-v" and  ARGV[1] != nil
$cmd = "nmap -T4 -p- -n --script vuln -oN Vuln_Scan_#{ARGV[1]}.txt -oX nmap_#{ARGV[1]}_vuln.xml #{ARGV[1]}" #-A -p- -R
#Bars Setup
$bars = TTY::ProgressBar::Multi.new("Main  Progress [:bar] :percent, :elapsed",head:'>', width: 100)
$synscan = $bars.register("SYN Scan     [:bar] :percent", total: 100)
$servicescan = $bars.register("Service Scan [:bar] :percent", total: 100)
$nsescan = $bars.register("NSE Scan     [:bar] :percent", total: 100)
  PTY.spawn( $cmd ) do |stdout, stdin, pid|
    stdout.each do |line|
    stdin.puts '  '
    scan(line)
#If match, END.
    if line.include? "Nmap done:"
    break
    end
   end
  end
end

#ARGV for half open scan
if  ARGV[0] == "-h" and  ARGV[1] != nil
$cmd = "nmap -T4 -p- -sS -oN HalfOpen_Scan_#{ARGV[1]}.txt -oX nmap_#{ARGV[1]}_hopen.xml #{ARGV[1]}"
#Bars Setup
$bars = TTY::ProgressBar::Multi.new("Main  Progress [:bar] :percent, :elapsed",head:'>', width: 100)
$synscan = $bars.register("SYN Scan     [:bar] :percent", total: 100)
$servicescan = $bars.register("Service Scan(skip) [:bar] :percent", total: 100)
$nsescan = $bars.register("NSE Scan(skip)     [:bar] :percent", total: 100)
  PTY.spawn( $cmd ) do |stdout, stdin, pid|
    stdout.each do |line|
    stdin.puts '  '
    scan(line)
#If match, END.
    if line.include? "Nmap done:"
    break
    end
   end
  end
end
'''
#ARGV validation and help output
if ARGV[0] != "-s" && ARGV[0] != "-c" or ARGV[1] == nil
  puts $pastel.cyan " ruby nmapbar.rb -[switch] TARGET\n"
  puts $pastel.cyan"-s          It will run a well-balanced scan, suitable for most situations. "
  puts $pastel.cyan"            Nmap will run with theses flags enabled -sV -sC -n "
  puts $pastel.cyan"-c          It will run a complete scan, but much slower."
  puts $pastel.cyan"            Nmap will run with these flags enabled -A -p- -n -T4 "
  puts $pastel.cyan"Example:"
  puts $pastel.green.bold"ruby nmapbar.rb -s 10.0.14.5"
end
'''
