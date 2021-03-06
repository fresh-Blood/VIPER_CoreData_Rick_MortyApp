import Foundation
import UIKit

// Object
// Entry point - getting initialVC

typealias EntryPoint = View & UIViewController

protocol Router {
    var entry: EntryPoint? { get }
    static func start() -> Router
}

final class UserRouter: Router {
    var entry: EntryPoint?
    
    static func start() -> Router {
        let router = UserRouter()
        
        let view = ViewController()
        let presenter = UserPresenter()
        var interactor: GetData = UserInteractor()
        let internetService: InternetService = UserInternetService()
        let storeService: StoreService = UserStoreService()
        
        view.presenter = presenter
        
        interactor.internetService = internetService
        interactor.storeService = storeService
        
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as EntryPoint
        return router
    }
}

