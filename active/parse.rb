#!/usr/bin/ruby
NATO = {
  "alpha" => "a",
  "bravo" => "b",
  "charlie" => "c",
  "delta" => "d",
  "echo" => "e",
  "foxtrot" => "f",
  "golf" => "g",
  "hotel" => "h",
  "india" => "i",
  "juliett" => "j",
  "kilo" => "k",
  "lima" => "l",
  "mike" => "m",
  "november" => "n",
  "oscar" => "o",
  "papa" => "p",
  "quebec" => "q",
  "romeo" => "r",
  "sierra" => "s",
  "tango" => "t",
  "uniform" => "u",
  "victor" => "v",
  "whiskey" => "w",
  "x-ray" => "x",
  "yankee" => "y",
  "zulu" => "z"
}

laptop_run = Proc.new do |str|
  `ssh -p 8667 ben@localhost 'source ~/.zshrc; #{str}'`
end

desktop_run = Proc.new do |str|
  `ssh -p 8666 ben@localhost 'source ~/.zshrc; #{str}'`
end

server_run = Proc.new do |str|
  `#{str}`
end

def eat(str)
  if str =~ /^\s*(\w*)(\s*$|\s+(.*))/
    if NATO.keys.include? $1
      ret = NATO[($1).downcase]
      str = $3
      return ret, str
    end
  end
  if str =~ /^\s*(\w)(.*)/
    ret = $1
    str = $2
  else
    ret = ""
    str = ""
  end
  return ret, str.downcase
end

cmd = ARGV[0]
ctxt = ""
obj = {}

while cmd != ""
  token, cmd = eat(cmd)
  if ctxt == ""
    obj[:exec] = case token
      when "l"; laptop_run
      when "s"; server_run
      when "d"; desktop_run
      else
        ctxt = "error"
        next
      end
    ctxt = "computer"
  elsif ctxt == "computer"
    if token == "e"
      puts obj[:exec].call(cmd)
      break
    end
    ctxt = case token
      when "m"; "music"
      when "s"; "skype"
      when "t"; "test"
      else
        ctxt = "error"
        next
      end
  elsif ctxt == "music"
    puts case token
      when "p"; obj[:exec].call("mpc pause")
      when "r"; obj[:exec].call("mpc play")
      when "f"; obj[:exec].call("mpc next")
      when "b"; puts obj[:exec].call("mpc prev")
      else
        ctxt = "error"
        next 
      end
    break
  elsif ctxt == "skype"
    if token == "u"; puts obj[:exec].call("snotify unread")
    else
      ctxt = "error"
      next
    end
    break
  elsif ctxt == "text"
    puts case token
      when "u"; obj[:exec].call("uptime")
      when "w"; obj[:exec].call("w")
      else
        ctxt = "error"
        next
      end
    break
  else
    puts "?"
    break
  end 
end
