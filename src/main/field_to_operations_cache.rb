require 'field'

class FieldToOperationsCache

    def initialize
        @cache = {}
        @generate_arguments = {}
    end

    def generate(width, height, max_depth)
        arguments = [width, height, max_depth]
        return if @generate_arguments.key?(arguments)

        @generate_arguments[arguments] = true
        field = Field.from_size(width, height, Field::CELL_OFF)
        generate_recursively(field, [], max_depth)
    end

    def [](field)
        @cache[field]
    end

    def []=(field, operations)
        @cache[field] = operations
    end

    private

    def generate_recursively(field, operations, max_depth, depth=1)
        return if depth > max_depth
        return if @cache.key?(field)

        Field.toggle_methods.product(field.points).each do |toggle_method, (x, y)|
            field.touch(toggle_method, x, y)
            operations.push([toggle_method, x, y])
            generate_recursively(field, operations, max_depth, depth + 1)
            @cache[field.clone] = [@cache[field], operations.reverse].compact.min_by(&:size)
            field.touch(toggle_method, x, y)
            operations.pop
        end
    end

end

