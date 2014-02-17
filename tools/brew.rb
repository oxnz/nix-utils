#!/usr/bin/env ruby
# Copyright (C) 2013 Oxnz, All rights reserved.

require 'net/http'

def help
	puts <<-EOH
Usage: #{$PROGRAM_NAME} <option> [name]
  options:
	-s	--show	show instructions to install package specified by name
	-l	--list	list available packages
	-h	--help	show this help message and exit
	EOH
	0
end

def show(name)
	uri = URI("https://raw.github.com"\
			  "/Homebrew/homebrew/master/Library/Formula/"\
			  "#{name}.rb")
	Net::HTTP.start(uri.host, uri.port,
					:use_ssl => uri.scheme == 'https') do |http|
		request = Net::HTTP::Get.new(uri)
		response = http.request(request)
		errmsg = nil
		puts "[#{name}]\n", '=' * 80
		case response
		when Net::HTTPSuccess, Net::HTTPRedirection
			puts response.body
		when Net::HTTPClientError, Net::HTTPServerError
			errmsg = "*** error code: %s message: %s" \
				% [response.code, response.msg]
		else
			errmsg = "*** error: unexpected response status"
		end
		puts errmsg if errmsg
		puts '-' * 80
		errmsg == nil ? 0 : 1
	end
	0
end

def list
	puts "Unimplemented yet"
	0
end

ARGV << "--help" if ARGV.empty?
ARGV.each do |arg|
	case arg
	when "-h", "--help"
		help
		exit
	when "-l", "--list"
		exit list
	when "-s", "--show"
		ARGV.shift
		ARGV.each {|name| show(name)}
		exit
	else
		puts "*** error: unrecognized parameter: #{arg}"
		exit 1
	end
end
