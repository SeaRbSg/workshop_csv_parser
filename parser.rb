# read data in string

class CSVParser
  attr_reader :data, :current_row, :current_field, :position, :in_quotes,
    :field_delimiter, :quote_delimiter, :string

  def initialize(string, field_delimiter = ',', quote_delimiter = '"')
    @data = []
    @current_row = []
    @current_field = ""
    @string = string
    @position = 0
    @in_quotes = false
    @field_delimiter = field_delimiter
    @quote_delimiter = quote_delimiter
  end

  def parse
    while position < string.length
      consume_character
    end

    current_row << current_field unless current_field.empty?
    data << current_row unless current_row.empty?

    data
  end

  private

  def consume_character
    t = string[position]
    if t == quote_delimiter
      consume_quote
    elsif !in_quotes && t == field_delimiter
      current_row << current_field
      @current_field = ""
    elsif !in_quotes && t == "\n"
      current_row  << current_field
      data << current_row
      puts current_row.inspect
      @current_row = []
      @current_field = ''
    else
      current_field << t
    end
    @position += 1
  end

  def consume_quote
    if in_quotes
      next_character = string[position + 1] rescue ''
      if next_character == quote_delimiter
        current_field << quote_delimiter
        @position += 1
      else
        @in_quotes = false
      end
    else
      @in_quotes = true
    end
  end
end

# def csv_parser(string,field_delimiter,quote_delimiter)
#
#   data = []
#   current_row = []
#   current_field = ""
#   i = 0
#   in_quotes = false
#
#   while i < string.length
#     t = string[i]
#     if t == quote_delimiter
#       if in_quotes
#         next_character = string[i + 1] rescue ''
#         if next_character == quote_delimiter
#           current_field << quote_delimiter
#           i += 1
#         else
#           in_quotes = false
#         end
#       else
#         in_quotes = true
#       end
#     elsif !in_quotes && t == field_delimiter
#       current_row << current_field
#       current_field = ""
#     elsif !in_quotes && t == "\n"
#       current_row  << current_field
#       data << current_row
#       puts current_row.inspect
#       current_row = []
#       current_field = ''
#     else
#       current_field << t
#     end
#     i = i + 1
#   end
#
#   current_row << current_field unless current_field.empty?
#   data << current_row unless current_row.empty?
#
#   data
# end

csv_data = File.read("cars.csv") ; csv_data.length
puts CSVParser.new(csv_data).parse.inspect
