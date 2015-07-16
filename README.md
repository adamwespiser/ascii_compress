# ascii_compress
A Ruby library for compressing ascii characters into hex strings



### INSTALLATION:
gem build ascii_to_hex.gemspec && gem install ./ascii_to_hex-0.0.1.gem


### Usage:
```as = Ascii_to_hex_obj.new(alpha,default_char = default)   
hex_coding,msg_f = as.ascii_str_to_hex(msg)
msgc = as.hex_to_ascii_str(hex_coding)```
