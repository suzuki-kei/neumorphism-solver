require 'pathname'

# プロジェクトのルートディレクトリの絶対パス.
ROOT_DIR = Pathname.new(File.absolute_path("#{File.dirname(__FILE__)}/../.."))

# 問題ファイルを保持するディレクトリの絶対パス.
DATA_DIR = ROOT_DIR.join('data')

# キャッシュファイルを保持するディレクトリの絶対パス.
CACHE_DIR = ROOT_DIR.join('cache')

