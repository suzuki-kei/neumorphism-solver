
class Field

    CELL_ON  = '*'
    CELL_OFF = '_'

    TOGGLE_5 = :toggle_5
    TOGGLE_9 = :toggle_9

    def self.toggle_methods
        [TOGGLE_5, TOGGLE_9]
    end

    def self.from_file(file_path)
        from_text(File.read(file_path))
    end

    def self.from_text(text)
        self.new(text.strip.lines.map(&:strip).map(&:chars))
    end

    def self.validate_rows(rows)
        if rows.empty?
            raise ArgumentError, "rows=#{rows}"
        end

        if rows.any? {|row| row.size > 0 and row.size != rows[0].size}
            raise ArgumentError, "rows=#{rows}"
        end

        rows.each do |row|
            row.each do |cell|
                if ![CELL_ON, CELL_OFF].include?(cell)
                    raise ArgumentError, "cell=#{cell}"
                end
            end
        end
    end

    attr_reader :rows

    def initialize(rows)
        self.class.validate_rows(rows)
        @rows = rows
    end

    def ==(field)
        @rows == field.rows
    end

    def to_s
        inspect
    end

    def inspect
        @rows.map(&:join).join("\n")
    end

    def width
        @rows[0].size
    end

    def height
        @rows.size
    end

    def points
        xs = (0 ... width).to_a
        ys = (0 ... height).to_a
        xs.product(ys)
    end

    def solved?
        @rows.all? do |row|
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
            @rows[y][x] = map.fetch(@rows[y][x])
        end
    end

end

