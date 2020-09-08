//
//  AlbumSearchViewModel.swift
//  Search
//
//  Created by Subbu on 07/09/20.
//  Copyright © 2020 Subbu. All rights reserved.
//

import UIKit

class AlbumSearchViewModel: NSObject {
    var albumToSearch:AlbumModel?
    weak var controller:  AlbumSearchViewController?
    init(viewController:AlbumSearchViewController) {
        self.albumToSearch = AlbumModel.init(artistName: nil, trackName: nil, collectionName: nil, collectionPrice: nil, releaseDate: nil, artworkUrl100: nil)
        self.controller = viewController
    }
    func validate(errorType: (ErrorTypes?) -> Void)  {
        guard let albumName = albumToSearch?.artistName, !albumName.isEmpty else{
            errorType(.emptyArtistName)
            return
        }
        guard let trackName = albumToSearch?.trackName, !trackName.isEmpty else{
             errorType(.emptyTrackName)
            return
        }
        errorType(nil)
    }

    func getKeyBoardType(type:SearchOptions) -> UIKeyboardType {
        switch type {
        case .artistName,.collectionName, .trackName:
            return .alphabet
        case .collectionPrice:
            return .decimalPad
        default:
            return .default
        }
    }
}
extension AlbumSearchViewModel: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        controller?.currentField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let searchFeild = SearchOptions.allCases[textField.tag]
        let text = textField.text
        switch searchFeild {
        case .artistName:
            albumToSearch?.artistName = text
        case .trackName:
            albumToSearch?.trackName = text
        case .collectionName:
            albumToSearch?.collectionName = text
        case .collectionPrice:
            albumToSearch?.collectionPrice = Double(text ?? "0.0")
        case .releaseDate:
            albumToSearch?.releaseDate = text
        
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func getText(for type:SearchOptions) -> String? {
        var text:String?
        switch type {
        case .artistName:
           text = albumToSearch?.artistName
        case .trackName:
            text = albumToSearch?.trackName
        case .collectionName:
            text = albumToSearch?.collectionName
        case .collectionPrice:
            text = albumToSearch?.collectionPrice?.description
        case .releaseDate:
           text =  albumToSearch?.releaseDate
        }
        return text
    }
    @objc func didSelectDate(sender:UIDatePicker){
        controller?.currentField?.text = sender.date.getString()
        self.albumToSearch?.releaseDate = sender.date.getString()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.controller?.albumSearchTableView.reloadData()
        }
    }
}
