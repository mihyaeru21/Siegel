//
//  SiegelSpec.swift
//  Siegel
//
//  Created by Mihyaeru on 7/24/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Siegel

class SiegelSpec: QuickSpec {
    override func spec() {
        describe("set/get") {
            it("stores entries") {
                let cache = Siegel<Int>(size: 3)
                expect(cache.set(key: "a", value: 1)) == 1
                expect(cache.get(key: "a")) == 1

                expect(cache.set(key: "b", value: 2)) == 2
                expect(cache.get(key: "a")) == 1
                expect(cache.get(key: "b")) == 2

                expect(cache.set(key: "c", value: 3)) == 3
                expect(cache.get(key: "a")) == 1
                expect(cache.get(key: "b")) == 2
                expect(cache.get(key: "c")) == 3
            }

            it("can overwrite entry") {
                let cache = Siegel<Int>(size: 3)
                cache.set(key: "a", value: 1)
                cache.set(key: "b", value: 2)
                cache.set(key: "c", value: 3)

                cache.set(key: "b", value: 4)
                expect(cache.get(key: "a")) == 1
                expect(cache.get(key: "b")) == 4
                expect(cache.get(key: "c")) == 3
            }

            it("removes the oldest entry") {
                let cache = Siegel<Int>(size: 3)
                cache.set(key: "a", value: 1)
                cache.set(key: "b", value: 2)
                cache.set(key: "c", value: 3)

                cache.set(key: "d", value: 4)
                expect(cache.get(key: "a")).to(beNil())
                expect(cache.get(key: "b")) == 2
                expect(cache.get(key: "c")) == 3
                expect(cache.get(key: "d")) == 4
            }
        }

        describe("exists") {
            it("returns") {
                let cache = Siegel<Int?>(size: 3)
                cache.set(key: "a", value: 1)
                cache.set(key: "b", value: nil)

                expect(cache.exists(key: "a")).to(beTrue())
                expect(cache.exists(key: "b")).to(beTrue())  // optional type can contain nil
                expect(cache.exists(key: "c")).to(beFalse())

                cache.remove(key: "b")
                expect(cache.exists(key: "b")).to(beFalse())
            }
        }

        describe("remove") {
            it("removes entry") {
                let cache = Siegel<Int>(size: 3)
                cache.set(key: "a", value: 1)
                cache.set(key: "b", value: 2)
                cache.set(key: "c", value: 3)

                cache.remove(key: "b")
                expect(cache.get(key: "a")) == 1
                expect(cache.get(key: "b")).to(beNil())
                expect(cache.get(key: "c")) == 3

                cache.set(key: "d", value: 4)
                expect(cache.get(key: "a")) == 1
                expect(cache.get(key: "b")).to(beNil())
                expect(cache.get(key: "c")) == 3
                expect(cache.get(key: "d")) == 4
            }
        }

        describe("clear") {
            it("removes all entries") {
                let cache = Siegel<Int>(size: 3)
                cache.set(key: "a", value: 1)
                cache.set(key: "b", value: 2)
                cache.set(key: "c", value: 3)

                cache.clear()
                expect(cache.get(key: "a")).to(beNil())
                expect(cache.get(key: "b")).to(beNil())
                expect(cache.get(key: "c")).to(beNil())
            }
        }

        describe("destroy") {
            it("destroys containing entry") {
                let cache = Siegel<Hoge>(size: 3)
                cache.set(key: "a", value: Hoge())
                cache.set(key: "b", value: Hoge())
                cache.set(key: "c", value: Hoge())
                expect(Hoge.initCount)   == 3
                expect(Hoge.deinitCount) == 0

                cache.set(key: "d", value: Hoge())
                expect(Hoge.initCount)   == 4
                expect(Hoge.deinitCount) == 1

                cache.remove(key: "b")
                expect(Hoge.initCount)   == 4
                expect(Hoge.deinitCount) == 2

                cache.clear()
                expect(Hoge.initCount)   == 4
                expect(Hoge.deinitCount) == 4
            }
        }
    }
}

class Hoge {
    static var initCount = 0
    init() {
        Hoge.initCount++
    }

    static var deinitCount = 0
    deinit {
        Hoge.deinitCount++
    }
}
