import Foundation
import UIKit
import CoreData

final class AllCharactersProxy: NSManagedObject {
    @NSManaged var info: Info?
    @NSManaged var results: [Results]?
    
    var reborn: AllCharacters {
        get {
            return AllCharacters(info: self.info, results: self.results)
        }
        set {
            self.info = newValue.info
            self.results = newValue.results
        }
    }
}

