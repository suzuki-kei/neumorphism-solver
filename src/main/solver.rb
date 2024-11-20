
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

