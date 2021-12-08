import Foundation
import UIKit
import CoreData

// ViewController
// protocol
// reference presenter

protocol View {
    func updateView()
}

final class ViewController: UIViewController, View {
    
    var presenter: Presenter?
    
    var myTableView: UITableView = {
        let table = UITableView()
        table.register(CustomCell.self, forCellReuseIdentifier: "cell")
        table.alpha = 0
        return table
    }()
    
    var internetStatusLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.alpha = 0
        return lbl
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRefreshControl()
        splashShowAnimateDismiss()
        view.backgroundColor = .white
        view.addSubview(splashscreenPicture)
        view.addSubview(myTableView)
        view.addSubview(internetStatusLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setFrames()
    }
    
    private func setFrames() {
        myTableView.frame = view.bounds
        myTableView.insetsContentViewsToSafeArea = false
        splashscreenPicture.frame = view.bounds
        internetStatusLabel.frame = CGRect(x: view.bounds.minX, y: view.bounds.minY, width: view.bounds.width, height: view.bounds.height/10)
    }
    
    private let splashscreenPicture: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "Image")
        img.contentMode = .scaleAspectFill
        img.alpha = 1
        return img
    }()
    
    private func splashShowAnimateDismiss() {
        UIView.animate(withDuration: 1.0, animations: {
            self.splashscreenPicture.transform = CGAffineTransform(scaleX: 20.0, y: 20.0)
            self.splashscreenPicture.transform = .identity
        }, completion: { [self] finished in
            UIView.animate(withDuration: 0.1) { [self] in
                splashscreenPicture.alpha = 0
            }
            myTableView.reloadData()
            myTableView.alpha = 1
            let cells = myTableView.visibleCells
            let height = myTableView.bounds.height
            var delay: Double = 0
            for cell in cells {
                cell.transform = CGAffineTransform(translationX: 0, y: height)
                UIView.animate(withDuration: 1.0, delay: delay * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    cell.transform = CGAffineTransform.identity
                })
                delay += 1
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
        print("Refreshed...")
        myTableView.reloadData()
        myTableView.refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getData()
    }
    
    func updateView() {
        myTableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        let model = presenter?.results?[indexPath.row]
        
        if let unwrappedModel = model {
            cell.personImage.image = UIImage(named: "Image")
            cell.personImage.downlLoadImage(from: unwrappedModel.image)
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
        secondvc.modalTransitionStyle = .coverVertical
        secondvc.modalPresentationStyle = .popover
        self.present(secondvc, animated: true, completion: nil)
        myTableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension UIImageView {
    
    func downlLoadImage(from: String) {
        
        if let cachedImage = Cashe.imageCache.object(forKey: from as AnyObject) {
            debugPrint("Image loaded from cache")
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: from) {
            URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        guard
                            let unwrappedImage = UIImage(data: data) else { return }
                        Cashe.imageCache.setObject(unwrappedImage, forKey: from as AnyObject)
                        debugPrint("Image loaded from internet")
                        self.image = UIImage(data: data)
                    }
                }
            }).resume()
        }
    }
}

