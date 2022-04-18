import XCTest
@testable import LinkedList

final class SwiftLinkedListTests: XCTestCase {
  var strList = LinkedList<String>()
  var intList = LinkedList<Int>()

  func testInsertingNodeAtEndOfList() {
    XCTAssertEqual("\(strList)", "LinkedList[]")

    var returned = strList.append("hello")
    XCTAssertEqual("\(strList)", #"LinkedList["hello"]"#)
    XCTAssertEqual("\(returned)", #"Node("hello")"#)

    returned = strList.append("world")
    XCTAssertEqual("\(strList)", #"LinkedList["hello", "world"]"#)
    XCTAssertEqual("\(returned)", #"Node("world")"#)
  }

  func testInsertingNodesAtEndOfList() {
    XCTAssertEqual("\(strList)", "LinkedList[]")

    var returned = strList.append(contentsOf: ["Noma", "noma", "yay"])
    XCTAssertEqual("\(strList)", #"LinkedList["Noma", "noma", "yay"]"#)
    XCTAssertEqual("\(returned)", #"[Node("Noma"), Node("noma"), Node("yay")]"#)

    returned = strList.append(contentsOf: ["Noma", "noma", "noma", "yay"])
    XCTAssertEqual("\(strList)", #"LinkedList["Noma", "noma", "yay", "Noma", "noma", "noma", "yay"]"#)
    XCTAssertEqual("\(returned)", #"[Node("Noma"), Node("noma"), Node("noma"), Node("yay")]"#)
  }

  func testInsertingNodeAtBeginningOfList() {
    XCTAssertEqual("\(intList)", "LinkedList[]")

    var returned = intList.prepend(1)
    XCTAssertEqual("\(intList)", "LinkedList[1]")
    XCTAssertEqual("\(returned)", "Node(1)")

    returned = intList.prepend(2)
    XCTAssertEqual("\(intList)", "LinkedList[2, 1]")
    XCTAssertEqual("\(returned)", "Node(2)")
  }

  func testInsertingNodesAtBeginningOfList() {
    XCTAssertEqual("\(intList)", "LinkedList[]")

    var returned = intList.prepend(contentsOf: [1, 2, 3])
    XCTAssertEqual("\(intList)", "LinkedList[1, 2, 3]")
    XCTAssertEqual("\(returned)", "[Node(3), Node(2), Node(1)]")

    returned = intList.prepend(contentsOf: 4...6)
    XCTAssertEqual("\(intList)", "LinkedList[4, 5, 6, 1, 2, 3]")
    XCTAssertEqual("\(returned)", "[Node(6), Node(5), Node(4)]")
  }

  func testRemovingFirstNodeAndReturningThatElement() {
    XCTAssertEqual("\(intList)", "LinkedList[]")
    XCTAssertNil(intList.popFirst())

    intList.append(contentsOf: [1, 2, 3])
    XCTAssertEqual("\(intList)", "LinkedList[1, 2, 3]")

    XCTAssertEqual(intList.popLast(), 3)
    XCTAssertEqual("\(intList)", "LinkedList[1, 2]")
  }

  func testRemovingLastNodeAndReturningThatElement() {
    XCTAssertEqual("\(intList)", "LinkedList[]")
    XCTAssertNil(intList.popLast())

    intList.append(contentsOf: 1...3)
    XCTAssertEqual("\(intList)", "LinkedList[1, 2, 3]")

    XCTAssertEqual(intList.popFirst(), 1)
    XCTAssertEqual("\(intList)", "LinkedList[2, 3]")
  }

  func testInsertingNewNodeBeforeExistingNode() {
    XCTAssertEqual("\(intList)", "LinkedList[]")

    let nodes = intList.prepend(contentsOf: [1, 2, 3])
    XCTAssertEqual("\(intList)", "LinkedList[1, 2, 3]")
    let node = nodes[1]
    XCTAssertEqual("\(node)", "Node(2)")

    intList.insert(100, before: node)
    XCTAssertEqual("\(intList)", "LinkedList[1, 100, 2, 3]")
  }

  func testInsertingNewNodeAfterExistingNode() {
    XCTAssertEqual("\(intList)", "LinkedList[]")

    let nodes = intList.prepend(contentsOf: [1, 2, 3])
    XCTAssertEqual("\(intList)", "LinkedList[1, 2, 3]")
    let node = nodes[1]
    XCTAssertEqual("\(node)", "Node(2)")

    intList.insert(100, after: node)
    XCTAssertEqual("\(intList)", "LinkedList[1, 2, 100, 3]")
  }

  func testRemovingSpecifiedNode() {
    XCTAssertEqual("\(intList)", "LinkedList[]")
    XCTAssertNil(intList.remove(Node<Int>(1)))

    intList.append(contentsOf: [1, 2, 3])
    XCTAssertEqual("\(intList)", "LinkedList[1, 2, 3]")

    let node = intList.append(100)
    XCTAssertEqual("\(intList)", "LinkedList[1, 2, 3, 100]")

    intList.append(contentsOf: 4...6)
    XCTAssertEqual("\(intList)", "LinkedList[1, 2, 3, 100, 4, 5, 6]")

    let removed = intList.remove(node)
    XCTAssertEqual(removed, 100)
    XCTAssertEqual("\(intList)", "LinkedList[1, 2, 3, 4, 5, 6]")

    let returned = intList.remove(Node<Int>(1)) // this node isn't contained in the list
    XCTAssertNil(returned)
  }

  func testRemovingNodeThatIsPointedByPtrProperty() {
    XCTAssertEqual("\(intList)", "LinkedList[]")
    XCTAssertNil(intList.remove(Node<Int>(1)))

    intList.append(contentsOf: [1, 2, 3])
    XCTAssertEqual("\(intList)", "LinkedList[1, 2, 3]")

    XCTAssertEqual(intList.ptr, intList.head)
    var removed = intList.remove(intList.ptr) // intList.popFirst()
    XCTAssertEqual(removed, 1)
    XCTAssertEqual("\(intList)", "LinkedList[2, 3]")
    XCTAssertEqual(intList.ptr, intList.head)
    XCTAssertEqual(String(describing: intList.ptr!), "Node(2)")

    intList.pointToTail()
    XCTAssertEqual(intList.ptr, intList.tail)
    removed = intList.remove(intList.ptr) // intList.popLast()
    XCTAssertEqual(removed, 3)
    XCTAssertEqual("\(intList)", "LinkedList[2]")
    XCTAssertEqual(String(describing: intList.ptr!), "Node(2)")

    removed = intList.remove(intList.ptr)
    XCTAssertEqual(removed, 2)
    XCTAssertEqual("\(intList)", "LinkedList[]")
    XCTAssertNil(intList.ptr)
  }

  func testRemovingNodeThatSatisfyPredicate() {
    XCTAssertEqual("\(intList)", "LinkedList[]")
    XCTAssertNil(intList.remove { $0 % 2 == 0 })

    intList.append(contentsOf: 1...8)
    XCTAssertEqual("\(intList)", "LinkedList[1, 2, 3, 4, 5, 6, 7, 8]")

    var removed = intList.remove { $0 % 2 == 0 }
    XCTAssertEqual(removed, 2)
    XCTAssertEqual("\(intList)", "LinkedList[1, 3, 4, 5, 6, 7, 8]")

    removed = intList.remove { $0 == 99 } // this element isn't contained in the list
    XCTAssertNil(removed)
  }

  func testRemovingAllNodesThatSatisfyPredicate() {
    XCTAssertEqual("\(intList)", "LinkedList[]")
    XCTAssertEqual(intList.removeAll { $0 % 2 == 0 }, [])

    intList.append(contentsOf: 1...8)
    XCTAssertEqual("\(intList)", "LinkedList[1, 2, 3, 4, 5, 6, 7, 8]")

    var removed = intList.removeAll { $0 % 2 == 0 }
    XCTAssertEqual(removed, [2, 4, 6, 8])
    XCTAssertEqual("\(intList)", "LinkedList[1, 3, 5, 7]")

    removed = intList.removeAll { $0 == 99 } // this element isn't contained in the list
    XCTAssertEqual(removed, [])

    intList.removeAll()
    XCTAssertEqual("\(intList)", "LinkedList[]")
  }

  func testReturningNewArray() {
    XCTAssertEqual("\(intList)", "LinkedList[]")

    intList.append(contentsOf: 1...3)
    XCTAssertEqual("\(intList)", "LinkedList[1, 2, 3]")

    intList.nextNode()
    XCTAssertNotEqual(intList.head, intList.ptr)

    let ary = intList.map { $0 }
    XCTAssertEqual(ary, [1, 2, 3])
  }

  func testPointingNextNodeAndReturningCurrentNode() {
    XCTAssertEqual("\(intList)", "LinkedList[]")
    XCTAssertNil(intList.nextNode())

    intList.append(contentsOf: 1...3)
    XCTAssertEqual("\(intList)", "LinkedList[1, 2, 3]")

    /*
     The nextNode method returns the current node that is the pointed by
     the ptr property. The node isn't the next node of the pointed node.
    */
    var cur = intList.nextNode()
    XCTAssertEqual("\(String(describing: cur))", "Optional(Node(1))")

    cur = intList.nextNode()
    XCTAssertEqual("\(String(describing: cur))", "Optional(Node(2))")

    cur = intList.nextNode()
    XCTAssertEqual("\(String(describing: cur))", "Optional(Node(3))")
    XCTAssertEqual(cur, intList.tail)
    XCTAssertNil(cur!.next)

    XCTAssertNil(intList.nextNode())

    cur = intList.nextNode()
    XCTAssertEqual("\(String(describing: cur))", "Optional(Node(1))")

    cur = intList.nextNode()
    XCTAssertEqual("\(String(describing: cur))", "Optional(Node(2))")

    cur = intList.nextNode()
    XCTAssertEqual("\(String(describing: cur))", "Optional(Node(3))")
    XCTAssertEqual(cur, intList.tail)
    XCTAssertNil(cur!.next)

    XCTAssertNil(intList.nextNode())

    var ary = [Int]()
    var sum = 0
    while let node = intList.nextNode() {
      ary.append(node.value)
      sum += node.value
      // do something...
    }
    XCTAssertEqual(ary, [1, 2, 3])
    XCTAssertEqual(sum, 6)

    XCTAssertEqual("\(intList)", "LinkedList[1, 2, 3]")
  }

  func testPointingPreviousNodeAndReturningCurrentNode() {
    XCTAssertEqual("\(intList)", "LinkedList[]")
    XCTAssertNil(intList.prevNode())

    intList.append(contentsOf: [1, 2, 3])
    XCTAssertEqual("\(intList)", "LinkedList[1, 2, 3]")

    /*
     The prevNode method returns the current node that is the pointed by
     the ptr property. The node isn't the previous node of the pointed node.
    */
    var cur = intList.prevNode()
    XCTAssertEqual("\(String(describing: cur))", "Optional(Node(1))")
    XCTAssertEqual(cur, intList.head)
    XCTAssertNil(cur!.prev)

    XCTAssertNil(intList.prevNode())

    cur = intList.prevNode()
    XCTAssertEqual("\(String(describing: cur))", "Optional(Node(3))")

    cur = intList.prevNode()
    XCTAssertEqual("\(String(describing: cur))", "Optional(Node(2))")

    cur = intList.prevNode()
    XCTAssertEqual("\(String(describing: cur))", "Optional(Node(1))")
    XCTAssertEqual(cur, intList.head)
    XCTAssertNil(cur!.prev)

    XCTAssertNil(intList.prevNode())

    var ary = [Int]()
    var sum = 0
    while let node = intList.prevNode() {
      ary.append(node.value)
      sum += node.value
      // do something...
    }
    XCTAssertEqual(ary, [3, 2, 1])
    XCTAssertEqual(sum, 6)

    XCTAssertTrue("\(intList)" == "LinkedList[1, 2, 3]")
  }

  func testUsingCircularList() {
    intList = LinkedList<Int>().circulate()
    XCTAssertEqual("\(intList)", "LinkedList[]")

    intList.append(contentsOf: 1...3)
    XCTAssertEqual("\(intList)", "LinkedList[1, 2, 3]")

    var cur = intList.nextNode()
    XCTAssertEqual("\(String(describing: cur))", "Optional(Node(1))")

    cur = intList.nextNode()
    XCTAssertEqual("\(String(describing: cur))", "Optional(Node(2))")

    cur = intList.nextNode()
    XCTAssertEqual("\(String(describing: cur))", "Optional(Node(3))")
    XCTAssertEqual(cur, intList.tail)
    XCTAssertNil(cur!.next)
    /*
     The cur!.next node is nil, but if you call the circulate method
     to use a circular list, the nextNode method will skip nil.
    */

    cur = intList.nextNode()
    XCTAssertEqual("\(String(describing: cur))", "Optional(Node(1))")

    cur = intList.nextNode()
    XCTAssertEqual("\(String(describing: cur))", "Optional(Node(2))")

    cur = intList.nextNode()
    XCTAssertEqual("\(String(describing: cur))", "Optional(Node(3))")
    XCTAssertEqual(cur, intList.tail)
    XCTAssertNil(cur!.next)

    cur = intList.prevNode()
    XCTAssertEqual("\(String(describing: cur))", "Optional(Node(1))")
    XCTAssertEqual(cur, intList.head)
    XCTAssertNil(cur!.prev)
    /*
     The cur!.prev node is nil, but if you call the circulate method
     to use a circular list, the prevNode method will skip nil.
    */

    cur = intList.prevNode()
    XCTAssertEqual("\(String(describing: cur))", "Optional(Node(3))")

    cur = intList.prevNode()
    XCTAssertEqual("\(String(describing: cur))", "Optional(Node(2))")

    cur = intList.prevNode()
    XCTAssertEqual("\(String(describing: cur))", "Optional(Node(1))")
    XCTAssertEqual(cur, intList.head)
    XCTAssertNil(cur!.prev)

    XCTAssertEqual("\(intList)", "LinkedList[1, 2, 3]")
  }

  func testMovingNodeToHeadOfAnotherList() {
    let old = LinkedList<Int>()
    old.append(1)
    XCTAssertEqual("\(old)", "LinkedList[1]")

    let new = LinkedList<Int>()
    new.append(2)
    XCTAssertEqual("\(new)", "LinkedList[2]")

    let node = old.ptr
    XCTAssertTrue(node === old.ptr)

    new <*- old.ptr
    XCTAssertEqual("\(old)", "LinkedList[]")
    XCTAssertEqual("\(new)", "LinkedList[1, 2]")

    XCTAssertTrue(new.head === node)
    XCTAssertFalse(new.head === old.ptr)
  }

  func testMovingNodeToTailOfAnotherList() {
    let old = LinkedList<Int>()
    old.append(1)
    XCTAssertEqual("\(old)", "LinkedList[1]")

    let new = LinkedList<Int>()
    new.append(2)
    XCTAssertEqual("\(new)", "LinkedList[2]")

    let node = old.ptr
    XCTAssertTrue(node === old.ptr)

    new <-* old.ptr
    XCTAssertEqual("\(old)", "LinkedList[]")
    XCTAssertEqual("\(new)", "LinkedList[2, 1]")

    XCTAssertTrue(new.tail === node)
    XCTAssertFalse(new.tail === old.ptr)
  }

  func testSwapingNodes() {
    let listA = LinkedList<Int>()
    let listB = LinkedList<Int>()

    listA.append(contentsOf: 1...3)
    listB.append(10)
    XCTAssertEqual("\(listA)", "LinkedList[1, 2, 3]")
    XCTAssertEqual("\(listB)", "LinkedList[10]")

    listA.ptr <--> listB.ptr
    XCTAssertEqual("\(listA)", "LinkedList[10, 2, 3]")
    XCTAssertEqual("\(listB)", "LinkedList[1]")
  }
}
