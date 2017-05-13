//
//  ArrayExtensions.swift
//  SwiftDemo
//
//  Created by panxinyu on 13/05/2017.
//  Copyright © 2017 panxinyu. All rights reserved.
//

import Foundation

// MARK: - 整形数组
public extension Array where Element: Integer {
    /// 整形数组求和
    ///
    /// - Returns: <#return value description#>
    public func sum() -> Element {
        return reduce(0, +)
    }
}

// MARK: - 浮点型数组
public extension Array where Element: FloatingPoint {

    /// 求平均数
    ///
    /// - Returns: <#return value description#>
    public func average() -> Element {
        return isEmpty ? 0 : reduce(0, +) / Element(count)
    }

    /// 求和
    ///
    /// - Returns: <#return value description#>
    public func sum() -> Element {
        return reduce(0, +)
    }
}

// MARK: - Methods
public extension Array {

    /// 给定index的元素，不存在返回nil
    ///
    /// - Parameter index: index
    /// - Returns: <#return value description#>
    public func item(at index: Int) -> Element? {
        guard startIndex..<endIndex ~= index else { return nil }
        return self[index]
    }

    /// 删除数组的最后一个元素
    ///
    /// - Returns: 删除的元素
    @discardableResult public mutating func pop() -> Element? {
        return popLast()
    }

    /// 在数组的首位插入
    ///
    /// - Parameter newElement: <#newElement description#>
    public mutating func prepend(_ newElement: Element) {
        insert(newElement, at: 0)
    }

    /// 安全地交换元素位置，越界就return
    ///
    /// - Parameters:
    ///   - index: <#index description#>
    ///   - otherIndex: <#otherIndex description#>
    public mutating func safeSwap(from index: Int, to otherIndex: Int) {
        guard index != otherIndex,
            startIndex..<endIndex ~= index,
            startIndex..<endIndex ~= otherIndex else { return }

        Swift.swap(&self[index], &self[otherIndex])
    }

    /// 获取满足条件的第一个元素的位置
    ///
    /// - Parameter condition: 需要满足的条件
    /// - Returns: <#return value description#>
    /// - Throws: <#throws value description#>
    public func firstIndex(where condition: (Element) throws -> Bool) rethrows -> Int? {
        for (index, value) in lazy.enumerated() {
            if try condition(value) { return index }
        }
        return nil
    }

    /// 获取满足条件的最后一个元素的位置
    ///
    /// - Parameter condition: 需要满足的条件
    /// - Returns: <#return value description#>
    /// - Throws: <#throws value description#>
    public func lastIndex(where condition: (Element) throws -> Bool) rethrows -> Int? {
        for (index, value) in lazy.enumerated().reversed() {
            if try condition(value) { return index }
        }
        return nil
    }

    /// 获取所有满足条件的元素
    ///
    /// - Parameter condition: 需要满足的条件
    /// - Returns: <#return value description#>
    /// - Throws: <#throws value description#>
    public func indices(where condition: (Element) throws -> Bool) rethrows -> [Int]? {
        var indicies: [Int] = []
        for (index, value) in lazy.enumerated() {
            if try condition(value) { indicies.append(index) }
        }
        return indicies.isEmpty ? nil : indicies
    }

    /// 判断是否所有元素都满足某一条件
    ///
    /// - Parameter condition: 需要满足的条件
    /// - Returns: <#return value description#>
    /// - Throws: <#throws value description#>
    public func all(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        return try !contains { try !condition($0) }
    }

    /// 判断是否所有元素都不满足某一条件
    ///
    /// - Parameter condition: 需要满足的条件
    /// - Returns: <#return value description#>
    /// - Throws: <#throws value description#>
    public func none(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        return try !contains { try condition($0) }
    }

    /// 获取满足条件的最后一个元素
    ///
    /// - Parameter condition: 需要满足的条件
    /// - Returns: <#return value description#>
    /// - Throws: <#throws value description#>
    public func last(where condition: (Element) throws -> Bool) rethrows -> Element? {
        for element in reversed() {
            if try condition(element) { return element }
        }
        return nil
    }

    /// 筛选出不满足某个条件的元素
    ///
    /// - Parameter condition: 需要满足的条件
    /// - Returns: <#return value description#>
    /// - Throws: <#throws value description#>
    public func reject(where condition: (Element) throws -> Bool) rethrows -> [Element] {
        return try filter { return try !condition($0) }
    }

    /// 获取满足某一条件的元素的个数
    ///
    /// - Parameter condition: 需要满足的条件
    /// - Returns: <#return value description#>
    /// - Throws: <#throws value description#>
    public func count(where condition: (Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for element in self {
            if try condition(element) { count += 1 }
        }
        return count
    }

    /// 从头开始删除满足条件的元素
    ///
    /// - Parameter condition: 需要满足的条件
    /// - Returns: <#return value description#>
    /// - Throws: <#throws value description#>
    public func skip(while condition: (Element) throws-> Bool) rethrows -> [Element] {
        for (index, element) in lazy.enumerated() {
            if try !condition(element) {
                return Array(self[index..<endIndex])
            }
        }
        return [Element]()
    }
}

// MARK: - 有可比性的数组
public extension Array where Element: Equatable {

    /// 打乱数组的顺序
    public mutating func shuffle() {
        guard count > 1 else { return }
        for index in startIndex..<endIndex - 1 {
            let randomIndex = Int(arc4random_uniform(UInt32(endIndex - index))) + index
            if index != randomIndex { Swift.swap(&self[index], &self[randomIndex]) }
        }
    }

    /// 获取打乱顺序的数组
    ///
    /// - Returns: <#return value description#>
    public func shuffled() -> [Element] {
        var array = self
        array.shuffle()
        return array
    }

    /// 判断数组是不是包含另一个数组
    ///
    /// - Parameter elements: <#elements description#>
    /// - Returns: <#return value description#>
    public func contains(_ elements: [Element]) -> Bool {
        guard !elements.isEmpty else { // elements array is empty
            return true
        }
        var found = true
        for element in elements {
            if !contains(element) {
                found = false
            }
        }
        return found
    }

    /// 获取某个元素的所有index
    ///
    /// - Parameter item: <#item description#>
    /// - Returns: <#return value description#>
    public func indexes(of item: Element) -> [Int] {
        var indexes: [Int] = []
        for index in startIndex..<endIndex where self[index] == item {
            indexes.append(index)
        }
        return indexes
    }

    /// 删除某个元素
    ///
    /// - Parameter item: <#item description#>
    public mutating func removeAll(_ item: Element) {
        self = filter { $0 != item }
    }

    /// 从数组中移除一个数组中的所有元素
    ///
    /// - Parameter items: <#items description#>
    public mutating func removeAll(_ items: [Element]) {
        guard !items.isEmpty else { return }
        self = filter { !items.contains($0) }
    }

    /// 数组去重
    public mutating func removeDuplicates() {
        self = reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
    }

    /// 获取去重后的数组
    ///
    /// - Returns: <#return value description#>
    public func duplicatesRemoved() -> [Element] {
        return reduce([]) { ($0 as [Element]).contains($1) ? $0 : $0 + [$1] }
    }

    /// 获取某个元素的第一个index
    ///
    /// - Parameter item: <#item description#>
    /// - Returns: <#return value description#>
    public func firstIndex(of item: Element) -> Int? {
        for (index, value) in lazy.enumerated() where value == item {
            return index
        }
        
        return nil
    }

    /// 获取某个元素的最后一个index
    ///
    /// - Parameter item: <#item description#>
    /// - Returns: <#return value description#>
    public func lastIndex(of item: Element) -> Int? {
        for (index, value) in lazy.enumerated().reversed() where value == item {
            return index
        }
        return nil
    }
    
}
