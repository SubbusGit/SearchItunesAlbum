//
//  AlbumResultsViewController.swift
//  Search
//
//  Created by Subbu on 07/09/20.
//  Copyright © 2020 Subbu. All rights reserved.
//

import UIKit

class AlbumResultsViewController:  UIViewController, UISearchResultsUpdating {
    
    let BASE_URL = "https://itunes.apple.com/search?term=all"
    @IBOutlet weak var albumResultsTableView: UITableView!
    @IBOutlet weak var cartButton: UIBarButtonItem!
    var viewModel = AlbumResultsViewModel()
    var searchController: UISearchController?
    
    var isSearchBarEmpty: Bool {
      return searchController?.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
        return searchController?.isActive ?? false && !isSearchBarEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(didTapSortButton))
        addSearchController()
        albumResultsTableView.estimatedRowHeight = UITableView.automaticDimension
        albumResultsTableView.allowsMultipleSelection = true
        viewModel.getApiData(url: BASE_URL) {
            self.reloadData()
        }
        addObservers()
    }
    func addObservers()  {
        NotificationCenter.default.addObserver(self, selector: #selector(setCartCount), name: .updateCartCount, object: nil)
    }
    @objc func setCartCount(){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
            self.cartButton.title = "Cart(\(CartViewModel.shared.getCountText()))"
        })
       
    }
    func reloadData()  {
        DispatchQueue.main.async {
            self.albumResultsTableView.reloadData()
        }
    }
    @objc func didTapSortButton() {
        
        let actionSheet = UIAlertController(title: "Sort By", message: "Select an option to sort", preferredStyle: .actionSheet)
        let titles = SortOptions.allCases.map({"\($0.rawValue)"})
        titles.forEach { (title) in
            let action = UIAlertAction(title: title, style: .default) { (action) in
                self.viewModel.updateTableOrder(with: SortOptions(rawValue: action.title!)!)
                self.reloadData()
            }
            actionSheet.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            //no action
        }
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func addSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AlbumResultsViewController {
        
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        viewModel.filterContentForSearchText(text, completion: {
            albumResultsTableView.reloadData()
        })
    }
}

extension AlbumResultsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering == true {
            return viewModel.filteredAlbums.count
        }
        return viewModel.albums?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumResultsTableViewCell") as? AlbumResultsTableViewCell,
            let album = viewModel.getAlbums(isFilterOn: isFiltering)?[indexPath.row] else {
                return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.setData(album: album)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = viewModel.getAlbums(isFilterOn: isFiltering)?[indexPath.row]
        CartViewModel.shared.addToCart(album: album!)
        viewModel.postNotification(name: .updateCartCount)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let album = viewModel.getAlbums(isFilterOn: isFiltering)?[indexPath.row], let track = album.trackName else{
            return
        }
        CartViewModel.shared.removeItem(by: track)
        viewModel.postNotification(name: .updateCartCount)
    }
    
}
