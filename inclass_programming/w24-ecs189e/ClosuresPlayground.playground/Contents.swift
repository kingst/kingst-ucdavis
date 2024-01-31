import UIKit

var greeting = "Hello, playground"

let names = ["Bob", "Annie", "Milo", "Honey"]

func descending(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}

let namedFunction = names.sorted(by: descending)
print(namedFunction)

let longForm = names.sorted(by: { (_ s1: String, _ s2: String) -> Bool in
    return s1 > s2
})
print(longForm)

let typeInference = names.sorted(by: { s1, s2 in return s1 > s2 })
print(typeInference)

let trainiling = names.sorted { $0 > $1 }

let tooConcise = names.sorted(by: > )
let numbers = [1, 2, 3, 4]

let sum = numbers.reduce(0, +)
print(sum)

