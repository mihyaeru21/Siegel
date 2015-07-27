# Siegel

[![CI Status](http://img.shields.io/travis/mihyaeru21/Siegel.svg?style=flat)](https://travis-ci.org/mihyaeru21/Siegel)
[![Version](https://img.shields.io/cocoapods/v/Siegel.svg?style=flat)](http://cocoapods.org/pods/Siegel)
[![License](https://img.shields.io/cocoapods/l/Siegel.svg?style=flat)](http://cocoapods.org/pods/Siegel)
[![Platform](https://img.shields.io/cocoapods/p/Siegel.svg?style=flat)](http://cocoapods.org/pods/Siegel)

A simple implementation of LRU cache written in Swift.
This library is inspired by [Cache::LRU](https://metacpan.org/pod/Cache::LRU).

## Usage

```swift
let cache = Siegel<Int?>(size: 3)

// set
cache.set(key: "a", value: 1)
cache.set(key: "b", value: 2)
cache.set(key: "c", value: nil)
cache.set(key: "d", value: 4)

// get
cache.get(key: "a")      // => nil
cache.get(key: "b")      // => 2
cache.get(key: "c")      // => nil
cache.get(key: "4")      // => 4

// exists
cache.exists(key: "a")   // => false
cache.exists(key: "b")   // => true
cache.exists(key: "c")   // => true (if using optional type, it can contain nil)
cache.exists(key: "d")   // => true
cache.exists(key: "e")   // => false

// remove
cache.remove(key: "b")
cache.get(key: "b")      // => nil
cache.exists(key: "b")   // => false

// clear
cache.clear
cache.exists(key: "a")   // => false
cache.exists(key: "b")   // => false
cache.exists(key: "c")   // => false
cache.exists(key: "d")   // => false
cache.exists(key: "e")   // => false

```

## Installation

Siegel is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Siegel'
```

## Author

Mihyaeru, mihyaeru21@gmail.com

## License

Siegel is available under the MIT license. See the LICENSE file for more info.
