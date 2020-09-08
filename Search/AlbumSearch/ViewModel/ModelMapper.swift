//
//  ModelMapper.swift
//  Search
//
//  Created by Subbu on 07/09/20.
//  Copyright © 2020 Subbu. All rights reserved.
//

import UIKit

class ModelMapper: NSObject {

    static func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    static func mapModel(jsonData: Data) -> [AlbumModel]? {
        do {
            let decodedData = try AlbumData(data: jsonData)
            return decodedData.results
        } catch {
            print("decode error")
        }
        return nil
    }
    
}
