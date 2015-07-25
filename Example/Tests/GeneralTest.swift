// https://github.com/Quick/Quick

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
    }
}
