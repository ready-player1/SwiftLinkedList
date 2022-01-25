public class Node<Element: Equatable> {
  public var prev, next: Node?
  public var value: Element
  weak var list: LinkedList<Element>?

  public init(_ value: Element) {
    self.value = value
  }

  private init(_ value: Element, _ prev: Node?, _ next: Node?, _ list: LinkedList<Element>?) {
    (self.value, self.prev, self.next, self.list) = (value, prev, next, list)
  }

  func dup() -> Node {
    Node<Element>(value, prev, next, list)
  }

  func link(_ node: Node) {
    (next, node.prev) = (node, self)
  }

  func unlink() -> Element {
    next?.prev = prev
    prev?.next = next
    (prev, next) = (nil, nil)
    return self.value
  }
}

extension Node: Equatable {
  public static func ==(lhs: Node, rhs: Node) -> Bool {
    lhs.value == rhs.value && lhs.prev === rhs.prev && lhs.next === rhs.next
  }
}

extension Node: CustomStringConvertible {
  public var description: String {
    "Node(\(value is String ? #""\#(value)""# as! Element : value))"
  }
}

public class LinkedList<Element: Equatable> {
  public private(set) var head, tail: Node<Element>?
  public private(set) lazy var ptr = head

  public var first: Element? { head?.value }
  public var last:  Element? { tail?.value }
  public var cur:   Element? {
    get {
      ptr?.value
    }
    set {
      guard newValue != nil else { return }
      ptr?.value = newValue!
    }
  }

  public var prev: Node<Element>? { ptr?.prev }
  public var next: Node<Element>? { ptr?.next }

  public var isEmpty: Bool { head == nil }

  public private(set) var count = 0

  private var isCircular = false

  public init() {}

  public func contains(_ node: Node<Element>) -> Bool {
    node.list === self
  }

  @discardableResult
  public func circulate() -> LinkedList {
    isCircular = true
    return self
  }

  @discardableResult
  public func uncirculate() -> LinkedList {
    isCircular = false
    return self
  }

  @discardableResult
  public func prevNode() -> Node<Element>? {
    guard let cur = ptr else {
      ptr = tail
      return nil
    }
    ptr = cur.prev
    if ptr == nil && isCircular {
      ptr = tail
    }
    return cur
  }

  @discardableResult
  public func nextNode() -> Node<Element>? {
    guard let cur = ptr else {
      ptr = head
      return nil
    }
    ptr = cur.next
    if ptr == nil && isCircular {
      ptr = head
    }
    return cur
  }

  @discardableResult
  public func pointToHead() -> LinkedList {
    ptr = head
    return self
  }

  @discardableResult
  public func pointToTail() -> LinkedList {
    ptr = tail
    return self
  }

  private func cont<T>(predicate: @escaping (Element) -> Bool, onSuccess: @escaping (Node<Element>?) -> T?) -> (Node<Element>?) -> T? {
    func cont(_ node: Node<Element>?) -> T? {
      guard let node = node else {
        return nil
      }
      return predicate(node.value) ? onSuccess(node) : cont(node.next)
    }
    return cont
  }

  private func compactMap<T>(transform: @escaping (Node<Element>?) -> T?) -> (Node<Element>?) -> [T] {
    var acc = [T]()
    func cont(_ node: Node<Element>?) -> [T] {
      guard let node = node else {
        return acc
      }

      let next = node.next
      if let res = transform(node) {
        acc.append(res)
      }
      return cont(next)
    }
    return cont
  }

  func insert(_ new: Node<Element>, before cur: Node<Element>?) {
    if cur == nil {
      precondition(isEmpty, "Cannot insert a new node before nil")
      (tail, head) = (new, new)
      ptr = head
    }
    else {
      precondition(contains(cur!), "Cannot insert a new node before the node that is not included in the list")
      if let prev = cur!.prev {
        prev.link(new)
      }
      new.link(cur!)
      if (cur == head) {
        head = new
      }
    }
    count += 1
    new.list = self
  }

  @discardableResult
  public func insert(_ elem: Element, before cur: Node<Element>?) -> Node<Element> {
    let node = Node<Element>(elem)
    insert(node, before: cur)
    return node
  }

  func insert(_ new: Node<Element>, after cur: Node<Element>?) {
    if cur == nil {
      precondition(isEmpty, "Cannot insert a new node after nil")
      (tail, head) = (new, new)
      ptr = head
    }
    else {
      precondition(contains(cur!), "Cannot insert a new node arter the node that is not included in the list")
      if let next = cur!.next {
        new.link(next)
      }
      cur!.link(new)
      if (cur == tail) {
        tail = new
      }
    }
    count += 1
    new.list = self
  }

  @discardableResult
  public func insert(_ elem: Element, after cur: Node<Element>?) -> Node<Element> {
    let node = Node<Element>(elem)
    insert(node, after: cur)
    return node
  }

  @discardableResult
  public func prepend(_ elem: Element) -> Node<Element> {
    insert(elem, before: head)
  }

  @discardableResult
  public func prepend<S: Sequence>(contentsOf elems: S) -> [Node<Element>] where S.Element == Element {
    elems.reversed().map { prepend($0) }
  }

  @discardableResult
  public func append(_ elem: Element) -> Node<Element> {
    insert(elem, after: tail)
  }

  @discardableResult
  public func append<S: Sequence>(contentsOf elems: S) -> [Node<Element>] where S.Element == Element {
    elems.map { append($0) }
  }

  @discardableResult
  public func insertBefore(_ elem: Element, where f: @escaping (Element) -> Bool) -> Node<Element>? {
    cont(predicate: f, onSuccess: { self.insert(elem, before: $0) })(head)
  }

  @discardableResult
  public func insertAfter(_ elem: Element, where f: @escaping (Element) -> Bool) -> Node<Element>? {
    cont(predicate: f, onSuccess: { self.insert(elem, after: $0) })(head)
  }

  @discardableResult
  public func remove(_ node: Node<Element>?) -> Element? {
    guard let node = node, contains(node) else {
      return nil
    }

    switch (head, tail) {
    case (node, node): (head, tail) = (nil, nil)
    case (node, _   ): head = node.next
    case (_   , node): tail = node.prev
    case (_   , _   ): ()
    }
    if ptr == node {
      ptr = node.dup()
    }
    count -= 1
    node.list = nil
    return node.unlink()
  }

  @discardableResult
  public func remove() -> Element? {
    remove(ptr)
  }

  @discardableResult
  public func popFirst() -> Element? {
    remove(head)
  }

  @discardableResult
  public func popLast() -> Element? {
    remove(tail)
  }

  @discardableResult
  public func remove(startingFrom node: Node<Element>?, where f: @escaping (Element) -> Bool) -> Element? {
    cont(predicate: f, onSuccess: remove)(node)
  }

  @discardableResult
  public func remove(where f: @escaping (Element) -> Bool) -> Element? {
    remove(startingFrom: head, where: f)
  }

  @discardableResult
  public func removeAll(where f: @escaping (Element) -> Bool = {_ in true}) -> [Element] {
    compactMap(transform: { node in f(node!.value) ? self.remove(node) : nil })(head)
  }
}

extension LinkedList: Sequence {
  public struct Iterator<Element: Equatable>: IteratorProtocol {
    var list: LinkedList<Element>

    public mutating func next() -> Element? {
      guard let cur = list.nextNode() else {
        return nil
      }
      return cur.value
    }
  }

  public func makeIterator() -> Iterator<Element> {
    Iterator(list: self.pointToHead())
  }
}

extension LinkedList: CustomStringConvertible {
  public var description: String {
    var elems = [Element]()
    var node = head
    while node != nil {
      elems.append(node!.value)
      node = node!.next
    }
    return "LinkedList\(elems.description)"
  }
}

infix operator <*-

public func <*-<Element>(newList: LinkedList<Element>, node: Node<Element>?) {
  guard let node = node else { return }
  if let oldList = node.list {
    oldList.remove(node)
  }
  newList.insert(node, before: newList.head)
}

infix operator <-*

public func <-*<Element>(newList: LinkedList<Element>, node: Node<Element>?) {
  guard let node = node else { return }
  if let oldList = node.list {
    oldList.remove(node)
  }
  newList.insert(node, after: newList.tail)
}

infix operator <-->

public func <--><Element>(lhs: Node<Element>?, rhs: Node<Element>?) {
  guard let nodeL = lhs, let listL = nodeL.list else { return }
  guard let nodeR = rhs, let listR = nodeR.list else { return }

  let tmp = Node<Element>(nodeL.value)
  listL.insert(tmp, after: nodeL)
  listL.remove(nodeL)

  listR.insert(nodeL, after: nodeR)
  listR.remove(nodeR)

  listL.insert(nodeR, after: tmp)
  listL.remove(tmp)
}
