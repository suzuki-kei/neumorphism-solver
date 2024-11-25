require 'field_to_operations_cache'

class Solver

    def initialize
        @field_to_operations_cache = FieldToOperationsCache.new
    end

    def solve(field)
        @field_to_operations_cache.generate(field.width, field.height, 4)
        operations = @field_to_operations_cache[field]
        return operations unless operations.nil?

        operations_queue = []
        operations_queue.push([])

        loop do
            operations = operations_queue.shift

            if solved_operations = execute(field.clone, operations)
                return solved_operations
            end

            Field.toggle_methods.product(field.points).each do |toggle_method, (x, y)|
                operations_queue.push([*operations, [toggle_method, x, y]])
            end
        end
    end

    private

    def execute(field, operations)
        operations.each.with_index do |operation, index|
            field.touch(*operation)
            if trailing_operations = @field_to_operations_cache[field]
                solved_operations = operations[0..index] + trailing_operations
                @field_to_operations_cache[field] = solved_operations
                return solved_operations
            end
        end

        if field.solved?
            operations
        else
            nil
        end
    end

end

