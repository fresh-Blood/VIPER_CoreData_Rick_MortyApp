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
    
    internal var imagesArray: [UIImage]? = []
    internal var results: [UserResults]? = []
    internal var view: View? = ViewController()
    internal var view1: View1? = SecondViewController()
    internal var router: Router? = UserRouter()
    internal var interactor: GetData? {
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

