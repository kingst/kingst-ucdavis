import UIKit

var greeting = "Hello, playground"

class MlRequest {
    let mlQueue = DispatchQueue(label: "mlqueue")
    
    var runningTasks = 0
    var deferredTasks: [(UIImage, (String) -> Void)] = []
    
    // this would run the actual ML and produce a result
    func predict(image: UIImage) -> String { "" }
    
    func runPendingTasks() {
        if let (image, complete) = deferredTasks.first {
            self.runningTasks += 1
            deferredTasks = deferredTasks.dropFirst().map { $0 }
            DispatchQueue.global(qos: .default).async {
                let result = self.predict(image: image)
                complete(result)
                self.mlQueue.async {
                    self.runningTasks -= 1
                    self.runPendingTasks()
                }
            }
        }
    }
    
    func makeMlRequest(image: UIImage, complete: @escaping (String) -> Void) {
        mlQueue.async {
            if self.runningTasks < 4 {
                self.runningTasks += 1
                // this is a parallel queue
                DispatchQueue.global(qos: .default).async {
                    let result = self.predict(image: image)
                    complete(result)
                    self.mlQueue.async {
                        self.runningTasks -= 1
                        self.runPendingTasks()
                    }
                }
            } else {
                self.deferredTasks.append((image, complete))
            }
        }
    }
}
