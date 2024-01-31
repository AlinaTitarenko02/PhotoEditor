//
//  EffectsCellCollectionViewCell.swift
//  photoEditor
//
//  Created by Alina Titarenko on 29.11.2023.
//

import UIKit

enum EffectsSatusEnum: String {
    case none = "none"
    case CIPhotoEffectMono = "CIPhotoEffectMono"
    case CIPhotoEffectNoir = "CIPhotoEffectNoir"
    case CIPhotoEffectProcess = "CIPhotoEffectProcess"
    case CIPhotoEffectTonal = "CIPhotoEffectTonal"
    case addItem = "addItem"
}

enum StatusEnum {
    case defaultCell
    case customCell
}

class EffectsCell: UICollectionViewCell {
    
    // MARK: - IBOutlet

    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    static let id = String(describing: EffectsCell.self)
    
    // MARK: - Public method
    
    func setup(status: StatusEnum = .defaultCell, efect: EffectsSatusEnum?, effect: PhotoModel?)  {
        switch status {
        case .defaultCell:
            guard let effect = efect else { return }
            defaultSetup(efect: effect)
        case .customCell:
            guard let effect = effect else { return}
            nameTitle.text = effect.name
            imageView.image = UIImage(named: "flowerNone")
        }
    }
    
    func defaultSetup(efect: EffectsSatusEnum) {
        switch efect {
        case .none:
            nameTitle.text = "None"
            imageView.image = UIImage(named: "flowerNone")
        case .CIPhotoEffectMono:
            nameTitle.text = "Mono"
            imageView.image = UIImage(named: "CIPhotoEffectMono")
        case .CIPhotoEffectNoir:
            nameTitle.text = "Noir"
            imageView.image = UIImage(named: "CIPhotoEffectNoir")
        case .CIPhotoEffectProcess:
            nameTitle.text = "Process"
            imageView.image = UIImage(named: "CIPhotoEffectProcess")
        case .CIPhotoEffectTonal:
            nameTitle.text = "Tonel"
            imageView.image = UIImage(named: "CIPhotoEffectTonal")
        case .addItem:
            nameTitle.text = "Add Item"
            imageView.image = UIImage(systemName: "plus.square.on.square")
            
        }
    }
    
    func selectCell() {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.0
    }
    
    func updateCell() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.lightGray.cgColor
    }

}
