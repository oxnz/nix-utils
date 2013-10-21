#!/usr/bin/env ruby
# -*- coding: binary -*-

f = __FILE__
while File.symlink?(f)
  f = File.expand_path(File.readlink(f), File.dirname(f))
end
@dir = File.expand_path(File.dirname(f))

puts f
puts @dir
puts "version=", RUBY_VERSION, "platform=", RUBY_PLATFORM, "copyright=", \
RUBY_COPYRIGHT, "patchlevel=", RUBY_PATCHLEVEL, "description=", \
RUBY_DESCRIPTION, "releasedate=", RUBY_RELEASE_DATE
if(RUBY_PLATFORM =~ /mswin32/)
  $stderr.puts "[*] do not support windows"
end

PLATFORM = case
           when RUBY_PLATFORM =~ /darwin/
             "darwin"
           when RUBY_PLATFORM =~ /mswin32/
             "windows"
           else
             puts "unkonw system detected"
             "unknonwn"
           end

puts PLATFORM
