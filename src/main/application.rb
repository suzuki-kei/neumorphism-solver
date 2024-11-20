require 'constants'
require 'field'
require 'solver'

class Application

    def run
        name = 'A01'
        field = Field.from_file(name)
        puts "==== #{name}"
        p field

        [].tap do |touch_sequences|
            Solver.new.solve(field) do |touch_sequence|
                touch_sequences << touch_sequence
            end
            puts "==== answer"
            if touch_sequence = touch_sequences.sort_by(&:size).first
                touch_sequence.each do |x, y, toggle_method|
                    puts "x=#{x}, y=#{y}, toggle_method=#{toggle_method}"
                end
            else
                puts 'solve failed.'
            end
        end
    end

end

