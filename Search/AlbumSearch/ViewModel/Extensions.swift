//
//  Extensions.swift
//  Search
//
//  Created by Subbu on 08/09/20.
//  Copyright © 2020 Subbu. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title:String?,message:String?, actions:[String]){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
       
        actions.forEach { (action) in
            alert.addAction(UIAlertAction(title: action, style: .default, handler: nil))
        }
        self.present(alert, animated: true, completion: nil)
    }
   
}
extension Notification.Name {
    static let updateCartCount = NSNotification.Name("UpdateCartCount")
}
