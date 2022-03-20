# LinkedList

A doubly linked list library in Swift

```swift
// Solving Josephus problem using circular linked list

let n = 41
let k = 3
let people = LinkedList<Int>().circulate()
people.append(contentsOf: 1...n)

while !people.isEmpty {
  for _ in 1..<k {
    people.nextNode()
  }
  let cur = people.nextNode()
  print("\(people.remove(cur)!) ", terminator: "")
}
print()
```

Output:

```
3 6 9 12 15 18 21 24 27 30 33 36 39 1 5 10 14 19 23 28 32 37 41 7 13 20 26 34 40 8 17 29 38 11 25 2 22 4 35 16 31
```

## Example

- [josephus](https://github.com/ready-player1/josephus/blob/main/josephus/main.swift)
