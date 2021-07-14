//
//  gifCell.swift
//  GiphySearch
//
//  Created by karlis.butins on 30/06/2021.
//

import UIKit

class GifCell: UICollectionViewCell {
    
    @IBOutlet private var loader: UIActivityIndicatorView!
    
    var gif: Gif? {
        didSet {
            fetchGif()
        }
    }
    
   private var gifView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        gifView.image = nil
    }
    
    private func fetchGif() {
        // Making sure cell has a gif object
        if let gif = gif {
            // Grab gif from gif object and display it inside the imageview
            DispatchQueue.global(qos: .default).async {
                // Fetch gif on background and set it in cache
                let gifURL = gif.getGifURL()
                guard let image = GifCache.shared.getGif(url: gifURL) ?? UIImage.gif(url: gifURL) else { return }
                
                DispatchQueue.main.async {
                    // UI thread
                    GifCache.shared.setGif(url: gifURL, image: image)

                    guard gifURL == gif.getGifURL() else { return }
                    
                    self.gifView.image = image
                    self.gifView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
                    self.addSubview(self.gifView)
                }
            }
        }
    }
}
