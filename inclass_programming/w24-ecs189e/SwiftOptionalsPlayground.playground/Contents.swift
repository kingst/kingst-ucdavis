import SwiftUI

var greeting = "Hello, playground"

func foo(bar: String?) -> Void {
    // what type is viz what does this expression do?
    let biz = bar?.hasPrefix("A")
    // what type is baz and what does this expression do.
    let baz = bar ?? "Bob"
}

let name: String? = String("Bob")

print(name)
if let aName = name {
    print("My dog's name is \(aName)")
} else {
    print("Name is nil")
}

func dogNickName(for name: String?) -> String? {
    guard name != nil else {
        print("name is nil")
        return nil
    }
    
    if name == "Bob" {
        return "Scriggins"
    }
    
    return nil
}

let name1 = dogNickName(for: "Milo")
let name2 = dogNickName(for: name)

print(name2)

let hasPrefix = name?.hasPrefix("D")

func getOrElse(_ value: String?, defaultValue: String) -> String {
    if let value = value {
        return value
    } else {
        return defaultValue
    }
    
    /*
    guard let value = value else {
        return defaultValue
    }
    
    return value
     */
}

let optionalName: String? = Optional.none

let theName = name ?? "Milo"
let theOtherName = optionalName ?? "Milo"

print(theName)
print(theOtherName)

let dontEverDoThisInYourWork = name!

