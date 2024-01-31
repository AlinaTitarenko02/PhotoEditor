//
//  FillterManager.swift
//  photoEditor
//
//  Created by Alina Titarenko on 08.01.2024.
//

import Foundation
import UIKit

class FillterManager {
    let efects = [EffectsSatusEnum.none, EffectsSatusEnum.CIPhotoEffectMono, EffectsSatusEnum.CIPhotoEffectNoir, EffectsSatusEnum.CIPhotoEffectProcess, EffectsSatusEnum.CIPhotoEffectTonal, EffectsSatusEnum.addItem]
    let forCustomEfects = [EffectsSatusEnum.none, EffectsSatusEnum.CIPhotoEffectMono, EffectsSatusEnum.CIPhotoEffectNoir, EffectsSatusEnum.CIPhotoEffectProcess]
    
    func applyFilter(efect: EffectsSatusEnum, image: UIImage) -> UIImage? {
        let inputImage = CIImage(image: image)!
        let context = CIContext()
        var filter = CIFilter(name: "CIPhotoEffectMono")!
        switch efect {
        case .CIPhotoEffectMono:
            filter = CIFilter(name: "CIPhotoEffectMono")!
        case .none:
            return image
        case .CIPhotoEffectNoir:
            filter = CIFilter(name: "CIPhotoEffectNoir")!
        case .CIPhotoEffectProcess:
            filter = CIFilter(name: "CIPhotoEffectProcess")!
        case .CIPhotoEffectTonal:
            filter = CIFilter(name: "CIPhotoEffectTonal")!
        case .addItem:
            break
        }
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        let outputImage = filter.outputImage!
        let cgImage = context.createCGImage(outputImage, from: outputImage.extent)!

        
        return UIImage(cgImage: cgImage)
    }
    
    func adjustImage(image: UIImage, adjustValue: String, sliderValue: Float) -> UIImage? {
        let context = CIContext(options: nil)
        let ciImage = CIImage(image: image)
        
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(sliderValue, forKey: adjustValue)
        
        if let outputImage = filter?.outputImage,
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let adjustedImage = UIImage(cgImage: cgImage)
            return adjustedImage
        }
        return nil
    }
    
    func addCustomEffects(image: UIImage, photoModel: PhotoModel) -> UIImage {
        var image = applyFilter(efect: EffectsSatusEnum(rawValue: photoModel.effect) ?? .CIPhotoEffectMono, image: image)
        image = adjustImage(image: image!, adjustValue: kCIInputBrightnessKey, sliderValue: photoModel.brillianceSliderValue)
        image = adjustImage(image: image!, adjustValue: kCIInputSaturationKey, sliderValue: photoModel.eposureSliderValue)
        image = adjustImage(image: image!, adjustValue: kCIInputSaturationKey, sliderValue: photoModel.shadowaSliderValue)
        image = adjustImage(image: image!, adjustValue: kCIInputContrastKey, sliderValue: photoModel.contrastSliderValue)
        
        
        return image!
    }
    
    
    
}
