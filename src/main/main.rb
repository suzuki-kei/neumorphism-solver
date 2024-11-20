require 'pathname'

ROOT_DIR = Pathname.new(File.absolute_path("#{File.dirname(__FILE__)}/../.."))
DATA_DIR = ROOT_DIR.join('data')

def main
    name = 'A00.txt'
    field = Field.from_file(name)
    puts "==== #{name}"
    p field

    [].tap do |touch_sequences|
        Solver.new.solve(field) do |touch_sequence|
            touch_sequences << touch_sequence
        end
        puts "==== answer"
        if touch_sequence = touch_sequences.sort_by(&:size).first
            touch_sequence.each do |x, y, toggle_method|
                puts "x=#{x}, y=#{y}, toggle_method=#{toggle_method}"
            end
        else
            puts 'solve failed.'
        end
    end
end

class Solver

    def solve(field, max_depth=4, depth=1, touch_sequence=[], &block)
        if field.solved?
            return :finish if block.call(touch_sequence.dup) == :finish
        end
        if depth > max_depth
            return :continue
        end

        field.points.each do |(x, y)|
            field.toggle_methods.each do |toggle_method|
                touch_sequence.push([x, y, toggle_method])
                field.touch(x, y, toggle_method)
                if field.solved?
                    return :finish if block.call(touch_sequence.dup) == :finish
                end
                if solve(field, max_depth, depth + 1, touch_sequence, &block) == :finish
                    return :finish
                end
                field.touch(x, y, toggle_method)
                touch_sequence.pop
            end
        end
    end

end

class Field

    CELL_ON  = '*'
    CELL_OFF = '_'

    TOGGLE_5 = :toggle_5
    TOGGLE_9 = :toggle_9

    def self.name_to_file_path(name)
        DATA_DIR.join("#{name}.txt")
    end

    def self.from_file(name)
        self.new(File.read(name_to_file_path(name)))
    end

    def initialize(text)
        @field = FieldTextParser.new.parse(text)
    end

    def to_s
        inspect
    end

    def inspect
        @field.map(&:join).join("\n")
    end

    def width
        @field[0].size
    end

    def height
        @field.size
    end

    def points
        xs = (0 ... width).to_a
        ys = (0 ... height).to_a
        xs.product(ys)
    end

    def toggle_methods
        [TOGGLE_5, TOGGLE_9]
    end

    def solved?
        @field.all? do |row|
            row.all? do |cell|
                cell == CELL_OFF
            end
        end
    end

    def touch(x, y, toggle_method)
        case toggle_method
            when TOGGLE_5
                toggle(x, y)
                toggle(x, y - 1)
                toggle(x, y + 1)
                toggle(x - 1, y)
                toggle(x + 1, y)
            when TOGGLE_9
                toggle(x - 1, y - 1)
                toggle(x - 1, y)
                toggle(x - 1, y + 1)
                toggle(x, y - 1)
                toggle(x, y)
                toggle(x, y + 1)
                toggle(x + 1, y - 1)
                toggle(x + 1, y)
                toggle(x + 1, y + 1)
            else
                raise "Invalid argument: toggle_method=#{toggle_method}"
        end
    end

    private

    def inside_of_field?(x, y)
        (0 <= x and x < width) and (0 <= y and y < height)
    end

    def toggle(x, y)
        map = {
            CELL_ON  => CELL_OFF,
            CELL_OFF => CELL_ON,
        }
        if inside_of_field?(x, y)
            @field[y][x] = map.fetch(@field[y][x])
        end
    end

end

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
            raise "Invalid argument: [#{text}]"
        end

        if lines.any? {|line| line.size == 0 and line.size != lines[0].size}
            raise "Invalid argument: [#{text}]"
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
                    raise "Invalid argument: [#{c}]"
            end
        end
    end

end

main if $0 == __FILE__

