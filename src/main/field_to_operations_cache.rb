require 'field'

class FieldToOperationsCache

    def initialize
        @cache = {}
    end

    def generate(width, height, max_depth)
        field = Field.from_size(width, height, Field::CELL_OFF)
        operations_queue = []
        operations_queue.push([])

        until operations_queue.empty?
            operations = operations_queue.shift
            executed_field = execute(field.clone, operations)
            next if @cache.key?(executed_field)
            @cache[executed_field] = operations.reverse

            if operations.size < max_depth
                Field.toggle_methods.product(field.points).each do |toggle_method, (x, y)|
                    operations_queue.push([[toggle_method, x, y], *operations])
                end
            end
        end
    end

    def [](field)
        @cache[field]
    end

    def []=(field, operations)
        @cache[field] = operations
    end

    private

    def execute(field, operations)
        field.tap do
            operations.each do |operation|
                field.touch(*operation)
            end
        end
    end

end

