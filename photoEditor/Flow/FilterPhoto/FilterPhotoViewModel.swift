//
//  FilterPhotoViewModel.swift
//  photoEditor
//
//  Created by Alina Titarenko on 29.12.2023.
//

import Foundation
import UIKit

final class FilterPhotoViewModel {

    private var images: [UIImage] = []
    private let fileManagerService = LocalFileManagerService()
    let fillterManeger = FillterManager()
    let effectService = CreateEffectService.shared
    var customEffects = [PhotoModel]()
    
    func applyFilter(efect: EffectsSatusEnum, image: UIImage) -> UIImage? {
        return fillterManeger.applyFilter(efect: efect, image: image)
    }
    
    func adjustImage(image: UIImage, adjustValue: String, sliderValue: Float) -> UIImage? {
        fillterManeger.adjustImage(image: image, adjustValue: adjustValue, sliderValue: sliderValue)
    }
    
    func fetchData(completion: @escaping([PhotoModel]) -> Void) {
        effectService.fetchEffects { [weak self] data, error in
            if let error {
                print(error)
            }
            
            if let data {
                self?.customEffects = data
                completion(data)
            }
        }
    }
    
    func deleteCustomEffect(indexPath: IndexPath) {
        if !customEffects.isEmpty {
            effectService.deleteEffects(effect: customEffects[indexPath.row])
        }
    }
    
    func addCustomEffects(image: UIImage, indexPath: IndexPath) -> UIImage? {
        if !customEffects.isEmpty {
            let effect = customEffects[indexPath.row]
            let image = fillterManeger.addCustomEffects(image: image, photoModel: effect)
            return image
        }
        return nil
    }
    
}

extension FilterPhotoViewModel {

    func saveImage(fileName: String) {
        if let imageData = UIImage(named: "image.jpg")?.jpegData(compressionQuality: 1.0) {
            try? fileManagerService.saveImage(filename: "image.jpg", imageData: imageData)
        }
    }
}
