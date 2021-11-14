//
//  ViewController.swift
//  VIPER
//
//  Created by Admin on 18.10.2021.
//
import Foundation
import UIKit
import CoreData

// ViewController
// protocol
// reference presenter

protocol View {
    var presenter: Presenter? { get set }
    func updateTableView()
    func animate()
}

final class ViewController: UIViewController, View {
    
    var presenter: Presenter?
    
    // Example for UNIT Test
    var one = 10
    var two = 30
    var result1 = Int()
    func summ() {
        result1 = one + two
    }
    //
    
    func updateTableView() {
        myTableView.reloadData()
    }
    
    let myTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CustomCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    let internetStatusLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.text = "No internet connection"
        lbl.numberOfLines = 0
        lbl.backgroundColor = .systemGreen
        lbl.alpha = 0
        return lbl
    }()
    func animate() {
            UIView.animate(withDuration: 2.0, animations: {
                self.internetStatusLabel.alpha = 1
        }) { finished in
            UIView.animate(withDuration: 2.0) {
                self.internetStatusLabel.alpha = 0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.interactor?.checkConnectionEvery10Seconds()
        view.backgroundColor = .blue
        myTableView.delegate = self
        myTableView.dataSource = self
        view.addSubview(myTableView)
        view.addSubview(internetStatusLabel)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        myTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        myTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        internetStatusLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        internetStatusLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -800).isActive = true
        internetStatusLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        internetStatusLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        let model = presenter?.results?[indexPath.row]
        if !(presenter?.imagesArray?.isEmpty)! {
            cell.personImage.image = presenter?.imagesArray?[(model?.id ?? 0) - 1]
        }
        cell.name.text = model?.name
        cell.status.text = model?.status
        if cell.status.text == "Alive" { cell.statusImage.backgroundColor = .green }
        else { cell.statusImage.backgroundColor = .red }
        cell.location.text = model?.location?.name
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondvc = SecondViewController()
        let person = presenter?.results?[indexPath.row]
        
        secondvc.id = Int(person?.id ?? 0)
        secondvc.results = presenter?.results
        secondvc.imagesArray = presenter?.imagesArray
        secondvc.isConnected = presenter?.interactor?.isConnectedToNetwork()
        
        self.present(secondvc, animated: true, completion: nil)
        myTableView.deselectRow(at: indexPath, animated: true)
    }
}






