//
//  AlbumResultsTableViewswift
//  Search
//
//  Created by Subbu on 07/09/20.
//  Copyright © 2020 Subbu. All rights reserved.
//

import UIKit

class AlbumResultsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var collectionPrice: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(album:AlbumModel){
        artistName.text = album.artistName
               collectionName.text = album.collectionName
               trackName.text = album.trackName
               releaseDate.text = album.releaseDate
        collectionPrice.text = "$ \(album.collectionPrice ?? 0.0)"
        guard let url = album.artworkUrl100 else { return }
        setImage(url: url)
             
    }
    func setImage(url:String){
        if let url = URL(string: url) {
            URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
                if let data = data {
                    DispatchQueue.main.async { [weak self] in
                        self?.albumImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
