//
//  Interactor.swift
//  VIPER
//
//  Created by Admin on 18.10.2021.
//

//object
// protocol
// ref to presenter
// https

import Foundation
import UIKit
import CoreData


protocol GetData {
    var store: UserStore? { get set }
    var presenter: Presenter? { get set }
    func saveTobd(this: String) throws
    func getAllCharacters() throws
    func getCharacterImage() throws
}

final class UserInteractor: GetData {
    var store: UserStore?
    var presenter: Presenter?
    
    func getCharacterImage() throws {
        guard let unwrappedArr = self.presenter?.results else { return }
        if !unwrappedArr.isEmpty {
            
            for model in unwrappedArr {
                if let url = URL(string: model.image) {
                    URLSession.shared.dataTask(with: url)
                    if let data = try? Data(contentsOf: url) {
                        guard let tempImage = UIImage(data: data) else { return }
                        self.presenter?.imagesArray?.append(tempImage)
                    }
                }
            }
        }
    }
    func saveTobd(this: String) throws {
        try store?.saveAllCharacters(what: this)
        print("Succesfully saved \(this) to BD")
    }
    
    func getAllCharacters() throws {
        
        print("getting data...")
        if let url = URL(string: "https://rickandmortyapi.com/api/character") {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let data = data {
                    do {
                        let parsedJson = try JSONDecoder().decode(AllCharacters.self, from: data)
                        
                        self?.presenter?.results = parsedJson.results
                        
                        // MARK: Saving to CoreData
                        try self?.saveTobd(this: "AllCharactersProxy")
                        
                        DispatchQueue.main.async {
                            self?.presenter?.view?.updateTableView()
                            print("reloading tableView...")
                        }
                    }
                    catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}






