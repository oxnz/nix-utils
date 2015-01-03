require 'optparse'

$0 = File.basename($0)

# keywords
CODES = %w[iso-2022-jp shift_jis euc-jp utf8 binary]
CODE_ALIASES = {"jis" => "iso-2022-jp", "sjis" => "shift_jis"}
POSSIBLE_CODES = "(#{(CODES+CODE_ALIASES.keys).join(',')})"

vars = {}
ARGV.options do
  |opts|
  opts.banner = "Usage: #{$0} [options] argv...\n"

  # separater
  opts.on_tail
  opts.on_tail("common options:")

  # no argument, shows at tail
  opts.on_tail("--help", "show this message") {puts opts; exit}

  # limit argument syntax
  opts.on("-[0-7]", "-F", "--irs=[OCTAL]", OptionParser::OctalInteger,
	  "specify record separator", "(\\0, if no argument)") {}

  # boolean switch with optional argument(default false)
  opts.on("-v", "--[no-]verbose=[FLAG]", "run verbosely") {}

  # easy way, set local variable
  opts.on("-q", "--quit", "quit when ARGV is empty") {}

  # adding on the fly
  #opts.on("--add=SWITCH=[ARG]", "add option on the fly", /\A(\w+)(?:=.+)?\Z/) do
  #  |opt, var|
  #  opts.on("--#{opt}", "added in runtime", &eval("proc {|vars[:#{var}]|}"))
  #end

  opts.on_head("specific optins:")

  # no argument
  opts.on_tail("--version", "show version") do
    puts OptionParser::Version.join('.')
    exit
  end
  opts.parse!
end

if (Fixnum === :-)
  class << vars
    def inspect
      "{" + collect {|k,v| ":#{k.id2name}=>#{v.inspect}"}.join(", ") + "}"
    end
  end
end
p vars
(puts ARGV.options; exit) if vars[:quit]
ARGV.options = nil		# no more parse
puts "ARGV = #{ARGV.join(' ')}" if !ARGV.empty?
#opts.variable.each {|sym| puts "#{sym} = #{opts.send(sym).inspect}"}
