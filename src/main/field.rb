require 'field_text_parser'

class Field

    CELL_ON  = '*'
    CELL_OFF = '_'

    TOGGLE_5 = :toggle_5
    TOGGLE_9 = :toggle_9

    def self.from_file(file_path)
        self.new(File.read(file_path))
    end

    def initialize(text)
        @field = FieldTextParser.new.parse(text)
    end

    def ==(field)
        @field == field.instance_variable_get('@field')
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

    def touch(toggle_method, x, y)
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
                raise ArgumentError, "toggle_method=#{toggle_method}"
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

