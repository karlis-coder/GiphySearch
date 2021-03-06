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
        
        network.fetchGifs(searchTerm: searchText, page: page) { [weak self] results in
            DispatchQueue.main.async {
                switch results {
                case .success(let gifArray): self?.showResults(gifArray: gifArray, page: page)
                case .failure(let error): self?.handleError(error: error)
                }
            }
        }
    }
    
    private func showResults(gifArray: GifArray, page: Int) {
        currentPage = page
        gifs += gifArray.gifs
        collectionView.reloadData()
        
        if page == 1 {
            collectionView.setContentOffset(.zero, animated: false)
        }
    }
    
    private func handleError(error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true)
        })
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func clearPreviousData() {
        currentPage = nil
        gifs = []
        gifCache.clear()
    }
    
    func searchGifs(for searchText: String) {
        clearPreviousData()
        
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
        let collectionViewSize = collectionView.frame.size.width
        return CGSize(width: collectionViewSize / 2, height: collectionViewSize / 2)
    }
}
