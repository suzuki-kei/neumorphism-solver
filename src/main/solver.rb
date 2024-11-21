
class Solver

    def solve(field, max_depth, depth=1, operations=[])
        if field.solved?
            return operations.dup
        end
        if depth > max_depth
            return nil
        end

        best_answer = nil

        field.toggle_methods.product(field.points).each do |toggle_method, (x, y)|
            operations.push([toggle_method, x, y])
            field.touch(toggle_method, x, y)
            if field.solved?
                field.touch(toggle_method, x, y)
                return operations.dup
            end
            if (answer = solve(field, max_depth, depth + 1, operations))
                best_answer = [answer, best_answer || answer].min_by(&:size)
            end
            field.touch(toggle_method, x, y)
            operations.pop
        end

        best_answer
    end

end

