//
//  ViewController.swift
//  GiphySearch
//
//  Created by karlis.butins on 30/06/2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var network = GifNetwork()
    var gifs = [Gif]()
    var currentPage: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        // Search bar
        searchBar.searchTextField.delegate = self
        searchBar.searchTextField.placeholder = "Lets go"
        searchBar.returnKeyType = .search
    }
    
    //Fetch gifs based on search term and populate tableview
    func searchGifs(for searchText: String, page: Int) {
        guard currentPage != page else { return }
        
        network.fetchGifs(searchTerm: searchText, page: page) { gifArray in
            if gifArray != nil {
                self.currentPage = page
                self.gifs += gifArray!.gifs
                self.collectionView.reloadData()
            }
            
            if page == 1 {
                self.collectionView.setContentOffset(.zero, animated: false)
            }
        }
    }
    
    func searchGifs(for searchText: String) {
        // Clear previous data
        currentPage = nil
        gifs = []
        gifCache.clear()
        
        // lets search again from first page
        searchGifs(for: searchText, page: 1)
    }
}

// MARK: - Search bar functions
extension ViewController: UISearchTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField.text != nil {
            searchGifs(for: textField.text!)
        }
        
        return true
    }
}

// MARK: - CollectionView functions

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        gifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCell", for: indexPath) as! GifCell
        cell.gif = gifs[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // We've scrolled to bottom - fetch next page
        if indexPath.row == gifs.count - 1, let currentPage = currentPage {
            searchGifs(for: searchBar.text!, page: currentPage + 1)
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize / 2, height: collectionViewSize / 2)
    }
}
