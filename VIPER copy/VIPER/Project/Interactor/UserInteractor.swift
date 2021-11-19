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

    internal var imagesArray: [UIImage]?
    internal var results: [UserResults]?
    internal var internetService: InternetService?
    internal var storeService: StoreService?
    internal var presenter: Presenter?
    internal var connectionStatus: String?
    internal var connectionColor: UIColor?
    
    internal func updateData() {
        internetService?.updateData()
        results = internetService?.results
        imagesArray = internetService?.imagesArray
        connectionColor = internetService?.connectionColor
        connectionStatus = internetService?.connectionStatus
    }
    
    internal func getData() {
        internetService?.getAllCharacters()
        sleep(1)
        internetService?.getCharacterImage()
    }
    
    internal func saveTobd() {
        storeService?.saveAllCharacters()
    }
        
    internal func checkConnectionEvery10Seconds() {
        internetService?.checkConnectionEvery10Seconds()
        results = internetService?.results
        imagesArray = internetService?.imagesArray
    }
    internal func saveImage(image: UIImage, name: String) {
        storeService?.saveImage(image: image, name: name)
    }
    internal func getImage(name:String) -> UIImage? {
        storeService?.getImage(name: name)
    }
    internal func deleteImage(name:String) {
        storeService?.deleteImage(name: name)
    }
}







