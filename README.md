# LinkedList

A doubly linked list library in Swift

```swift
// Solving Josephus problem using circular linked list

let n = 41
let k = 3
let people = LinkedList<Int>().circulate()
people.append(contentsOf: 1...n)

while !people.isEmpty {
  let cur = people.advance(distance: k)
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

## Accessing Node Values

When you need to perform an operation on all of a list’s elements, use a for-in loop.

```swift
let list = LinkedList<String>()
list.append(contentsOf: ["one", "two", "three"])

for val in list {
  print(val)
}
```

Using the map method provides the same resutl.

```swift
let list = LinkedList<String>()
list.append(contentsOf: ["one", "two", "three"])
list.map { print($0) }
```

Output:

```
one
two
three
```

## Accessing Nodes

When you need to perform an operation on all of a list’s nodes, call the nextNode method in a while loop.

```swift
let list = LinkedList<String>()
list.append(contentsOf: ["one", "two", "three"])

while let node = list.nextNode() {
  print(node)
}
```

Output:

```
Node("one")
Node("two")
Node("three")
```
