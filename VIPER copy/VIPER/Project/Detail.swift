//
//  SecondViewController.swift
//  VIPER
//
//  Created by Admin on 28.10.2021.
//

import UIKit
import CoreData


protocol View1 {
    var presenter: Presenter? { get set }
    var person: UserCharacter? { get set }
    var id: Int { get set }
}

final class SecondViewController: UIViewController, View1 {
    
    var presenter: Presenter?
    var person: UserCharacter?
    
    var id: Int = 0 {
        didSet {
            
            if let url = URL(string: "https://rickandmortyapi.com/api/character/\(self.id)") {
                URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    if let data = data {
                        do {
                            let parsedJson = try JSONDecoder().decode(Character.self, from: data)
                            self?.person = parsedJson
                            
                            // MARK: Saving to CoreData
                            self?.presenter?.interactor?.saveTobd(this: "CharacterProxy")
                            
                            if let url = URL(string: self?.person?.image ?? "error") {
                                URLSession.shared.dataTask(with: url)
                                if let data = try? Data(contentsOf: url) {
                                    DispatchQueue.main.async {
                                        self?.image.image = UIImage(data: data)!
                                        self?.name.text = self?.person?.name
                                        if self?.person?.status == "Dead" {
                                            self?.liveStatusImage.backgroundColor = .red
                                            self?.liveStatus.text = "Dead"
                                        }
                                        if self?.person?.status == "Alive" {
                                            self?.liveStatusImage.backgroundColor = .green
                                            self?.liveStatus.text = "Alive"
                                        }
                                        self?.gender.text = self?.person?.gender
                                        self?.lastKnownLocation.text = self?.person?.location?.name
                                        self?.firstSeenIn.text = self?.person?.episode?.first
                                    }
                                }
                            }
                        }
                        catch {
                            print("No internet connection")
                        }
                    }
                }.resume()
            }
            
        }
    }
    
    var image: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let name: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        return lbl
    }()
    
    let liveStatusPanel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Live status:"
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 15)
        return lbl
    }()
    
    let liveStatusImage: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .systemGray
        return img
    }()
    
    let liveStatus: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
        return lbl
    }()
    
    let genderPanel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 15)
        lbl.text = "Species and gender:"
        return lbl
    }()
    
    var gender: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
        return lbl
    }()
    
    let lastKnownLocationPanel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 15)
        lbl.text = "Last known location:"
        return lbl
    }()
    
    let lastKnownLocation: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
        return lbl
    }()
    
    let firstSeenInPanel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 15)
        lbl.text = "First seen in:"
        return lbl
    }()
    
    let firstSeenIn: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(image)
        view.addSubview(name)
        view.addSubview(liveStatusPanel)
        view.addSubview(liveStatusImage)
        view.addSubview(liveStatus)
        view.addSubview(genderPanel)
        view.addSubview(gender)
        view.addSubview(lastKnownLocationPanel)
        view.addSubview(lastKnownLocation)
        view.addSubview(firstSeenInPanel)
        view.addSubview(firstSeenIn)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        image.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height/4)
        name.frame = CGRect(x: 20, y: view.bounds.height/4 + 120, width: view.bounds.width, height: 40)
        liveStatusPanel.frame = CGRect(x: 20, y: view.bounds.height/4 + 170, width: view.bounds.width, height: 20)
        liveStatusImage.frame = CGRect(x: 20, y: view.bounds.height/4 + 200, width: 20, height: 20)
        liveStatusImage.layer.cornerRadius = liveStatusImage.frame.height/2
        liveStatus.frame = CGRect(x: 60, y: view.bounds.height/4 + 200, width: view.bounds.width, height: 20)
        genderPanel.frame = CGRect(x: 20, y: view.bounds.height/4 + 250, width: view.bounds.width, height: 20)
        gender.frame = CGRect(x: 20, y: view.bounds.height/4 + 280, width: view.bounds.width, height: 20)
        lastKnownLocationPanel.frame = CGRect(x: 20, y: view.bounds.height/4 + 330, width: view.bounds.width, height: 20)
        lastKnownLocation.frame = CGRect(x: 20, y: view.bounds.height/4 + 360, width: view.bounds.width, height: 20)
        firstSeenInPanel.frame = CGRect(x: 20, y: view.bounds.height/4 + 410, width: view.bounds.width, height: 20)
        firstSeenIn.frame = CGRect(x: 20, y: view.bounds.height/4 + 440, width: view.bounds.width, height: 20)
    }
}


