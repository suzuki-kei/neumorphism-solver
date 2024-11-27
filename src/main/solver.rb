require 'field_to_operations_cache'

class Solver

    def initialize
        @field_to_operations_cache = FieldToOperationsCache.new
    end

    def solve(field)
        # max_depth=3 の場合に全問題を最速で解決できた.
        #     max_depth=2 の場合は 5m 以上 (計測打ち切り)
        #     max_depth=3 の場合は 19s 程度
        #     max_depth=4 の場合は 35s 程度
        #     max_depth=5 の場合は 9m 以上 (計測打ち切り)
        max_depth = 3
        @field_to_operations_cache.generate(field.width, field.height, max_depth)

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
        executed_field = field.clone

        operations.each.with_index do |operation, index|
            executed_field.touch(*operation)
            if trailing_operations = @field_to_operations_cache[executed_field]
                solved_operations = operations[0..index] + trailing_operations
                @field_to_operations_cache[field] = solved_operations
                return solved_operations
            end
        end

        if executed_field.solved?
            operations
        else
            nil
        end
    end

end

