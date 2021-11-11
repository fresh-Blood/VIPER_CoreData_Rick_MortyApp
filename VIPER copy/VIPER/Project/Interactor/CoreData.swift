//
//  CoreData.swift
//  VIPER
//
//  Created by Admin on 09.11.2021.
//

import Foundation
import CoreData
import UIKit


protocol UserStore {
    func saveAllCharacters(what: String)
    func saveCharacter(what: String)
}

final class Store: UserStore {

    // MARK: Saving AllCharacters to Core Data
    
    func saveAllCharacters(what: String) {
        
        weak var delegate: AppDelegate?
        weak var context: NSManagedObjectContext?
        
        //1
        DispatchQueue.main.async {
            delegate = UIApplication.shared.delegate as? AppDelegate
        }
        context = delegate?.persistentContainer.viewContext
        if let unwrappedContext = context {
            _ = NSEntityDescription.insertNewObject(forEntityName: what, into: unwrappedContext)
        }
        //2
        do {
            try context?.save()
            print("Succesfully saved \(what) to CoreData")
        }
        catch {
            NSLog("Can't save to CoreData")
            return
        }
    }
    
    // MARK: Saving Character to Core Data
    
    func saveCharacter(what: String) {
        
        weak var delegate: AppDelegate?
        weak var context: NSManagedObjectContext?
        
        //1
        DispatchQueue.main.async {
            delegate = UIApplication.shared.delegate as? AppDelegate
        }
        context = delegate?.persistentContainer.viewContext
        if let unwrappedContext = context {
            _ = NSEntityDescription.insertNewObject(forEntityName: what, into: unwrappedContext)
        }
        //2
        do {
            try context?.save()
            print("Succesfully saved \(what) to CoreData")
        }
        catch {
            NSLog("Can't save to CoreData")
            return
        }
    }
}
