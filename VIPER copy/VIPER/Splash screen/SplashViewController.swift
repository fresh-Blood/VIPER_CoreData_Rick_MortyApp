//
//  SplashViewController.swift
//  VIPER
//
//  Created by Admin on 13.11.2021.
//


// Когда я менял ентри поинт в роутере чтобы сначала показывался splashVC - все было ок - лончскрин с картинкой затем splashvc с дублирующей картинкой и анимацией, потом переход на ViewController но его таблица пустая - белый экран (предположительно из за того что таблица не может обновить свои ячейки в фоне?) Пока оставил просто лончскрин без анимации 

import UIKit

protocol UserSplashView {
    var presenter: Presenter? {get set}
    func animate()
}

final class SplashViewController: UIViewController, UserSplashView {
    
    var presenter: Presenter?

    let imageView: UIImageView = {
       let img = UIImageView()
        img.image = UIImage(named: "Image")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [self] in
            animate()
        })
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
    }
    
    internal func animate() {
        UIView.animate(withDuration: 0.7, animations: { [self] in
            imageView.transform = CGAffineTransform(scaleX: 7.0, y: 1.0)
            imageView.alpha = 0
        }) { done in
            if done {
                let vc = ViewController()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: .none)
            }
        }
    }
}
