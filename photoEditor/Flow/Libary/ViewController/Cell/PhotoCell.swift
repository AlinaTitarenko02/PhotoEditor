//
//  PhotoCell.swift
//  photoEditor
//
//  Created by Alina Titarenko on 21.12.2023.
//

import UIKit

class PhotoCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    static let id = String(describing: PhotoCell.self)
    
    func setUp(image: UIImage) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
    }

}
