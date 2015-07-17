#!/usr/bin/ruby

require_relative "../lib/ascii_to_hex"
require "test/unit"
 
def std_alpha
	lower = (97..122).collect  { |x| x.chr }.join
	lower += ".!? "
	return lower
end

class TestSimpleNumber < Test::Unit::TestCase


	def test_std_alpha
		alpha = std_alpha
		default_char = 'X'
		nodefs = ["hallie", "evans", "bttf", "bravotangotangofoxtrot",
						  "check the email account",
			        "hey, hows it going?", "whats up dude!?!", "groovey, baby",
						  "once there was a way to get back **home**"]

		nodefs_f = ["hallie", "evans", "bttf", "bravotangotangofoxtrot",
						  "check the email account",
			        "heyX hows it going?", "whats up dude!?!", "grooveyX baby",
						  "once there was a way to get back XXhomeXX"]

		as = Ascii_to_hex_obj.new(alpha,default_char)
		assert_equal(as.bits,5)					
		nodefs.zip(nodefs_f).each do |msg,msg_f|
			hex_coding,msg_f_o = as.ascii_str_to_hex(msg)
			msgc = as.hex_to_ascii_str(hex_coding)  
			assert_equal(msg_f, msg_f_o)
			assert_equal(msgc, msg_f)
		end
	end



  def test_fun
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
