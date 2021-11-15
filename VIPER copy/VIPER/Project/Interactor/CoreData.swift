import Foundation
import CoreData
import UIKit

protocol UserStore {
    func saveAllCharacters(what: String)
}

final class Store: UserStore {
    
    // MARK: Saving AllCharacters to Core Data
    internal func saveAllCharacters(what: String) {
        
        weak var delegate: AppDelegate?
        weak var context: NSManagedObjectContext?
        
        DispatchQueue.main.async {
            delegate = UIApplication.shared.delegate as? AppDelegate
        }
        context = delegate?.persistentContainer.viewContext
        if let unwrappedContext = context {
            _ = NSEntityDescription.insertNewObject(forEntityName: what, into: unwrappedContext)
        }
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
