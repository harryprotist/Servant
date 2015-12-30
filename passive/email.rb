#!/usr/bin/ruby

require 'net/smtp'

class AgentEmail

  def run(subject, message, recpt=@recpt)
    message = <<EOF
From: Servant <#{@user}>
To:   Ben     <#{@recpt}>
Subject: #{subject}

#{message}

EOF
    Net::SMTP.start(@server, @port, 'servant', @user, @pass :plain) do |smtp|
      smtp.sendmail(message, @user, [recpt])
    end 
  end

  def initialize
    @server, @port, @user, @pass, @recpt = IO.read("auth/email").split("\n")
  end

end
