#!/usr/bin/env ruby

require 'solaris/utmpx'

io = File.open(ARGV[0], 'r')
reader = Solaris::Utmpx.new(:endian => :little)
while !io.eof? do
  record = reader.read(io)
  print record.to_binary_s unless record.ut_user == 'root'
end

