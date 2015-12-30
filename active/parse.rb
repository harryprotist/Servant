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
    obj[:exec] = server_run if token == "s"
    obj[:exec] = laptop_run if token == "l"
    obj[:exec] = desktop_run if token == "d"
    ctxt = "computer"
  elsif ctxt == "computer"
    if token == "e"
      puts obj[:exec].call(cmd)
      break
    end
    ctxt = "music" if token == "m"
    ctxt = "skype" if token == "s"
    ctxt = "test"  if token == "t"
  elsif ctxt == "music"
    puts obj[:exec].call("mpc pause") if token == "p"
    puts obj[:exec].call("mpc play") if token == "r"  
    puts obj[:exec].call("mpc next") if token == "f"
    puts obj[:exec].call("mpc prev") if token == "b"
    break
  elsif ctxt == "skype"
    puts obj[:exec].call("snotify unread") if token == "u"
    break
  elsif ctxt == "text"
    puts obj[:exec].call("uptime") if token == "u"
    puts obj[:exec].call("w") if token == "w"
    break
  else
    break
  end 
end
