//
//  CreateEffectService.swift
//  photoEditor
//
//  Created by Alina Titarenko on 08.01.2024.
//

import Foundation
import SwiftData

class CreateEffectService{
    static var shared = CreateEffectService()
    var container: ModelContainer?
    var context: ModelContext?
    
    init(){
        do {
            let scheme = Schema([
                PhotoModel.self,
            ])
            let modelConfiguration = ModelConfiguration(schema: scheme,isStoredInMemoryOnly: false)
            container = try ModelContainer(for: scheme, configurations: [modelConfiguration])
            if let container = container {
                context = ModelContext(container)
            }
        } catch {
            print(error)
        }
    }
    
    func saveEffects(effect: PhotoModel) {
        context?.insert(effect)
    }
    
    func fetchEffects(completion: @escaping([PhotoModel]?, Error?) -> Void) {
        let effect = FetchDescriptor<PhotoModel>(sortBy: [SortDescriptor<PhotoModel>(\.effect)])
        
        do {
            let data = try context?.fetch(effect)
            completion(data, nil)
        } catch {
            completion(nil, error)
        }
    }
    
    func updateEffect(oldEffect: PhotoModel, newEffect: PhotoModel) {
        // to do
    }
    
    func deleteEffects(effect: PhotoModel) {
        context?.delete(effect)
    }
    
    
}
