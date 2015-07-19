# ascii_compress
A Ruby library for compressing ascii characters into hex strings



### INSTALLATION:
gem build ascii_to_hex.gemspec && gem install ./ascii_to_hex-0.0.1.gem


### Usage:
```ruby
require 'ascii_to_hex'

as = Ascii_to_hex_obj.new(alpha="abcdefg",default_char = "X")   
msg = "adam wespiser"
hex_coding,format_msg = as.ascii_str_to_hex(msg)
format_msg => "adaXXXeXXXXeX"
hex_coding => "1418885888858"
msgc = as.hex_to_ascii_str(hex_coding)
msgc = "adaXXXeXXXXeX"
```


