import UIKit

var greeting = "Hello, playground"

func foo(bar: String?) -> Void {
    // what type is viz what does this expression do?
    let biz = bar?.hasPrefix("A")
    // what type is baz and what does this expression do.
    let baz = bar ?? "Bob"
}
