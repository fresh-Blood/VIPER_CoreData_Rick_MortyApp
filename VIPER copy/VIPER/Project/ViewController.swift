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
}

final class ViewController: UIViewController, View {
    
    var presenter: Presenter?
    
    func updateTableView() {
        myTableView.reloadData()
    }
    
    let myTableView: UITableView = {
        let table = UITableView()
        table.register(CustomCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        myTableView.delegate = self
        myTableView.dataSource = self
        view.addSubview(myTableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myTableView.frame = view.bounds
    }
    let secondvc = SecondViewController()
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        let model = presenter?.results?[indexPath.row]
        cell.name.text = model?.name
        if let url = URL(string: model?.image ?? "") {
            URLSession.shared.dataTask(with: url)
            if let data = try? Data(contentsOf: url) {
                cell.personImage.image = UIImage(data: data)
            }
        }
        if model?.status == "Dead" {
            cell.statusImage.backgroundColor = .red
            cell.status.text = "Dead"
        }
        if model?.status == "Alive" {
            cell.statusImage.backgroundColor = .green
            cell.status.text = "Alive"
        }
        cell.location.text = model?.location?.name
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = presenter?.results?[indexPath.row]
        self.secondvc.id = Int(person?.id ?? 0)
        self.present(secondvc, animated: true, completion: nil)
        myTableView.deselectRow(at: indexPath, animated: true)
    }
}






