require 'field'

class FieldTextParser

    def parse(text)
        parse_text_to_field(text)
    end

    private

    def parse_text_to_field(text)
        lines = text.strip.lines.map(&:strip)
        parse_lines_to_field(lines)
    end

    def parse_lines_to_field(lines)
        if lines.empty?
            raise ArgumentError, "lines=#{lines}"
        end

        if lines.any? {|line| line.size > 0 and line.size != lines[0].size}
            raise ArgumentError, "lines=#{lines}"
        end

        lines.map(&method(:parse_line_to_field_row))
    end

    def parse_line_to_field_row(line)
        line.chars.map do |c|
            case c
                when Field::CELL_ON
                    Field::CELL_ON
                when Field::CELL_OFF
                    Field::CELL_OFF
                else
                    raise ArgumentError, "c='#{c}'"
            end
        end
    end

end

