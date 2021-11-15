import Foundation
import UIKit
import CoreData

// Object
// protocol
// ref to interactor
// ref to router
// ref to view

protocol Presenter {
    var router: Router? { get set }
    var interactor: GetData? { get set }
    var view: View? { get set }
    var view1: View1? { get set }
    var results: [UserResults]? { get set }
    var imagesArray: [UIImage]? { get set }
}

final class UserPresenter: Presenter {
    
    var imagesArray: [UIImage]? = []
    var results: [UserResults]? = []
    var view: View? = ViewController()
    var view1: View1? = SecondViewController()
    var router: Router? = UserRouter()
    var interactor: GetData? {
        didSet {
            DispatchQueue.global(qos: .userInteractive).sync {
                self.interactor?.getAllCharacters()
                sleep(1)
                self.interactor?.getCharacterImage()
            }
                self.interactor?.checkConnectionEvery10Seconds()
        }
    }
}

