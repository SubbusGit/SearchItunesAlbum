//
//  ServiceManager.swift
//  Search
//
//  Created by Subbu on 07/09/20.
//  Copyright © 2020 Subbu. All rights reserved.
//

import UIKit

class ServiceManager {
    static func getApidata(url:String, completion: @escaping([AlbumModel]?)->Void, onFailure:@escaping(Error?)->Void){
        if let url = URL(string: url) {
            URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
                if let data = data {
                    completion( ModelMapper.mapModel(jsonData: data))
                }else{
                    onFailure(error)
                }
            }.resume()
        }

    }
}
