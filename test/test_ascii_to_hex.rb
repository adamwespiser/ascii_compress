#!/usr/bin/ruby

require_relative "../lib/ascii_to_hex"
require "test/unit"
 
class TestSimpleNumber < Test::Unit::TestCase
 
  def test_simple
		msgs = [ all_chars(),
						"aa ",
						" aa",
						"\"\"\"",
						"\'\' " ]

		msgs.each do |msg|
				assert_equal(msg, conv_deconv(msg))
		end

	end
end



def compare_to_pack(str=all_chars())
		upack_len =  str.unpack("h*")[0].length
		conv_len = string_to_encoding(str)[0].length
		savings = conv_len * 1.0 / upack_len 
		puts "stored ascii in #{savings} proportion of space\n"
end
