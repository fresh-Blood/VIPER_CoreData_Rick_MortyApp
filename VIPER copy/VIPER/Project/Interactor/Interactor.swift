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
    
    func saveTobd(this: String)
    func getAllCharacters()
}

final class UserInteractor: GetData {
    
    func saveTobd(this: String) {
        store?.saveAllCharacters(what: this)
        print("Succesfully saved \(this) to BD")
    }
    
    var store: UserStore?

    var presenter: Presenter?
    
    func getAllCharacters() {
        
        print("getting data...")
        if let url = URL(string: "https://rickandmortyapi.com/api/character") {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let data = data {
                    do {
                        let parsedJson = try JSONDecoder().decode(AllCharacters.self, from: data)
                        
                        self?.presenter?.results = parsedJson.results
                        
                        // MARK: Saving to CoreData
                        self?.saveTobd(this: "AllCharactersProxy")
                        
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






