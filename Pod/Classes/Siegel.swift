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
    private var fifo: [(key: String, valueRef: Ref<T>?)]
    private var entries: [String: Weak<Ref<T>>?]

    public init(size: Int = 1024, gcFactor: Int = 10) {
        self.size     = size
        self.gcFactor = gcFactor
        self.fifo     = []
        self.entries  = [:]
    }

    public func set(#key: String, value: T) -> T {
        if var oldValue = self.entries[key] {
            oldValue = nil
        }

        // register
        let valueRef = Ref<T>(value: value)
        self.entries[key] = Weak<Ref<T>>(value: valueRef)
        self.updateFifo(key, valueRef: valueRef)

        // expire the oldest entry if full
        while self.entries.count > self.size {
            let expireKey = self.fifo.removeAtIndex(0).0
            if self.entries[expireKey]??.value == nil {
                self.entries.removeValueForKey(expireKey)
            }
        }

        return value
    }

    public func get(#key: String) -> T? {
        if let weakValueRef = self.entries[key] {
            self.updateFifo(key, valueRef: weakValueRef?.value)
            return weakValueRef?.value?.value
        }
        else {
            return nil
        }
    }

    public func remove(#key: String) -> T? {
        if var weakValueRef = self.entries.removeValueForKey(key) {
            let value = weakValueRef?.value?.value
            weakValueRef = nil
            return value
        }
        else {
            return nil
        }
    }

    public func clear() {
        self.fifo    = []
        self.entries = [:]
    }

    private func updateFifo(key: String, valueRef: Ref<T>?) {
        self.fifo.append((key: key, valueRef: valueRef))
        if self.fifo.count >= self.size * self.gcFactor {
            var newFifo: [(key: String, valueRef: Ref<T>?)] = []
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
