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
