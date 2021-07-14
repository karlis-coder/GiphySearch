//
//  Gif.swift
//  GiphySearch
//
//  Created by karlis.butins on 30/06/2021.
//

import Foundation
// Gif object array
struct GifArray: Decodable {
    var gifs: [Gif]
    enum CodingKeys: String, CodingKey {
        case gifs = "data"
    }
}
// Gif properties
struct Gif: Decodable {
    var gifSources: GifImages
    enum CodingKeys: String, CodingKey {
        case gifSources = "images"
    }
    //Returns download url of gif
    func getGifURL() -> String{
        return gifSources.previewGif.url
    }
}
struct GifImages: Decodable {
    var previewGif: previewGif
    enum CodingKeys: String, CodingKey {
        case previewGif = "preview_gif"
    }
}
// URL to data of gif
struct previewGif: Decodable {
    var url: String
}
