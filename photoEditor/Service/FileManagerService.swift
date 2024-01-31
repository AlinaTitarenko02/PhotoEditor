//
//  FileManagerService.swift
//  photoEditor
//
//  Created by Alina Titarenko on 21.12.2023.
//

import Foundation
import UIKit

protocol FileManagerService {
    func saveImage(filename: String, imageData: Data) throws
    func downloadImage(filename: String) throws -> Data
}

class LocalFileManagerService: FileManagerService {
    
    private let storageDirectory = "/path/to/your/directory/images/"
    private let storagePath: URL
    
    init() {
        storagePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(storageDirectory)
        
        // Create directory if it doesn't exist
        if !FileManager.default.fileExists(atPath: storagePath.path) {
            do {
                try FileManager.default.createDirectory(at: storagePath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                fatalError("Failed to create directory: \(error)")
            }
        }
    }
    
    func saveImage(filename: String, imageData: Data) throws {
        let fileURL = storagePath.appendingPathComponent(filename)
        try imageData.write(to: fileURL)
    }
    
    func downloadImage(filename: String) throws -> Data {
        let fileURL = storagePath.appendingPathComponent(filename)
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            throw FileManagerError.fileNotFound
        }
        return try Data(contentsOf: fileURL)
    }
    
    func listImageFilenames(in directory: String) throws -> [UIImage] {
        let directoryURL = storagePath.appendingPathComponent(directory)
                
        let fileURLs = try FileManager.default.contentsOfDirectory(at: directoryURL,
                                                                    includingPropertiesForKeys: nil,
                                                                    options: [.skipsHiddenFiles])
        
        let imageFileURLs = fileURLs.filter { (url) -> Bool in
            ["jpg", "jpeg", "png", "gif", "bmp"].contains(url.pathExtension.lowercased())
        }
        
        var images: [UIImage] = []
        for imageURL in imageFileURLs {
            if let imageData = try? Data(contentsOf: imageURL),
               let image = UIImage(data: imageData) {
                images.append(image)
            }
        }
        
        return images
    }
}

enum FileManagerError: Error {
    case fileNotFound
}
