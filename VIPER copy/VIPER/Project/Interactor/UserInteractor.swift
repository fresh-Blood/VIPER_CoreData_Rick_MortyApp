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
    
    func getImage(name:String) -> UIImage? // с жесткого диска
    func downloadImage(forItemAtIndex: Int, arrayOfModels: [UserResults], closure: @escaping (UIImage) -> Void) // из инета
    func saveData() // на жесткий диск
    func getData(closure: @escaping ([UserResults]) -> Void) // из инета 
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
    
    func getImage(name:String) -> UIImage? { //с жесткого диска
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
            //                let id = results.map{$0.map{$0.id}}
            //                self.storeService?.saveImage(image: image, name: String(id)) // сохранение на жесткий диск
        } else {
            print("It's not the 5th of the current month to save")
        }
    }
}







