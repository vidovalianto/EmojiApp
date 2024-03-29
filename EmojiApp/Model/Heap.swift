//
//  Heap.swift
//  EmojiPickerView
//
//  Created by Vido Shaweddy on 2/11/21.
//

import Foundation

struct Heap<E: Hashable, T: Comparable> {
  var data: [E]
  var comparator: [E: T]
  let priorityFunction: (T, T) -> Bool

  var isEmpty: Bool {
    return data.isEmpty
  }

  var count: Int {
    return data.count
  }

  init(_ data: [E],
       _ comparator: [E: T],
       _ priorityFunction: @escaping (T, T) -> Bool) {
    self.data = data
    self.comparator = comparator
    self.priorityFunction = priorityFunction
    buildHeap()
  }

  func peek() -> E? {
    return data.first
  }

  func leftChildIndex(of index: Int) -> Int {
    return (2 * index) + 1
  }

  func rightChildIndex(of index: Int) -> Int {
    return (2 * index) + 2
  }

  func parentIndex(of index: Int) -> Int {
    return (index - 1) / 2
  }

  private mutating func buildHeap() {
    guard !data.isEmpty else { return }
    for i in (0..<self.data.count/2).reversed() {
      heapify(i)
    }
  }

  private mutating func heapify(_ i: Int) {
    var parent = i
    let leftChild = leftChildIndex(of: i)
    let rightChild = rightChildIndex(of: i)

    guard parent < self.data.count,
          var parentCount = comparator[data[parent]]
    else { return }

    if leftChild < self.data.count,
       let childCount = comparator[data[leftChild]],
       priorityFunction(parentCount, childCount) {
      parent = leftChild
      parentCount = childCount
    }

    if rightChild < self.data.count,
       let childCount = comparator[data[rightChild]],
       priorityFunction(parentCount, childCount) {
      parent = rightChild
    }

    if parent != i {
      data.swapAt(parent, i)
      heapify(parent)
    }
  }

  public mutating func heapSort() {
    var res = [E]()
    for _ in data.indices {
      data.swapAt(0, data.count - 1)
      guard let val = data.popLast() else { break }
      res.append(val)
      heapify(0)
    }

    data = res
  }
}
