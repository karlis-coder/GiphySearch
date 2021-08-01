//
//  GifCell.swift
//  GiphySearch
//
//  Created by karlis.butins on 30/06/2021.
//

import UIKit
class GifCell: UICollectionViewCell {
    var gif: Gif? {
        didSet {
            fetchGif()
        }
    }
    
    @IBOutlet weak var gifImage: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    private func fetchGif() {
        // Making sure cell has a gif object
        if let gif = gif {
            // Grab gif from gif object and display it inside the imageview
            DispatchQueue.global(qos: .default).async {
                // Fetch gif on background and set it in cache
                let gifURL = gif.getGifURL()
                guard let image = gifCache.getGif(url: gifURL) ?? UIImage.gif(url: gifURL) else { return }
                
                DispatchQueue.main.async {
                    // UI thread
                    gifCache.setGif(url: gifURL, image: image)

                    guard gifURL == gif.getGifURL() else { return }
                    
                    self.gifImage.image = image
                }
            }
        }
    }
    
    override func prepareForReuse() {
        gifImage.image = nil
    }
}
