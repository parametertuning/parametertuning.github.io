---
title: AdventOfCode 2019/12/01
author: cdddar
---

[adventofcode.com/2019/day/1](https://adventofcode.com/2019/day/1)


## 概要

[Advent of Code](https://adventofcode.com/2019) とは毎年行われてる、12/1 から 12/25 まで一日二問出題されるプロコン。
アドベントカレンダーに掛けているだけあって毎回必ずサンタさんが主人公のストーリーに掛かっているのだが、ストーリーを重視するため問題が長文になりがち。
入力はテキストファイルで渡されて、手元で実行して結果だけを送る形式。

二問と言ったけど、一問目が解けたら二問目が表示される。
二問とも入力は同じで、二問目は一問目を少し難しくした程度のものが多い。

問題の難易度は日を追うごとに難しくなっていく。
たぶん1,2週間したら手が付けられなくなって放置すると思います。

## 12/01

初日はまだチュートリアル。
問題文をよく読んで書いてある通りのことを計算するだけ。

```awk
# part 1
function f(x) {
    return int(x / 3) - 2
}
# part 2
function g(x) {
    y = f(x)
    if (y <= 0) return 0
    return y + g(y)
}
{
    sum += f($1)
    sum2 += g($1)
}
END {
    print "Part1:"
    print sum
    print "Part2:"
    print sum2
}
```
