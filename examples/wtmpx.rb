#!/usr/bin/env ruby

require 'solaris/utmpx'

io = File.open(ARGV[0], 'r')
reader = Solaris::Utmpx.new(:endian => :little)
while !io.eof? do
  puts reader.read(io)
end

