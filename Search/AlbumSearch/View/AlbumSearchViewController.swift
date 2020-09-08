//
//  ViewController.swift
//  Search
//
//  Created by Subbu on 07/09/20.
//  Copyright © 2020 Subbu. All rights reserved.
//

import UIKit
enum SearchOptions: String, CaseIterable{
    case artistName = "Artist Name*",
    trackName = "Track Name*",
    collectionName = "Collection Name",
    collectionPrice = "Collection Price",
    releaseDate = "Release Date"
}
class AlbumSearchViewController: UIViewController {
@IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cartButton: UIBarButtonItem!
    @IBOutlet weak var albumSearchTableView: UITableView!
var currentField:UITextField?
var searchViewModel :AlbumSearchViewModel!
    override func viewDidLoad() {
        searchViewModel = AlbumSearchViewModel(viewController: self)
        super.viewDidLoad()
        addObservers()     // Do any additional setup after loading the view.
    }
    func addObservers()  {
        NotificationCenter.default.addObserver(self, selector: #selector(setCartCount), name: .updateCartCount, object: nil)
    }

   @objc func setCartCount(){
       DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
           self.cartButton.title = "Cart(\(CartViewModel.shared.getCountText()))"
       })
      
   }
    @IBAction func searchAction(_ sender: Any) {
        currentField?.resignFirstResponder()
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard identifier == "showResults" else {
            return true
        }
        var canPerform = false
        searchViewModel.validate(errorType: { (error) in
                   if let err = error{
                       self.showAlert(title: "Alert", message: err.rawValue, actions: ["OK"])
                    canPerform =  false
                   }else{
                    canPerform = true
                   }
               })
        return canPerform
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AlbumSearchViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return SearchOptions.allCases.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumSearchTableViewCell", for: indexPath) as? AlbumSearchTableViewCell else { return UITableViewCell() }
        let title = SearchOptions.allCases[indexPath.row]
        cell.tiltleLabel.text = title.rawValue
        //cell.valueField.text = titles[indexPath.row].rawValue
        cell.valueField.keyboardType = searchViewModel.getKeyBoardType(type: title)
//        let button = searchButton
//        cell.valueField.inputAccessoryView = button
        if title == .releaseDate{
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.addTarget(searchViewModel, action: #selector(searchViewModel.didSelectDate(sender:)), for: .valueChanged)
            cell.valueField.inputView = datePicker
        }
        cell.valueField.text = searchViewModel.getText(for: title)
        cell.valueField.delegate = searchViewModel
        cell.valueField.tag = indexPath.row
        return cell
    }
    
    
}
