# ruby-util-scripts
### CHC CSV Parser
**Description**: Used to parse response payload from Change Healthcare
**Example Usage**
```ruby
#!/usr/bin/env ruby
require 'pry'
require_relative 'chc_csv_parser'

args = ARGV
file_name = args[0]
parser = ChcCsvParser.new(file_name)
json_arr = parser.parse_csv
```
