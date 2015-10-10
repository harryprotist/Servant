#!/usr/bin/ruby

class ActiveParse

  def self.run(input)
    case input
    when /^uptime\W*$/i
      `uptime`
    when /^execute (.+?)$/i
      `#{$1}`
    when /^commit suicide\W*$/i
      `killall ruby`
    else
      "" 
    end
  end

end
