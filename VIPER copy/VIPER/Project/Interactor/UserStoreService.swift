import Foundation
import CoreData
import UIKit

protocol StoreService {
    func saveAllCharacters()
    func saveImage(image: UIImage, name: String)
    func getImage(name:String) -> UIImage?
    func deleteImage(name:String)
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
    // MARK: File manager work:
    internal func saveImage(image: UIImage, name: String) {
        guard let data = image.jpegData(compressionQuality: 1.0),
              let path = getPathForTheImage(name: name) else {
                  print("Errors in getting images data")
                  return
              }
        
        do {
            try data.write(to: path)
            print("Successfully saved images to FileManager")
        } catch let error {
            print("Error in saving: \(error)")
        }
    }
    
    internal func getImage(name:String) -> UIImage? {
        guard
            let path = getPathForTheImage(name: name)?.path,
            FileManager.default.fileExists(atPath: path) else {
                print("Error getting path")
                return nil
            }
        print("Success in getting image from FileManager")
        return UIImage(contentsOfFile: path)
    }
    
    internal func deleteImage(name:String) {
        guard
            let path = getPathForTheImage(name: name),
            FileManager.default.fileExists(atPath: path.path) else {
                print("Error getting path")
                return
            }
        do {
            try FileManager.default.removeItem(at: path)
            print("Successfully deleted from FileManager")
        }
        catch let error {
            print("Error deleting image. \(error)")
        }
    }
    
    private func getPathForTheImage(name:String) -> URL? {
        guard
            let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent("\(name).jpg") else {
                    print("Error in getting path")
                    return nil
                }
        return path
    }
}
