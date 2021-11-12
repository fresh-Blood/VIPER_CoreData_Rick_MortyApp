//
//  Presenter.swift
//  VIPER
//
//  Created by Admin on 18.10.2021.
//

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
    var results : [UserResults]? { get set }
}

final class UserPresenter: Presenter {
    var view1: View1?
    
    var results: [UserResults]? = [] 
    
    var router: Router? = UserRouter()
    
    var interactor: GetData? {
        didSet {
            try? self.interactor?.getAllCharacters()
        }
    }
    
    var view: View? = ViewController()
    
}

