import Foundation
import CoreData
import UIKit

protocol StoreService {
    func saveAllCharacters()
}

final class UserStoreService: StoreService {
    
    // MARK: Saving AllCharacters to Core Data
    internal func saveAllCharacters() {
        
        weak var delegate: AppDelegate?
        weak var context: NSManagedObjectContext?
        
        DispatchQueue.main.async {
            delegate = UIApplication.shared.delegate as? AppDelegate
        }
        context = delegate?.persistentContainer.viewContext
        if let unwrappedContext = context {
            _ = NSEntityDescription.insertNewObject(forEntityName: "AllCharactersProxy", into: unwrappedContext)
        }
        do {
            try context?.save()
            print("Successfully saved data to CoreData")
        }
        catch {
            NSLog("Can't save to CoreData")
            return
        }
    }
}
