//
//  Album.swift
//  Search
//
//  Created by Subbu on 07/09/20.
//  Copyright © 2020 Subbu. All rights reserved.
//

import UIKit

struct AlbumData: Codable {
    let resultCount: Int
    let results: [AlbumModel]
}


extension AlbumData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AlbumData.self, from: data)
    }

    func with(resultCount: Int? = nil, results: [AlbumModel]? = nil) -> AlbumData {
        return AlbumData(
            resultCount: resultCount ?? self.resultCount,
            results: results ?? self.results
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - AlbumModel
struct AlbumModel: Codable {
    var artistName: String?
    var trackName: String?
    var collectionName: String?
    var collectionPrice: Double?
    var releaseDate: String?
    let artworkUrl100: String?
    
    
    enum CodingKeys: String, CodingKey {
        case artistName, collectionName, trackName
        case releaseDate, artworkUrl100, collectionPrice
    }
}

// MARK: AlbumModel convenience initializers and mutators

extension AlbumModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AlbumModel.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        artistName: String? = nil,
        collectionName: String?? = nil,
        trackName: String? = nil,
        artworkUrl100: String? = nil,
        collectionPrice: Double? = nil,
        releaseDate: String? = nil
    ) -> AlbumModel {
        return AlbumModel(
            artistName: artistName ?? self.artistName,
            trackName: trackName ?? self.trackName,
            collectionName: collectionName ?? self.collectionName,
            collectionPrice: collectionPrice ?? self.collectionPrice, releaseDate: releaseDate ?? self.releaseDate,
            artworkUrl100: artworkUrl100 ?? self.artworkUrl100
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
//    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//        decoder.dateDecodingStrategy = .iso8601
//    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
//    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//        encoder.dateEncodingStrategy = .iso8601
//    }
    return encoder
}

extension AlbumModel: Hashable {
   func hash(into hasher: inout Hasher) {
        hasher.combine(trackName)
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        return filter { (key) -> Bool in
            addedDict.updateValue(true, forKey: key) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

