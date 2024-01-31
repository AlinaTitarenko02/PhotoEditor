//
//  LibaryViewModel.swift
//  photoEditor
//
//  Created by Alina Titarenko on 21.12.2023.
//

import UIKit

final class LibaryViewModel {

    private var images: [UIImage] = []
    private let fileManagerService = LocalFileManagerService()
    
}

extension LibaryViewModel {

    func loadImage(completion: @escaping (UIImage?)-> Void) {
        do {
            let imageFilenames = try fileManagerService.listImageFilenames(in: "image.jpg")
            print(imageFilenames)
            
            // You can now load each image using the filename
            for filename in imageFilenames {
                let imagePath = "/path/to/your/directory/images/\(filename)"
                if let image = UIImage(contentsOfFile: imagePath) {
                   completion(image)
                }
            }
        } catch {
            print("FileManagerService error: \(error)")
        }
    }
}
