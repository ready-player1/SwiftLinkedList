# LinkedList

A doubly linked list library in Swift

```swift
// Solving Josephus problem using circular linked list

let n = 41
let k = 3
let people = LinkedList<Int>().circulate()
people.append(contentsOf: 1...n)

while !people.isEmpty {
  let cur = people.advance(by: k)
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
Output:

```
one
two
three
```

Using the map(\_:) method provides the same result.

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

When you need to perform an operation on all of a list’s nodes, use the nextNode() method in a while loop.

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

## Adding Elements

When you need to add single elements to the end of a list, use the append(\_:) method. You can also add multiple elements at the same time by passing an array or a sequence of any kind to the append(contentsOf:) method.

```swift
let list = LinkedList<Int>()
list.append(1)
list.append(2)
list // LinkedList[1, 2]

list.append(contentsOf: 3...5)
list // LinkedList[1, 2, 3, 4, 5]
```

When you need to add single elements to the beginning of a list, use the prepend(\_:) method. You can also add multiple elements at the same time by passing an array or a sequence of any kind to the prepend(contentsOf:) method.

```swift
let list = LinkedList<Int>()
list.prepend(1)
list.prepend(2)
list // LinkedList[2, 1]

list.prepend(contentsOf: 3...5)
list // LinkedList[3, 4, 5, 2, 1]
```

## Removing Elements

When you need to remove elements from a list, use the popFirst(), popLast(),  and remove(\_:) methods.

```swift
let list = LinkedList<Int>()
list.append(contentsOf: 1...2)
let node = list.append(3) // Node(3)
list.append(contentsOf: 4...5)
list // LinkedList[1, 2, 3, 4, 5]

var removed: Int?
removed = list.popFirst() // 1
removed = list.popLast() // 5
removed = list.remove(node) // 3
list // LinkedList[2, 4]
```

When you need to remove the first element of the list that satisfies the given predicate, to use the remove(where:) method.

```swift
let list = LinkedList<Int>()
list.append(contentsOf: 1...8)
list // LinkedList[1, 2, 3, 4, 5, 6, 7, 8]

let removed = list.remove { $0 % 2 == 0 }
removed // 2
list // LinkedList[1, 3, 4, 5, 6, 7, 8]
```

When you need to remove every element of the list that satisfies the given predicate, to use the removeAll(where:) method.

```swift
let list = LinkedList<Int>()
list.append(contentsOf: 1...8)
list // LinkedList[1, 2, 3, 4, 5, 6, 7, 8]

let removed = list.removeAll { $0 % 2 == 0 }
removed // [2, 4, 6, 8]
list // LinkedList[1, 3, 5, 7]

list.removeAll()
list // LinkedList[]
```
