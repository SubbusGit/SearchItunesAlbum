//
//  AlbumSearchViewModel.swift
//  Search
//
//  Created by Subbu on 07/09/20.
//  Copyright © 2020 Subbu. All rights reserved.
//

import UIKit

enum SortOptions: String, CaseIterable {
    case releaseDate = "Release Date",
    collectionName = "Collection Name",
    trackName = "Track Name",
    artistName = "Artist Name",
    collectionPrice = "Collection Price(Descending)"
    
}


class AlbumResultsViewModel:  NSObject {
    var albums: [AlbumModel]?
    var filteredAlbums: [AlbumModel] = []
    
    func getLocalData(completion: (() -> Void)) {
        if let localData = ModelMapper.readLocalFile(forName: "AlbumData") {
            var array = ModelMapper.mapModel(jsonData: localData)
            //Remove Duplicate data by Trackname
            array?.removeDuplicates()
            albums = sortBy(albums: array, sortOption: .releaseDate)
            completion()
        }
    }
    func getApiData(url:String,completion:@escaping (() -> Void)) {
            ServiceManager.getApidata(url: url, completion: { (result) in
                var array = result
                array?.removeDuplicates()
                self.albums = self.sortBy(albums: array, sortOption: .releaseDate)
                completion()
            }) { (error) in
                print(error?.localizedDescription as Any)
            }
    }
    
    func filterContentForSearchText(_ searchText: String, completion: (() -> Void)) {
        //Filtering albums with search text in artist, track name, collection name
        guard let filteredAlbumsByArtists = albums?.filter({ ($0.artistName?.lowercased().contains(searchText.lowercased()) ?? false) }),
            let filteredAlbumsByTrackName = albums?.filter({ ($0.trackName?.lowercased().contains(searchText.lowercased()) ?? false) }),
            let filteredAlbumsByCollectionName = albums?.filter({ ($0.collectionName?.lowercased().contains(searchText.lowercased()) ?? false) }) else { return }
        let filteredArray = filteredAlbumsByArtists + filteredAlbumsByTrackName + filteredAlbumsByCollectionName
        filteredAlbums = filteredArray
        completion()
    }
    
    func getAlbums(isFilterOn: Bool) -> [AlbumModel]? {
        let array = isFilterOn ? filteredAlbums : albums
        return array
    }
    
    func updateTableOrder(with sortOption: SortOptions) {
        albums = sortBy(albums: albums, sortOption: sortOption)
    }
    
    func sortBy(albums: [AlbumModel]?, sortOption: SortOptions) -> [AlbumModel]? {
        guard let array = albums else { return albums }
        switch sortOption {
        case .collectionPrice:
            return array.sorted(by: { (album1, album2) -> Bool in
                guard let album1Price = album1.collectionPrice, let album2Price = album2.collectionPrice else {return false}
               return album1Price > album2Price
            })
            
        case .collectionName:
            return array.sorted(by: { (album1, album2) -> Bool in
                album1.collectionName?.lowercased() ?? "" < album2.collectionName?.lowercased() ?? ""
            })
            
        case .trackName:
            return array.sorted(by: { (album1, album2) -> Bool in
                guard let album1TrackName = album1.trackName?.lowercased(), let album2TrackName = album2.trackName?.lowercased() else {return false}
                return album1TrackName < album2TrackName
            })
        case .artistName:
            return array.sorted(by: { (album1, album2) -> Bool in
                 guard let album1ArtistName = album1.artistName?.lowercased(), let album2ArtistName = album2.artistName?.lowercased() else {return false}
                return album1ArtistName < album2ArtistName
            })
            
        default:
            return array.sorted(by: { (album1, album2) -> Bool in
                guard let date1 = album1.releaseDate, let date2 = album2.releaseDate else { return false}
                return date1.getDate() < date2.getDate()
               
            })
            
        }
    }
    func postNotification(name:Notification.Name)  {
        NotificationCenter.default.post(name: name, object: nil)
    }
   
}
extension String{
    func getDate() -> Date {
             let dateFormatter = DateFormatter()
             dateFormatter.timeZone = .autoupdatingCurrent
             dateFormatter.dateFormat = "dd MMM yyyy"
             return dateFormatter.date(from: self) ?? Date()
         }
}
extension Date{
  
    func getString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
}

