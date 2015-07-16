#!/usr/bin/ruby

require 'pry'


# AW NOTES:
#  Usable ascii range (inclusivce) (32 - 126) (' ' - '~')


# convert a string to an array of ints representing the ascii code(0-31 are command keys)
def string_to_ord(str)
 ord_array = []
 str.each_byte { |x| ord_array << x }
 return ord_array
end 

# do the reverse
def ord_to_string(ord_array)
		ord_array.collect { |x| x.chr}.join
end


# f("1",7) => "0000001"
def buffer_zeros(str,len)
		if  (str.length % len) != 0
				buff_str = ("0" * (len - (str.length % len)) +  str)
		else
				buff_str = str
    end
		return buff_str
end


# convert each ascii character to a bit representation, then concat
# note: all chars have a specified length of bit representation
def ascii_to_bit_string(chr, length=7, conv = lambda { |arg| arg - 31 })

		# call the conversion function
		chr_ord = conv.call(chr.ord)

		#get a raw bit string
    bit_string_raw  = chr_ord.to_s(2)
    #puts bit_string_raw.length

		# make sure the bit string is of uniform length(ex "10" should be "0000010"
		return buffer_zeros(bit_string_raw,length)
end

# convert a string to to hex or integer representation
def string_to_encoding(str)
		char_int_array = str.chars.map { |c| ascii_to_bit_string(c) }
		#convert to int
		int_rep = char_int_array.reverse.join.to_i(2)
		return [int_rep.to_s(16),int_rep]
end

def encoding_to_string(hex_str)
		# convert hex string into binary string
		bit_string_raw  = hex_str.to_i(16).to_s(2)
		bit_string = buffer_zeros(bit_string_raw,7)
		# break up bit_string into 7-bit sized words
		bit_array = bit_string.scan(/.{7}/)
		str = ""
		bit_array.each { |i| 
				char = (i.to_i(2) + 31).chr
				str << char
		}
		
		return str.reverse
end


# yeild bits from hex string
def y_bits(hex_str,len)
		bit_string_raw  = hex_str.to_i(16).to_s(2)
		bit_string = buffer_zeros(bit_string_raw,len)
		# break up bit_string into 7-bit sized words
		bit_array = bit_string.scan(/.{#{len}}/)
		str = ""
		#puts "bit array = [ "
		bit_array.each { |i| yield i }
		return
end
# y_bits(string_to_encoding(all_chars())[0], 7) { |x| puts x}


### TESTING


def all_chars
		return (32..126).collect{ |i| i.chr}.join
end


def conv_deconv(word)
		return encoding_to_string(string_to_encoding(word)[0])
end


def compare_to_pack(str=all_chars())
		upack_len =  str.unpack("h*")[0].length
		conv_len = string_to_encoding(str)[0].length
		savings = conv_len * 1.0 / upack_len 
		puts "stored ascii in #{savings} proportion of space\n"
end

# app conversion between ascii string, and hex representation
# in the hex representation, each ascii character only takes up 7 bits
def string_to_encoding_via_int_rep(str)
		# ascii check
		# map the string to ints between 1 and 95
		ord_array = string_to_ord(str).map { |i| i - 31 }
		#puts ord_array
		
		# this next block is going to d
		sum = shift = 0
		ord_array.each { |i| 
				y = (i << shift);
				#puts "#{i} -> #{y} -> #{i.to_s(2)}\n"
				shift = shift + 7; 
				sum = sum + y }
		#puts sum
		hex_sum = sum.to_s(16)
		return [hex_sum,sum]
end




class Ascii_to_hex_obj
		def initialize(char_set, default_char="X")
				@chrs = char_set.downcase.uniq
				if default_char != nil and @chrs.index(default_char) == nil
						@chrs = @chrs + default_char
				end
				@len = @chrs.length 
				@bits = Math.log2(@len + 1).ceil.to_i
				@default_char = default_char
		end

		def valid_char?(char)
				return (@chrs.index(char) != nil)
		end

		def format_string(str)
				str = str.force_encoding("UTF-8")
				raise "must provide an ASCII string to format" if not str.ascii_only?
				str.downcase!
				str_fmt_arr = str.scan(/.{1}/).map do |x|
						if self.valid_char?(x) or @default_char == nil
								x
						else
								@default_char
						end
				end
				return str_fmt_arr
		end
		def char_to_bit_string(chr)
				chr_ord = @chrs.index(chr) + 1
				bit_string_raw  = chr_ord.to_s(2)
				return buffer_zeros(bit_string_raw, @bits)
		end

		def bit_string_to_char(bit_str)
				int = bit_str.to_i(2)
				if int.between?(1,@len)
						return @chrs[int - 1]
				else 
						raise "Failed to decode hexstring, index out of range"
				end
		end

		def chr_array_to_hex(chr_array)
				char_int_array = chr_array.map { |c| self.char_to_bit_string(c) }
				#convert to int
				int_rep = char_int_array.join.to_i(2)
				int_rep.to_s(16)
		end

		def ascii_str_to_hex(str)
			fmt_array = self.format_string(str)	
		  return [self.chr_array_to_hex(fmt_array),fmt_array.join]
		end
		# yeild bits from hex string
		def yield_bits(hex_str)
				bit_string_raw  = hex_str.to_i(16).to_s(2)
				bit_string = buffer_zeros(bit_string_raw,@bits)
				bit_array = bit_string.scan(/.{#{@bits}}/)
			  	
				#puts "bit array = [ "
				bit_array.each { |i| yield i }
				return
		end
		
		def hex_to_ascii_str(hex_str)
        msg_str = ""
				self.yield_bits(hex_str) { |bs| msg_str << self.bit_string_to_char(bs) }
				puts msg_str
				return msg_str
		end
end
# y_bits(string_to_encoding(all_chars())[0], 7) { |x| puts x}





def check_coding(msg, alpha)
		as = Ascii_to_hex_obj.new(alpha)
		hex_coding,msg = as.ascii_str_to_hex(msg)
		msgc = as.hex_to_ascii_str(hex_coding)	
		puts "msg     = '#{msg}'\nhex     = '#{hex_coding}'\ndecoded = '#{msgc}'\n"
end

binding.pry


