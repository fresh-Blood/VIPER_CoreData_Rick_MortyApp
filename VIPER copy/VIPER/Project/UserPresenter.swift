import Foundation
import UIKit
import CoreData

// Object
// protocol
// ref to interactor
// ref to router
// ref to view

protocol Presenter {
    var results: [UserResults]? { get set }
    var view: View? { get set }
    var image: UIImage? { get set }
    
    func getImage(name:String) -> UIImage?
    func getData()
    func downloadImage(forItemAtIndex: Int, arrayOfModels: [UserResults])
}

protocol PresenterForInteractor {
    var interactor: GetData? { get set }
}

final class UserPresenter: Presenter, PresenterForInteractor {
    
    var interactor: GetData?
    var view: View?
    var image: UIImage?
    var results: [UserResults]?
    
    func getData() {
        interactor?.getData(closure: { [self] array in
            results = array
            DispatchQueue.main.async {
                view?.updateView()
            }
        })
    }
    
    func getImage(name: String) -> UIImage? {
        interactor?.getImage(name: name)
    }
    
    func downloadImage(forItemAtIndex: Int, arrayOfModels: [UserResults]) { // 2ой способ загрузки картинок - тут для практики с замыканиями - все ок работает 
        self.interactor?.downloadImage(forItemAtIndex: forItemAtIndex, arrayOfModels: arrayOfModels, closure: { image in
            self.image = image
        })
    }
}

