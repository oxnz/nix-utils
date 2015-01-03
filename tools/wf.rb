#!/usr/bin/env ruby -w
#
# author: Oxnz
# mail: yunxinyi@gmail.com
# weather forecast

require 'optparse'
require 'optparse/time'
require "net/http"
require "json"

fmtime = lambda { |ts| Time.at(ts).strftime("%F %T %Z") }

class Location
	ID = :id
	COORD = :coord
	NAME = :name # city and country
	def initialize(form, data)
		unless data.is_a? Hash
			fail ArgumentError, "invalid data form(#{data.class}), Hash needed", caller
		end
		case form
		when ID
			@id = Integer(data[:id]) rescue nil
			fail ArgumentError, "invalid id: #{data[:id]}", caller if @id.nil?
			@data = {id: @id}
		when COORD
			@lat = Float(data[:lat]) rescue nil
			fail ArgumentError, "invalid latitude: #{data[:lat]}", caller if @lat.nil?
			@lon = Float(data[:lon]) rescue nil
			fail ArgumentError, "invalid longtitude: #{data[:lon]}", caller if @lon.nil?
			@data = {lat: @lat, lon: @lon}
		when NAME
			@city = data[:city]
			fail ArgumentError, "invalid city: #{@city}", caller if @city.empty?
			@country = data[:country]
			fail ArgumentError, "invalid country: #{@country}", caller if @country.empty?
			@data = {city: @city, country: @country}
		else
			fail ArgumentError, "unknown form: #{form}", caller
		end
		@form = form
	end

	def encode
		"not implemented yet"
	end

	def to_s
		case @form
		when ID
			s = "#{@id}"
		when COORD
			s = "lat=#{@lat}, lon=#{@lon}"
		when NAME
			s = "city=#{@city}, country=#{@country}"
		end
		s = "#{super} #{@form}(#{s})"
	end
end

class Query
	def initialize(hash = {})
		fail ArgumentError, "hash needed, #{hash.class} provided", caller unless hash.is_a? Hash
		@hash = hash
	end

	def to_s
		return URI.encode(hash.map{ |k, v| "#{k}=#{v}" }.join('&'))
	end
end

class Weather
	def initialize(map)
	end
end

class WeatherReporter
	HISTORY = :history
	CURRENT = :current
	FORECAST = :forecast
	MODELIST = [HISTORY, CURRENT, FORECAST]
	attr_accessor :city
	attr_accessor :country
	attr_accessor :coord
	def initialize(city = 'Guangzhou', country = 'cn', units = 'metric')
		@city = city
		@country = country
		@units = units
		@url = 'http://api.openweathermap.org/data/2.5/weather'
		#@url.query = Query.new { q: "#{city},#{country}", units: "units" }
		#@uri = URI("#{@url}#{query}")
		#res = Net::HTTP.get_response(URI('"'${url}'"'))
		#local -r url="${baseurl}?q=${city:-Wuhan},${country:-cn}&units=${units:-metric}"
	end

	def current
	end

	def forecast
	end

	def report
		sync
		puts "simple report"
#				printf <<EOF
#	Name: #{res["name"]}(#{res["sys"]["country"]}) coord(lon: #{res["coord"]["lon"]}, lat: #{res["coord"]["lat"]})
#	Sunrise: #{fmtime.call(res["sys"]["sunrise"])}, Sunset: #{fmtime.call(res["sys"]["sunset"])}
#	Weather:
#	EOF
#	if res.is_a?(Net::HTTPSuccess)
#		res = JSON.parse(res.body)
#		res["weather"].each {|w|
#			printf %Q/\tmain: #{w["main"]}, description: #{w["description"]}\n/
#		}
#		printf <<EOF
#	Temp: #{res["main"]["temp"]}(min: #{res["main"]["temp_min"]}, max: #{res["main"]["temp_max"]}), pressure: #{res["main"]["pressure"]}, humidity: #{res["main"]["humidity"]}
#	Wind: #{res["wind"]["speed"]} m/s, deg: #{res["wind"]["deg"]}
#	Clouds: #{res["clouds"]["all"]}
#	EOF
	end

	private
	def sync
		if instance_variable_defined? :@lon
			puts "sync with weather center"
		end
	end
end

def getopts options
	ARGV.delete_if { |opt|
		puts "opt = #{opt}"
		case opt
		when /\A(?:\+|-)[1-9]\d*\Z/
			opt = opt.to_i
			if opt > 0
				options[WeatherReporter::FORECAST] = opt
			else
				options[WeatherReporter::HISTORY] = opt
			end
			true
		else
			false
		end
	}
	p ARGV
	ARGV.options do |opts|
		opts.banner += ''
		opts.separator 'This program is used to retrieve information by ip over Internet'
		opts.separator '  Options:'
		opts.version = '0.0.1'
		opts.release = 'beta'

		opts.on('-h', '--history N', Integer, 'Show weather history within N days') {
			|n|
			k = WeatherReporter::HISTORY
			o = options[k]
			if o.nil?
				options[k] = n
			else
				fail OptionParser::InvalidArgument, "history days count already specified: #{o}", caller
			end
		}
		opts.on('-f', '--forecast [N]', Integer, 'Show weather forecast within N days, N default to 7') {
			|n|
			k = WeatherReporter::FORECAST
			o = options[k]
			if o.nil?
				options[k] = n.nil? ? 7 : n
			else
				fail OptionParser::InvalidArgument, "forecast days count already specified: #{o}", caller
			end
		}
		opts.on('-i', '--id ID', Integer, 'Specify location by city ID') {
			|id|
			options[:locations] = [] unless options.key? :locations
			options[:locations] << Location.new(Location::ID, {id:id})
		}
		opts.on('-l', '--location latitude,longtitude', Array, 'coordinates') {
			|optarg|
			if 2 != optarg.length
				fail OptionParser::InvalidArgument, "invalid coordinates: #{optarg}", caller
			end
			options[:locations] = [] unless options.key? :locations
			options[:locations] << Location.new(Location::COORD, {lat:optarg.first, lon:optarg.last})
		}
		opts.on('-c', '--cc CITY,COUNTRY', Array, 'Specify city and country') {
			|optarg|
			if 2 != optarg.length
				fail OptionParser::InvalidArgument, "invalid city or country: #{optarg}", caller
			end
			options[:locations] = [] unless options.key? :locations
			options[:locations] << Location.new(Location::NAME, {city:optarg.first, country:optarg.last})
		}
		opts.on('-t', '--time [TIME]', Time, 'Request weather info for TIME') {
			|t|
			options[:timelist] = [] unless options.key? :timelist
			options[:timelist] << t
		}
		opts.on('-|+N', 'Request weather info for backward or forward N days') {
			warn '--range option is deprecated, please use +|-N form instead'
			exit 1
		}
		opts.on('-v', 'Output weather information in verbose mode') {
			options[:verbose] = true
		}
		opts.separator '  Common Options:'
		opts.on('--help', 'Show this message and exit') {
			puts opts.help
			exit
		}
		opts.on('--version', 'Show version info and exit') {
			puts opts.ver
			exit
		}
		opts.parse!
	end
	p options
	mandatory = [:from, :to]
	missing = mandatory.select{ |param| options[param].nil? }
	if not missing.empty?
		fail OptionParser::MissingArgument, "Missing option(s): #{missing.join(', ')}", caller
	end
end

def main
	options = {}
	getopts options
	puts "performing task with options: #{options.inspect}"
	reporter = WeatherReporter.new
	reporter.report
end

if __FILE__ == $0
	begin
		main
	rescue OptionParser::InvalidOption, OptionParser::MissingArgument => e
		$stderr.puts "#{$0}: #{e}"
		exit 1
	rescue => e
		$stderr.puts "#{$0}: #{e}"
		puts e.backtrace.join("\n\t")
		exit 1
	end
end
