//
//  GifNetwork.swift
//  GiphySearch
//
//  Created by karlis.butins on 30/06/2021.
//

import Foundation
import UIKit

class GifNetwork {
    
    private let apiKey = "R6Ygl776KjZaeXVuFP3QHQTPGCFjmDGP"
    private let limit = 20
    
    func fetchGifs(
        searchTerm: String,
        page: Int,
        completion: @escaping (_ response: GifArray?) -> Void
    ) {
        let url = urlBuilder(searchTerm: searchTerm, page: page)
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching from Giphy: ", error.localizedDescription)
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
