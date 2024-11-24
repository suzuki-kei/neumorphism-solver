
class Solver

    def solve(field)
        operations_queue = []
        operations_queue.push([])

        loop do
            operations = operations_queue.shift
            return operations if solved?(field, operations)

            Field.toggle_methods.product(field.points).each do |toggle_method, (x, y)|
                operation = [toggle_method, x, y]
                operations_queue.push([*operations, operation]) if operations_queue.last != operation
            end
        end
    end

    private

    def solved?(field, operations)
        field = field.clone
        operations.each do |operation|
            field.touch(*operation)
        end
        field.solved?
    end

end

