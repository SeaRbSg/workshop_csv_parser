require 'pp'

def csv_parser(file_data, delimiter: ',')
  output = []
  lines = file_data.split("\n")
  lines.each do |line|
    row_output = []
    values = line.split(delimiter, -1)
    escaped = false
    current_value = ''
    values.each do |value|
      current_value += value
      escaped = !escaped if value =~ /"/
      if escaped
        current_value += delimiter
      else
        current_value.tr!('"', '')
        current_value = nil if current_value == ''
        row_output << current_value
        current_value = ''
      end
    end
    output << row_output
  end
  output
end

require 'minitest/autorun'
require 'csv'

# Tests
class CSVParserTest < Minitest::Test
  def test_cat_breeds
    csv_data = File.read('cat_breeds.csv')
    assert_equal csv_parser(csv_data, delimiter: ','),
                 CSV.parse(csv_data)
  end

  def test_dogs
    csv_data = File.read('dogs.csv')
    assert_equal csv_parser(csv_data, delimiter: ','),
                 CSV.parse(csv_data)
  end

  def test_dinosaurs
    csv_data = File.read('dinosaurs.csv')
    assert_equal csv_parser(csv_data, delimiter: "\t"),
                 CSV.parse(csv_data, col_sep: "\t")
  end
end
