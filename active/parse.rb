#!/usr/bin/ruby

puts case ARGV[0]
when /^uptime\W*$/i
  `uptime`
when /^execute (.+?)$/i
  `#{$1}`
when /^commit suicide\W*$/i
  `killall ruby`
else
  "" 
end
