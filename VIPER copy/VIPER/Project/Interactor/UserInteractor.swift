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
    var presenter: Presenter? { get set }
    var results: [UserResults]? { get set }
    var imagesArray: [UIImage]? { get set }
    var connectionStatus: String? { get set }
    var connectionColor: UIColor? { get set }
    func saveTobd()
    func getData()
    func checkConnectionEvery10Seconds()
    func updateData()
    func saveImage(image: UIImage, name: String)
    func getImage(name:String) -> UIImage?
    func deleteImage(name:String)
}

final class UserInteractor: GetData {

    var imagesArray: [UIImage]?
    var results: [UserResults]?
    var internetService: InternetService?
    var storeService: StoreService?
    var presenter: Presenter?
    var connectionStatus: String?
    var connectionColor: UIColor?
    
    func updateData() {
        internetService?.updateData()
        results = internetService?.results
        imagesArray = internetService?.imagesArray
        connectionColor = internetService?.connectionColor
        connectionStatus = internetService?.connectionStatus
    }
    
    func getData() {
        internetService?.getAllCharacters()
        sleep(1)
        internetService?.getCharacterImage()
    }
    
    func saveTobd() {
        storeService?.saveAllCharacters()
    }
        
    func checkConnectionEvery10Seconds() {
        internetService?.checkConnectionEvery10Seconds()
        results = internetService?.results
        imagesArray = internetService?.imagesArray
    }
    func saveImage(image: UIImage, name: String) {
        storeService?.saveImage(image: image, name: name)
    }
    func getImage(name:String) -> UIImage? {
        storeService?.getImage(name: name)
    }
    func deleteImage(name:String) {
        storeService?.deleteImage(name: name)
    }
}







