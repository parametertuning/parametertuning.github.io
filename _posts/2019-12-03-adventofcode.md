---
title: AdventOfCode 2019/12/03
author: cdddar
---

[adventofcode.com/2019/day/3](https://adventofcode.com/2019/day/3)

## Part 1

グリッド状の2つのパスが与えられる。
そのパス同士の交差点の内、最も原点から近いものの距離を答えよ。
距離はマンハッタン距離とする。

愚直に、パスを1マス進んで、辿ったマスを記録する。最初に居た原点は記録しないほうが面倒がない。
今考えると辿ったマスを集合で持っても良かったけど、ここでは
`collections.defaultdict`
を使って、
座標 $(x,y)$ に辿ったということを `f[(x, y)] = 1` とすることにする。
`f = collections.defaultdict(int)`
で定義することで、
辿ってないときは `0` が入ってるようになる。

1つ目のパスではそのパスを1マスずつ進みながら `f` に `1` を代入する。
2つ目のパスではそのパスを1マスずつ進みながら `f` が `1` だったら1つ目のパスでもそこを通ったということなので、その時点の距離を記録して最小値をとってく。

```python
from collections import defaultdict


f = defaultdict(int)

# first path
x = 0
y = 0
for com in input().split(','):
    direction = com[0]
    length = int(com[1:])
    if direction == 'R':
        for i in range(x + 1, x + length + 1):
            f[(i, y)] = 1
        x += length
    elif direction == 'L':
        for i in range(x - 1, x - length - 1, -1):
            f[(i, y)] = 1
        x -= length
    elif direction == 'U':
        for j in range(y - 1, y - length - 1, -1):
            f[(x, j)] = 1
        y -= length
    else:  # 'D'
        for j in range(y + 1, y + length + 1):
            f[(x, j)] = 1
        y += length


# the min distance from the central
ans = None


def update(x: int, y: int):
    """Update ans with the minimum distance"""
    global ans
    d = abs(x) + abs(y)
    if ans is None or ans > d:
        ans = d


# second path
x = 0
y = 0
for com in input().split(','):
    direction = com[0]
    length = int(com[1:])
    if direction == 'R':
        for i in range(x + 1, x + length + 1):
            if f[(i, y)] > 0:
                update(i, y)
        x += length
    elif direction == 'L':
        for i in range(x - 1, x - length - 1, -1):
            if f[(i, y)] > 0:
                update(i, y)
        x -= length
    elif direction == 'U':
        for j in range(y - 1, y - length - 1, -1):
            if f[(x, j)] > 0:
                update(x, j)
        y -= length
    else:  # 'D'
        for j in range(y + 1, y + length + 1):
            if f[(x, j)] > 0:
                update(x, j)
        y += length


print(ans)
```

## Part 2

Part 1 では単に辿ったかどうかだけを 0/1 で記録してたけど、
今度は時刻を記録して合計の最小値を出力すればok。

```python
from collections import defaultdict


f = defaultdict(int)

# first path
x = 0
y = 0
time = 0
for com in input().split(','):
    direction = com[0]
    length = int(com[1:])
    if direction == 'R':
        for i in range(x + 1, x + length + 1):
            time += 1
            f[(i, y)] = time
        x += length
    elif direction == 'L':
        for i in range(x - 1, x - length - 1, -1):
            time += 1
            f[(i, y)] = time
        x -= length
    elif direction == 'U':
        for j in range(y - 1, y - length - 1, -1):
            time += 1
            f[(x, j)] = time
        y -= length
    else:  # 'D'
        for j in range(y + 1, y + length + 1):
            time += 1
            f[(x, j)] = time
        y += length


# the min distance from the central
ans = None


def update(time: int):
    """Update ans with the minimum time"""
    global ans
    if ans is None or ans > time:
        ans = time


# second path
x = 0
y = 0
time = 0
for com in input().split(','):
    direction = com[0]
    length = int(com[1:])
    if direction == 'R':
        for i in range(x + 1, x + length + 1):
            time += 1
            if f[(i, y)] > 0:
                update(f[(i, y)] + time)
        x += length
    elif direction == 'L':
        for i in range(x - 1, x - length - 1, -1):
            time += 1
            if f[(i, y)] > 0:
                update(f[(i, y)] + time)
        x -= length
    elif direction == 'U':
        for j in range(y - 1, y - length - 1, -1):
            time += 1
            if f[(x, j)] > 0:
                update(f[(x, j)] + time)
        y -= length
    else:  # 'D'
        for j in range(y + 1, y + length + 1):
            time += 1
            if f[(x, j)] > 0:
                update(f[(x, j)] + time)
        y += length


print(ans)
```
