Dir.glob("#{File.absolute_path(File.dirname(__FILE__))}/**/test_*.rb").each(&method(:require))

