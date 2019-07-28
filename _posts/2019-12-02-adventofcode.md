---
title: AdventOfCode 2019/12/02
author: cdddar
---

[adventofcode.com/2019/day/2](https://adventofcode.com/2019/day/2)

## Part 1

言われたとおりをシミュレーションするように実装する。
注意しなきゃいけないのは、
実行前にプログラムの二箇所だけ変更することと（ストーリーを真面目に読んでないから何でか分からない）、
与えられる `position` というのは 0-index であること（ほとんどの言語にとってはむしろありがたい）。

awk は 1-index

```awk
BEGIN {
    FS = ","
}
{
    cur = 1
    $2 = 12
    $3 = 2
    while ($cur != 99) {
        a = $(cur + 1) + 1  # awk は 1-index
        b = $(cur + 2) + 1
        p = $(cur + 3) + 1
        if ($cur == 1) {
            $p = $a + $b
        } else {
            $p = $a * $b
        }
        cur += 4
    }
    print $1
}
```

## Part 2

Part 1 で二箇所プログラムを修正してたけど今度は逆で、
最終出力が `19600720` になるような修正の方法を探せという問題。
修正の仕方は $100 \times 100$ 通りなので、全探索していい。
（一回のシミュレーションは入力長に線形時間なので）

```awk
BEGIN {
    FS = ","
}
{
    init = $0
    for (noun = 1; noun <= 99; ++noun) {
        for (verb = 1; verb <= 99; ++verb) {
            $0 = init
            $2 = noun
            $3 = verb
            result = -1
            cur = 1
            while ($cur != 99) {
                a = $(cur + 1) + 1  # awk は 1-index
                b = $(cur + 2) + 1
                p = $(cur + 3) + 1
                if ($cur == 1) {
                    $p = $a + $b
                } else {
                    $p = $a * $b
                }
                cur += 4
            }
            if ($cur == 99) result = $1
            if (result == 19690720) {
                print (noun * 100 + verb)
            }
        }
    }
}
```


