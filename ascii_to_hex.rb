#!/usr/bin/ruby


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

def test_msgs
		msgs = [ all_chars(),
						"aa ",
						" aa",
						"\"\"\"",
						"\'\' " ]

		failed = msgs.select { |msg| msg != conv_deconv(msg) }
		if failed.length == 0
				puts "all #{msgs.length} tests passed\n"
		else 
				failed.each {|msg| puts "FAILED: #{msg}\n"}
		end
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


