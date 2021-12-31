import Foundation
import UIKit
import CoreData

// object
// protocol
// ref to presenter
// https

protocol GetData {
    var storeService: StoreService? { get set }
    var internetService: InternetService? { get set }
    
    func getImage(name:String) -> UIImage?
    func downloadImage(forItemAtIndex: Int, arrayOfModels: [UserResults], closure: @escaping (UIImage) -> Void)
    func saveData()
    func getData(closure: @escaping ([UserResults]) -> Void)
}

final class UserInteractor: GetData {
    
    var internetService: InternetService?
    var storeService: StoreService?
    
    func getData(closure: @escaping ([UserResults]) -> Void ) {
        internetService?.getAllCharacters(results: { array in
            closure(array)
            self.saveData()
        })
    }
    
    func getImage(name:String) -> UIImage? {
        storeService?.getImage(name: name)
    }
    
    func downloadImage(forItemAtIndex: Int, arrayOfModels: [UserResults], closure: @escaping (UIImage) -> Void) {
        internetService?.downloadImage(forItemAtIndex: forItemAtIndex, arrayOfModels: arrayOfModels, closure: { image in
            closure(image)
        })
    }
    func saveData() {
        let resultToCheck = String(Date()
                                    .description[Date()
                                                    .description
                                                    .index(Date()
                                                            .description
                                                            .startIndex,offsetBy: 8)]) +
        String(Date()
                .description[Date()
                                .description
                                .index(Date()
                                        .description
                                        .startIndex, offsetBy: 9)])
        let dateToSave = "05"
        if dateToSave == resultToCheck {
            storeService?.saveAllCharacters()
        } else {
            print("It's not the 5th of the current month to save")
        }
    }
}







