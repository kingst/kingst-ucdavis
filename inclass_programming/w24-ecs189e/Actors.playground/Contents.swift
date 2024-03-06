import UIKit

var greeting = "Hello, playground"
actor NotARealLock {
    var isLocked = false
    func lock() async {
        // this is busy waiting, which you should avoid
        // this lock code is just to show concepts
        while isLocked {
            await Task.yield()
        }
        isLocked = true
    }
    
    func unlock() async {
        isLocked = false
    }
}

func fetchImage(_ url: URL) async -> String? {
    let emojis = "😺😸😾😿🙀😽😼😻😹😀😁😂😃😄😅😆😇😈😉😊😋😌😍😎😏"
    try? await Task.sleep(for: .seconds(3))
    return emojis.randomElement().map { String($0) }
}

actor EmojiCache {
    var cache: [URL: String] = [:]
    var lock = NotARealLock()
    
    // correctness requirements:
    //   - new calls to a URL that isn't cached will fetch one from the network
    //   - subsequent calls to a URL will return the cached value
    func getEmoji(url: URL) async -> String? {
        if let emoji = cache[url] {
            return emoji
        } else {
            // unlock and suspend atomically
            let emoji = await fetchImage(url)
            // resume and lock atomically
            cache[url] = cache[url] ?? emoji
        }
        
        let emoji = cache[url]
        return emoji
    }
    
    func protectedAfterAsync(_ string: String) async {
        self.cache[URL(string: "foo")!] = "abc"
    }
    
    func combineDispatchQueuesWithActors() async -> String {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .default).async {
                Task {
                    await self.protectedAfterAsync("abc")
                    continuation.resume(returning: "some string")
                }
            }
        }
    }
}

let url = URL(string: "https://bob.cs.ucdavis.edu/emoji")!
let cache = EmojiCache()
Task {
    let emoji = await cache.getEmoji(url: url)
    print(emoji ?? "?")
}
Task {
    let emoji = await cache.getEmoji(url: url)
    print(emoji ?? "?")
}

