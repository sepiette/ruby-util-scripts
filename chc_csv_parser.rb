require 'pry'
require 'csv'
require 'json'

# Class that allows us to parse Change Healthcare responses that come from our event logger in redshift
# Call ChcCsvParser.new(file_name) with the file name of the csv you want to parse.
# You can also write the parsed data to a JSON

class ChcCsvParser
  def initialize(name)
    @file_name = name
    @parsed_arr = []
  end

  def parse_csv
    csv_text = File.read("#{@file_name}")
    csv = CSV.parse(csv_text, headers: true, header_converters: :symbol, encoding: "UTF-8")
    success_count = 0
    error_count = 0
    csv.each do |row|
      begin
        payload = JSON.parse(row[:response_payload])
        payload.to_h
        raw_response = payload["raw_response"]
        raw_response.gsub!("=\u003e", ":")
        payload["raw_response"] = JSON.parse(raw_response).to_h
        @parsed_arr << payload

        puts "completed row #{success_count + 1} of #{csv.size}"
        success_count += 1
      rescue => e
        puts "error on row"
        error_count += 1
      end
    end
    puts "Successfully parsed #{success_count} of #{csv.size}"
    puts "Failed on #{error_count} of #{csv.size}"
    @parsed_arr
  end

  def write_to_json
    File.open("#{@file_name}.json", 'w') do |f|
      f.write("[")
      @parsed_arr.each do |row|
        f.write("#{row.to_json},")
      end
      f.write("]")
    end
  end
end