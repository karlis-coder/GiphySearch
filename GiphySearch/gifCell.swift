//
//  gifCell.swift
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
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    var gifView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private func fetchGif() {
        // Making sure cell has a gif object
        if gif != nil {
            // Grab gif from gif object and display it inside the imageview
            DispatchQueue.global(qos: .default).async {
                // Fetch gif on background and set it in cache
                let gifURL = self.gif!.getGifURL()
                guard let image = GifCache.shared.getGif(url: gifURL) ?? UIImage.gif(url: gifURL) else { return }
                
                DispatchQueue.main.async {
                    // UI thread
                    GifCache.shared.setGif(url: gifURL, image: image)

                    guard gifURL == self.gif?.getGifURL() else { return }
                    
                    self.gifView.image = image
                    self.gifView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
                    self.addSubview(self.gifView)
                }
            }
        }
    }
    
    override func prepareForReuse() {
        gifView.image = nil
    }
}
