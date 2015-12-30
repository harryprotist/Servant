#!/usr/bin/ruby

require 'yaml'
require 'net/http'
require 'uri'
require 'digest/sha1'

def update?(name, site)
  file = "data/update/#{name}.sha1"
  old = File.exists?(file)? IO.read(file):""
  new = Digest::SHA1.hexdigest(Net::HTTP.get(URI.parse(site)))
  open(file, "w") { |f| f << new } unless old == new
  return old != new
end

def get_sites(file)
  return YAML.load(IO.read(file))["sites"].each do |k, v|
    [k, v]
  end
end

def ActiveUpdates()
  ret = ""
  get_sites("conf/updates.yml").each do |s|
    ret = "#{s[0]} - #{s[1]}" if update?(s[0], s[1])
  end
  return ret
end
