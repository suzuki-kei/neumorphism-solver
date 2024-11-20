require 'pathname'

ROOT_DIR = Pathname.new(File.absolute_path("#{File.dirname(__FILE__)}/../.."))

DATA_DIR = ROOT_DIR.join('data')

CACHE_DIR = ROOT_DIR.join('cache')

