import Foundation
import UIKit
import CoreData

// ViewController
// protocol
// reference presenter

protocol View {
    var presenter: Presenter? { get set }
    func animateConnection(text: String, color: UIColor)
    func updateTableView()
}

final class ViewController: UIViewController, View {
    var presenter: Presenter?
    
    // Example for UNIT Test
    var one = 10
    var two = 30
    var result1 = Int()
    private func summ() {
        result1 = one + two
    }
    //

    internal func updateTableView() {
        myTableView.reloadData()
    }
    let myTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CustomCell.self, forCellReuseIdentifier: "cell")
        table.alpha = 0
        return table
    }()
    let internetStatusLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.alpha = 0
        return lbl
    }()
    let loadingLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.text = "Loading..."
        lbl.numberOfLines = 0
        lbl.backgroundColor = .systemGreen
        lbl.alpha = 0
        return lbl
    }()
    internal func animateConnection(text: String, color: UIColor) {
        self.internetStatusLabel.text = text
        self.internetStatusLabel.backgroundColor = color
        UIView.animate(withDuration: 0.5, animations: {
            self.internetStatusLabel.alpha = 1
        }) { finished in
            DispatchQueue.main.asyncAfter(deadline: .now()+2.0, execute: {
                UIView.animate(withDuration: 0.5) {
                    self.internetStatusLabel.alpha = 0
                }
            })
        }
    }
    private func animateLoading() {
        UIView.animate(withDuration: 0.5, animations: {
            self.loadingLabel.alpha = 1
        }) { finished in
            DispatchQueue.main.asyncAfter(deadline: .now()+2.0, execute: {
                UIView.animate(withDuration: 0.1) {
                    self.loadingLabel.alpha = 0
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRefreshControl()
        splashShowAnimateDismiss()
        view.backgroundColor = .systemGreen
        myTableView.delegate = self
        myTableView.dataSource = self
        view.addSubview(splashscreenPicture)
        view.addSubview(myTableView)
        view.addSubview(internetStatusLabel)
        view.addSubview(loadingLabel)
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
        loadingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 800).isActive = true
        loadingLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        loadingLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        loadingLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        splashscreenPicture.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        splashscreenPicture.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        splashscreenPicture.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        splashscreenPicture.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
    }
    
    let splashscreenPicture: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "Image")
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.alpha = 1
        return img
    }()
    private func splashShowAnimateDismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.splashscreenPicture.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)
        }, completion: { finished in
            UIView.animate(withDuration: 0.1) {
                self.splashscreenPicture.alpha = 0
                self.myTableView.alpha = 1
            }
        })
    }
    private func configureRefreshControl () {
        myTableView.refreshControl = UIRefreshControl()
        myTableView.refreshControl?.addTarget(self, action:
                                                #selector(handleRefreshControl),
                                              for: .valueChanged)
    }
    @objc private func handleRefreshControl() {
        sleepTemp()
        DispatchQueue.main.async {
            self.myTableView.refreshControl?.endRefreshing()
        }
    }
    private func sleepTemp() {
        DispatchQueue.global(qos: .userInteractive).async {
            print("Старт обновления таблицы за 3 сек")
            DispatchQueue.main.async {
                self.updateTableView()
            }
            sleep(3)
            print("Таблица обновлена")
        }
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
        animateLoading()
        let secondvc = SecondViewController()
        let person = presenter?.results?[indexPath.row]
        secondvc.id = Int(person?.id ?? 0)
        secondvc.results = presenter?.results
        secondvc.imagesArray = presenter?.imagesArray
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.present(secondvc, animated: true, completion: nil)
        })
        myTableView.deselectRow(at: indexPath, animated: true)
    }
}







