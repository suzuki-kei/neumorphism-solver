
class Solver

    def initialize
        @solved_cache = {}
    end

    def solve(field)
        operations_queue = []
        operations_queue.push([])

        loop do
            operations = operations_queue.shift
            return operations if solved?(field, operations)

            Field.toggle_methods.product(field.points).each do |toggle_method, (x, y)|
                operations_queue.push([*operations, [toggle_method, x, y]])
            end
        end
    end

    private

    def solved?(field, operations)
        @solved_cache[field] ||= execute(field, operations).solved?
    end

    def execute(field, operations)
        field.clone.tap do |field|
            operations.each do |operation|
                field.touch(*operation)
            end
        end
    end

end

