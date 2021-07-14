//
//  GifNetwork.swift
//  GiphySearch
//
//  Created by karlis.butins on 30/06/2021.
//

import Foundation
import UIKit

class GifNetwork {
    let apiKey = "R6Ygl776KjZaeXVuFP3QHQTPGCFjmDGP"
    
    func fetchGifs(searchTerm: String, page: Int, completion: @escaping (_ response: GifArray?) -> Void) {
        // Create a GET url request
        let url = urlBuilder(searchTerm: searchTerm, page: page)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print("Error fetching from Giphy: ", err.localizedDescription)
            }
            do {
                // Decode the data into array of Gifs
                DispatchQueue.main.async {
                    let object = try! JSONDecoder().decode(GifArray.self, from: data!)
                    completion(object)
                }
            }
        }.resume()
    }
    
    // Returns url with API key and search term
    
    let limit = 20
    
    func urlBuilder(searchTerm: String, page: Int) -> URL {
        let apikey = apiKey
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.giphy.com"
        components.path = "/v1/gifs/search"
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apikey),
            URLQueryItem(name: "q", value: searchTerm),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(page * limit)")
        ]
        return components.url!
    }
}

class GifCache {
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

// Create global gif cache object

let gifCache = GifCache()
