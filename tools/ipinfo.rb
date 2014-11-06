#!/usr/bin/env ruby -w
# author: Oxnz
# mail: yunxinyi@gmail.com
# inspect ip info over Internet

require 'optparse'
require 'ipaddr'
require 'net/http'
require 'json'

class Location
	def initialize(locstr)
		@lon, @lat = locstr.split(',').collect { |s| s.to_f }
	end

	def to_s
		"lat: #{@lat}, lon: #{@lon}"
	end
end

#What is a bogon address?
#"Bogon" is an informal name for an IP packet on the public Internet that claims to be from an area of the IP address space reserved, but not yet allocated or delegated by the Internet Assigned Numbers Authority (IANA) or a delegated Regional Internet Registry (RIR).  The areas of unallocated address space are called "bogon space".  Many ISPs and end-user firewalls filter and block bogons, because they have no legitimate use, and usually are the result of accidental or malicious misconfiguration.  Bogons can be filtered by using router ACLs, or by BGP blackholing.
#ref: http://www.apnic.net/services/services-apnic-provides/registration-services/resource-quality-assurance/bogon-address-pop-up

class IPInfo
	AVAILABLE_KEYS = [:ip, :hostname, :city, :region, :country, :loc, :org]
	def initialize(ip = nil, url = 'http://ipinfo.io', format = 'json')
		if ip.nil?
			url = URI("#{url}/#{format}")
		else
			url = URI("#{url}/#{ip}/#{format}")
		end
		resp = Net::HTTP.get_response(URI(url))
		@info = {}
		JSON.parse(resp.body) .each { |k, v|
			fail ArgumentError, 'bogon address', caller if k.eql?('bogon')
			k = k.to_sym
			#warn "key '#{k}' has no value" if v.nil?
			if AVAILABLE_KEYS.include?(k)
				case k
				when :loc
					@info[k] = Location.new v
				else
					@info[k] = v
				end
			else
				@info[k] = v
				warn "unexpected key: #{k}(value: #{v})"
			end
		}
	end

	def each(keys = [])
		if keys.empty?
			keys = AVAILABLE_KEYS
		end
		keys = keys.uniq
		keys.each { |k|
			fail KeyError, "no such key: #{k}", caller unless @info.key?(k)
			yield k, @info[k]
		}
	end
end

def getopts
	options = {
		keys: []
	}
	OptionParser.new do |opts|
		opts.banner += ' [ip]'
		opts.separator 'This program is used to retrieve information by ip over Internet'
		opts.separator '  Options:'
		opts.version = '0.0.1'
		opts.release = 'beta'

		opts.on('-m', '--multiple', 'generate report') {
			options[:m] = true
		}
		opts.on('-i', '--ip IP', 'IP address') {
			|ip| options[:ip] = IPAddr.new ip
		}
		opts.on('-k', '--key KEY', IPInfo::AVAILABLE_KEYS, 'Retrieve info for KEY') {
			|arg| options[:keys] << arg
		}
		opts.on('-h', '--help', 'Show this message and exit') {
			puts opts.help
			exit
		}
		opts.on('-v', '--version', 'Show version info and exit') {
			puts opts.ver
			exit
		}
		opts.parse!
	end
	options
end

def main
	opts = getopts
	case ARGV.length
	when 0
		info = IPInfo.new opts.fetch(:ip, nil)
		info.each opts[:keys] { |k, v| printf "%-8s => %s\n", k, v }
	else
		fail ArgumentError, 'too many argument(s) (try --help)', caller
	end
end

if __FILE__ == $0
	begin
		main
	rescue Interrupt => e
		$stderr.puts "Interrupted"
		exit 1
	rescue OptionParser::ParseError => e
		$stderr.puts "#{$0}: #{e}"
		$stderr.puts '(try -h or --help to see usage)'
		exit 1
	rescue => e
		$stderr.puts "#{$0}: #{e}"
		exit 1
	else
		exit
	ensure
		# do nothing
	end
end
