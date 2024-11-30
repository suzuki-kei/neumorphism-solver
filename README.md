# Neumorphism solver

Neumorphism を解くプログラム.

 * Neumorphism / 凹凸 (https://apps.apple.com/jp/app/neumorphism/id1497264656?l=en-US)

# 実行方法

    # テストを実行する
    make test

    # ./data/ 以下にある全ての問題を解く
    make run

    # キャッシュを削除する
    make clean

# 問題データの追加方法

問題データはテキストファイルとして作成し, ./data/ 以下に保存する.
ファイルの内容はフィールドの初期状態であり, 各セルの凹凸を '_' または '*' で指定する.

例:

    _*_
    ***
    _*_

