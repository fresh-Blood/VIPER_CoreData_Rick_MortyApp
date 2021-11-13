//
//  SplashViewController.swift
//  VIPER
//
//  Created by Admin on 13.11.2021.
//

import UIKit

protocol UserSplashView {
    var presenter: Presenter? {get set}
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
    
    private func animate() {
        UIView.animate(withDuration: 0.7, animations: { [self] in
            imageView.transform = CGAffineTransform(scaleX: 7.0, y: 1.0)
            imageView.alpha = 0
        }) { done in
            if done {
                let vc = ViewController()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: .none)
                print(
                    "Персонажей загружено - \(self.presenter?.results?.count)",
                    "Картинок прогружено - \(self.presenter?.imagesArray?.count)"
                )
            }
        }
    }
    
}
