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

def ssh_run(port, str)
  `ssh -p #{port} -o ConnectTimeout=5 ben@localhost 'source ~/.zshrc; #{str}'`
end

laptop_run = Proc.new do |str|
  ssh_run("8667", str)
end

desktop_run = Proc.new do |str|
  ssh_run("8666", str)
end

server_run = Proc.new do |str|
  `#{str}`
end

def eat(str)
  if str =~ /^\s*(\w*)(\s*$|\s+(.*))/
    if NATO.keys.include? ($1).downcase
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


def ActiveParse(cmd)

  ctxt = ""
  obj = {}
  ret = ""

  while true
    token, cmd = eat(cmd)
    if ctxt == ""
      obj[:exec] = case token
        when "l"; laptop_run
        when "s"; server_run
        when "d"; desktop_run
        else
          ctxt = case token
            when "i"; "info"
            else; "error"
            end
          next
        end
      ctxt = "computer"
    elsif ctxt == "computer"
      if token == "e"
        ret = obj[:exec].call(cmd)
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
      ret = case token
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
      if token == "u"; ret = obj[:exec].call("snotify unread")
      else
        ctxt = "error"
        next
      end
      break
    elsif ctxt == "test"
      ret = case token
        when "u"; obj[:exec].call("uptime")
        when "w"; obj[:exec].call("w")
        else
          ctxt = "error"
          next
        end
      break
    elsif ctxt == "info"
      ret = case token
        when "r"
          `ssh -q -p 8667 -o ConnectTimeout=5 ben@localhost "echo 'laptop online.'" || echo "laptop down."` +
          `ssh -q -p 8666 -o ConnectTimeout=5 ben@localhost "echo 'desktop online. '" || echo "desktop down."`
        else
          ctxt = "error"
          next 
        end
      break
    else
      ret = "?"
      break
    end 
    if cmd == ""
      ret = "?"
      break
    end
  end
  return ret
end
