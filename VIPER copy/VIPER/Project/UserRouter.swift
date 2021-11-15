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
    internal var entry: EntryPoint?

    static func start() -> Router {
        let router = UserRouter()
        
        var view: View = ViewController()
        var presenter: Presenter = UserPresenter()
        var interactor: GetData = UserInteractor()
        
        view.presenter = presenter
        interactor.presenter = presenter

        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as? EntryPoint
        return router
    }
}

