//
//  CreateEffectViewModel.swift
//  photoEditor
//
//  Created by Alina Titarenko on 08.01.2024.
//

import Foundation
import UIKit
import SwiftData

class CreateEffectViewModel {

    let fillterManeger = FillterManager()
    let effectService = CreateEffectService.shared
    var effects = [PhotoModel]()
    
    func applyFilter(efect: EffectsSatusEnum, image: UIImage) -> UIImage? {
        return fillterManeger.applyFilter(efect: efect, image: image)
    }
    
    func adjustImage(image: UIImage, adjustValue: String, sliderValue: Float) -> UIImage? {
        return fillterManeger.adjustImage(image: image, adjustValue: adjustValue, sliderValue: sliderValue)
    }
    
    func saveCustomEffect(effect: PhotoModel) {
        effectService.saveEffects(effect: effect)
    }
    
}
