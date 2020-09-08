//
//  CartViewModel.swift
//  Search
//
//  Created by Subbu on 08/09/20.
//  Copyright © 2020 Subbu. All rights reserved.
//

import UIKit

class CartViewModel: NSObject {
    //Singleton instance
    static let shared = CartViewModel()
    var cartItems = [AlbumModel]()
    func addToCart(album:AlbumModel)  {
        cartItems.append(album)
    }
    func removeItem(by trackName:String) -> Void {
        let index = cartItems.firstIndex(where: { (object) -> Bool in
            return object.trackName == trackName
        })
        guard let removeIndex = index else{ return }
        cartItems.remove(at: removeIndex)
    }
    func getCountText() -> String {
        return cartItems.count.description
    }

}
