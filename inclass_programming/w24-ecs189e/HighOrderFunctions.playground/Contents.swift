import UIKit

var greeting = "Hello, playground"

let pictureName = { "\($0).jpg" }("bob")

let s0 = "abc"
let data0 = s0.data(using: .utf8)
let s1: String? = "def"
let data1 = s1?.data(using: .utf8)
let isBestDogEver = s1.map { $0 == "bob" }

/**
 Write a mapper that
 - Operate on String? variable and append the string ".jpg" to the end
 - Convert to utf8
 - return type Data?
 */

let convertedPictureName = s1.map { "\($0).jpeg".data(using: .utf8) }

// NOT A REAL IMPLEMENTATION JUST FOR CONCEPTS
struct MyOptional<V> {
    let theValue: V?
    func map<T>(transform: (V) -> T) -> T? {
        guard let value = self.theValue else { return nil }
        return transform(value)
    }
}

let convertedPictureName2 = s1.map { name in
    //return name.data(using: .utf8)!
    return name.data(using: .utf8) ?? Data()
}

extension MyOptional {
    func flatMap<T>(transform: (V) -> T?) -> T? {
        guard let value = self.theValue else { return nil }
        return transform(value)
    }
}

let convertedPictureName3 = s1.flatMap { "\($0).jpeg".data(using: .utf8) }

let aString = "Milo"
let convertedPicture4 = "\(aString).jpeg".data(using: .utf8)

let s2 = "Scriggins"
let convertedPictureName4 = s2.map { "\($0).jpeg".data(using: .utf8) }

// here's what I think swift is doing
let a1 = [s2]
let a2 = a1.map { "\($0).jpeg".data(using: .utf8) }

let convertedPictureName5 = s1.map({ "\($0).jpeg" })?.data(using: .utf8)

