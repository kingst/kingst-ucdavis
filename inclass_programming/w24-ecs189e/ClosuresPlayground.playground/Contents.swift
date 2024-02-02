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

let a = {
    print("within closure before sleep")
    sleep(5)
    print("within closure")
}()
print("after closure")

Task(operation: {
    sleep(5)
    print("within task")
})
sleep(10)
print("after task")

func makeIncrementor(incrementBy amount: Int) -> (() -> Int, () -> Int) {
    var runningTotal = 0
    func incrementor() -> Int {
        runningTotal += amount
        return runningTotal
    }
    func decrementor() -> Int {
        runningTotal -= amount
        return runningTotal
    }
    return (incrementor, decrementor)
}
let (incrementByTen, decrementByTen) = makeIncrementor(incrementBy: 10)
incrementByTen()
incrementByTen()
incrementByTen()
decrementByTen()

let (incrementBySeven, _) = makeIncrementor(incrementBy: 7)
incrementBySeven()
incrementBySeven()

incrementByTen()

let referenceToIncrementByTen = incrementByTen
referenceToIncrementByTen()

func makeIncrementors() -> [() -> Int] {
    var runningTotal = 0
    var incrementors: [() -> Int] = []
    for amount in 0...9 {
        incrementors.append({
            runningTotal += amount
            return runningTotal
        })
    }
    
    return incrementors
}

let incrementors = makeIncrementors()
incrementors[0]()
incrementors[5]()
incrementors[3]()

func makeIncrementors2() -> [() -> Int] {
    var runningTotal = 0
    var incrementors: [() -> Int] = []
    for amount in 0...9 {
        runningTotal += amount
        incrementors.append({
            return runningTotal
        })
    }
    
    return incrementors
}
