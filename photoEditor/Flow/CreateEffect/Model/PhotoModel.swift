//
//  PhotoModel.swift
//  photoEditor
//
//  Created by Alina Titarenko on 08.01.2024.
//

import Foundation
import SwiftData
import UIKit

@Model
class PhotoModel : Identifiable, Hashable {
    @Attribute(.unique) var id: String
    var name: String
    var effect: String
    var eposureSliderValue: Float
    var brillianceSliderValue: Float
    var highlightsSliderValue: Float
    var shadowaSliderValue: Float
    var contrastSliderValue: Float
    
    init(id: String, 
         name: String = "customEffect",
         effect: String = "none",
         eposureSliderValue: Float = 0.0,
         brillianceSliderValue: Float = 0.0,
         highlightsSliderValue: Float = 0.0,
         shadowaSliderValue: Float = 0.0,
         contrastSliderValue: Float = 0.0) {
        self.id = id
        self.name = name
        //self.image = image
        self.effect = effect
        self.eposureSliderValue = eposureSliderValue
        self.brillianceSliderValue = brillianceSliderValue
        self.highlightsSliderValue = highlightsSliderValue
        self.shadowaSliderValue = shadowaSliderValue
        self.contrastSliderValue = contrastSliderValue
    }
    
    static func == (lhs: PhotoModel, rhs: PhotoModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
