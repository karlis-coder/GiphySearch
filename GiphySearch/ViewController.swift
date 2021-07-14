//
//  ViewController.swift
//  GiphySearch
//
//  Created by karlis.butins on 30/06/2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var searchBar: UISearchBar!
    
    private var network = GifNetwork()
    private var gifs = [Gif]()
    private var currentPage: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        // Search bar
        searchBar.searchTextField.delegate = self
        searchBar.searchTextField.placeholder = "Lets go"
        searchBar.returnKeyType = .search
    }
    
    //Fetch gifs based on search term and populate tableview
    private func searchGifs(for searchText: String, page: Int) {
        guard currentPage != page else { return }
        
        network.fetchGifs(searchTerm: searchText, page: page) { [weak self] gifArray in
            if let gifArray = gifArray {
                self?.currentPage = page
                self?.gifs += gifArray.gifs
                self?.collectionView.reloadData()
            }
            
            if page == 1 {
                self?.collectionView.setContentOffset(.zero, animated: false)
            }
        }
    }
    
    private func searchGifs(for searchText: String) {
        // Clear previous data
        currentPage = nil
        gifs = []
        GifCache.shared.clear()
        
        // lets search again from first page
        searchGifs(for: searchText, page: 1)
    }
}

// MARK: - UISearchTextFieldDelegate

extension ViewController: UISearchTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = textField.text {
            searchGifs(for: text)
        }
        
        return true
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        gifs.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCell", for: indexPath) as? GifCell {
            cell.gif = gifs[indexPath.row]
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        // We've scrolled to bottom - fetch next page
        if indexPath.row == gifs.count - 1,
           let text = searchBar.text,
           let currentPage = currentPage {
            searchGifs(for: text, page: currentPage + 1)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let padding: CGFloat = 20
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize / 2, height: collectionViewSize / 2)
    }
}
