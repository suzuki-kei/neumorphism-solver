require 'constants'
require 'field'
require 'fileutils'
require 'solver'

class Application

    def run
        DATA_DIR.glob('*.txt').each(&method(:solve))
    end

    private

    def solve(problem_file_path)
        puts "==== #{problem_file_path.basename}"
        result = load_cache(problem_file_path)

        if result
            puts result
            return
        end

        field = Field.from_file(problem_file_path)

        (1..).each do |max_depth|
            if operations = Solver.new.solve(field)
                raise 'Bug' if !solved?(field, operations)
                result = operations_to_string(operations)
                puts result
                save_cache(problem_file_path, result)
                return
            end
        end
    end

    def load_cache(problem_file_path)
        cache_file_path = CACHE_DIR.join(problem_file_path.basename)

        if File.exist?(cache_file_path)
            File.read(cache_file_path)
        else
            nil
        end
    end

    def save_cache(problem_file_path, result)
        FileUtils.makedirs(CACHE_DIR)
        cache_file_path = CACHE_DIR.join(problem_file_path.basename)

        File.open(cache_file_path, 'w') do |file|
            file.write(result)
        end
    end

    def solved?(field, operations)
        operations.each do |toggle_method, x, y|
            field.touch(toggle_method, x, y)
        end
        field.solved?
    end

    def operations_to_string(operations)
        operations.map do |toggle_method, x, y|
            "#{toggle_method} (x=#{x + 1}, y=#{y + 1})"
        end.join("\n")
    end

end

