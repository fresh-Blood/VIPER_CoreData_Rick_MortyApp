//
//  InternetServis.swift
//  VIPER
//
//  Created by Admin on 17.11.2021.
//

import Foundation
import UIKit

protocol InternetService {
    func getAllCharacters(results: @escaping ([UserResults]) -> Void)
    func downloadImage(forItemAtIndex: Int, arrayOfModels: [UserResults], closure: @escaping (UIImage) -> Void)
}

final class UserInternetService: InternetService {
    
    func getAllCharacters(results: @escaping ([UserResults]) -> Void) {
        if let url = URL(string: "https://rickandmortyapi.com/api/character") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let parsedJson = try JSONDecoder().decode(AllCharacters.self, from: data)
                        guard
                            let unwrapped = parsedJson.results else { return }
                        results(unwrapped)
                        print("Getting data...")
                    }
                    catch let error {
                        print(error)
                    }
                }
                
            }.resume()
        }
    }
    
    func downloadImage(forItemAtIndex: Int, arrayOfModels: [UserResults], closure: @escaping (UIImage) -> Void) {
        do {
            for model in arrayOfModels {
                if model.id == forItemAtIndex {
                    if let url = URL(string: model.image) {
                        URLSession.shared.dataTask(with: url)
                        if let data = try? Data(contentsOf: url) {
                            guard let tempImage = UIImage(data: data) else { return }
                            print("getting characters images from internet...")
                            closure(tempImage)
                        }
                    }
                }
            }
        }
    }
}
