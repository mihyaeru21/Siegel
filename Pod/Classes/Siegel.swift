//
//  Siegel.swift
//  Pods
//
//  Created by Mihyaeru on 2015/07/24.
//
//

import Foundation

public class Siegel<T> {
    private let size: Int
    private let gcFactor: Int
    private var fifo: [(key: String, valueRef: Ref<T>)]
    private var entries: [String: Weak<Ref<T>>]

    public init(size: Int = 1024, gcFactor: Int = 10) {
        self.size     = size
        self.gcFactor = gcFactor
        self.fifo     = []
        self.entries  = [:]
    }

    public func set(#key: String, value: T) -> T {
        let valueRef = Ref<T>(value: value)
        self.entries[key] = Weak<Ref<T>>(value: valueRef)
        self.updateFifo(key, valueRef: valueRef)

        while self.entries.count > self.size {
            let expireKey = self.fifo.removeAtIndex(0).0
            if self.entries[expireKey]?.value == nil {
                self.entries.removeValueForKey(expireKey)
            }
        }

        return value
    }

    public func get(#key: String) -> T? {
        if let weakValueRef = self.entries[key] {
            self.updateFifo(key, valueRef: weakValueRef.value!)
            return weakValueRef.value?.value
        }
        return nil
    }

    public func exists(#key: String) -> Bool {
        return self.entries[key] != nil
    }

    public func remove(#key: String) -> T? {
        if let weakValueRef = self.entries.removeValueForKey(key) {
            self.fifo = self.fifo.filter { elem in elem.key != key }
            return weakValueRef.value?.value
        }
        return nil
    }

    public func clear() {
        self.fifo    = []
        self.entries = [:]
    }

    public subscript(key: String) -> T? {
        get {
            return self.get(key: key)
        }
        set(value) {
            self.set(key: key, value: value!)
        }
    }

    private func updateFifo(key: String, valueRef: Ref<T>) {
        self.fifo.append((key: key, valueRef: valueRef))
        if self.fifo.count >= self.size * self.gcFactor {
            var newFifo: [(key: String, valueRef: Ref<T>)] = []
            var need = self.entries
            while need.count > 0 {
                let fifoEntry = self.fifo.removeLast()
                if need.removeValueForKey(fifoEntry.0) != nil {
                    newFifo.append(fifoEntry)
                }
            }
            self.fifo = newFifo
        }
    }
}

private class Weak<T: AnyObject> {
    private weak var value: T?
    init(value: T) {
        self.value = value
    }
}

private class Ref<T> {
    private let value: T
    init(value: T) {
        self.value = value
    }
}
