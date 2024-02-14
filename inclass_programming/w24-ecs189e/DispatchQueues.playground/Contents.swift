import UIKit

var greeting = "Hello, playground"

DispatchQueue.main.async {
    sleep(2)
    print("Task 1")
}

DispatchQueue.main.async {
    sleep(2)
    print("Task 2")
}

DispatchQueue.main.async {
    sleep(2)
    print("Task 3")
}

print("Tasks all queued")
