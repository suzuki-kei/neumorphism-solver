# Neumorphism solver

Neumorphism というゲームを解くプログラムです.

 * Neumorphism / 凹凸 (https://apps.apple.com/jp/app/neumorphism/id1497264656?l=en-US)

# 実行方法

    # テストを実行する
    make test

    # 全ての問題を解く
    make run

    # キャッシュを削除する
    make clean

# 問題データの追加方法

問題データは ./data/ ディレクトリ直下にテキストファイルとして保存します.
ファイルの内容はフィールドの初期状態です.
各セルの凹凸を `_` または `*` で指定します.

例:

    _*_
    ***
    _*_

