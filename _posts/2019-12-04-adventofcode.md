---
title: AdventOfCode 2019/12/04
author: cdddar
---

[adventofcode.com/2019/day/4](https://adventofcode.com/2019/day/4)

## Part 1

valid な数が与えられた範囲内にいくつあるか数える。

valid かどうか判定する関数書いて for 文でチェックするだけ。
判定する数は文字列にしておくとちょっとラク。

```python
def ok(num: str) -> bool:
    if len(num) != 6:
        return False
    same = False
    eq_or_inc = True
    for i in range(1, len(num)):
        if num[i - 1] == num[i]:
            same = True
        if num[i - 1] > num[i]:
            eq_or_inc = False
    return same and eq_or_inc


assert ok('111111')
assert not ok('11111')
assert not ok('111110')
assert not ok('123456')


a, b = map(int, input().split('-'))
ans = 0
for x in range(a, b + 1):
    if ok(str(x)):
        ans += 1

print(ans)
```

## Part 2

valid な条件が厳しくなって、Part 1 では単に隣り合う2つが同じな箇所があれば ok だったけど、
Part 2 では、「ちょうど」2つが連続で並んでる必要がある。
例えば "111345" は Part 1 では "11" があるので ok だったが、
Part 2 では3つ並んでるものと見なして NG になる。

runlength 圧縮のようなことをするといいが、
単に2つ並んでることだけチェックすればいいので、連続する4つを取り出して
`xooy`
の形をしてるかをチェックすることにした。
端っこの場合は連続する4つを取り出せないので、両端に余計な番兵を付け足した。

```python
def ok(num: str) -> bool:
    if len(num) != 6:
        return False
    eq_or_inc = True
    for i in range(1, len(num)):
        if num[i - 1] > num[i]:
            eq_or_inc = False

    same = False
    s = 'x' + num + 'x'
    for i in range(1, 6):
        if s[i] == s[i + 1] and s[i] != s[i - 1] and s[i + 1] != s[i + 2]:
            same = True

    return same and eq_or_inc


assert ok('112233')
assert ok('112222')
assert not ok('111111')
assert not ok('111110')
assert not ok('123456')


a, b = map(int, input().split('-'))
ans = 0
for x in range(a, b + 1):
    if ok(str(x)):
        ans += 1

print(ans)
```
