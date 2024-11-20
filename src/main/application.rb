require 'constants'
require 'field'
require 'solver'

class Application

    def run
        DATA_DIR.glob('*.txt').each do |file_path|
            puts "==== #{file_path.basename}"
            field = Field.from_file(file_path)
            if operations = Solver.new.solve(field)
                operations.each do |toggle_method, x, y|
                    puts "#{toggle_method} (x=#{x}, y=#{y})"
                end
            else
                puts 'solve failed.'
            end
        end
    end

end

