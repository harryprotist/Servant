#!/usr/bin/ruby

require 'xmpp4r'
require 'xmpp4r/client'
require 'socket'
include Jabber

class AgentXMPP

  def run(message)
  # WIP
    reply = Message.new(msg.from, resp)
    reply.type = msg.type
    client.send(reply)
  end

  def connect(user, pass)
    jid = JID.new(user)
    client = Client.new(jid)

    client.connect 
    client.auth(pass)
    client.send(Presence.new.set_type(:availible))
    puts "connected as: #{user}"
    
    return client
  end

  def respond(client, msg)
    puts "processing message"
    unless msg.body.nil? and msg.type != :error
      puts "recv: #{msg.body.chomp}"
      resp = `ruby active/parse.rb "#{msg.body}"`
      puts "send: #{resp}" 
      if $?.success?
        resp = "?" if resp.chomp.length == 0
        reply = Message.new(msg.from, resp)
        reply.type = msg.type
        client.send(reply)
      end
    end
  end

  def initialize

    auth = IO.readlines('auth/xmpp').map {|x| x.chomp }

    cli = connect(auth[0], auth[1])
    cli.add_message_callback {|m| respond(cli, m) }
    puts "registered callback"

  end

end
