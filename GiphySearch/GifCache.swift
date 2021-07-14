//
//  MacOS 11.4
//  Swift 5.0
//  GiphySearch
//

import UIKit

class GifCache {
    
    static var shared = GifCache()
    
    private init() { }
    
    private var items = [String: UIImage]()
    
    func setGif(url: String, image: UIImage) {
        items[url] = image
    }
    
    func getGif(url: String) -> UIImage? {
        items[url]
    }
    
    func clear() {
        items.removeAll()
    }
}
