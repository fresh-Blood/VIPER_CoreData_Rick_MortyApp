import Foundation
import UIKit
import CoreData

// ViewController
// protocol
// reference presenter

protocol View {
    var presenter: Presenter? { get set }
    var myTableView: UITableView { get set }
    var internetStatusLabel: UILabel { get set }
}

final class ViewController: UIViewController, View {
    
    internal var presenter: Presenter?
    
    internal var myTableView: UITableView = {
        let table = UITableView()
        table.register(CustomCell.self, forCellReuseIdentifier: "cell")
        table.alpha = 0
        return table
    }()
    internal var internetStatusLabel: UILabel = {
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
        view.backgroundColor = .systemGreen
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
        }, completion: { finished in
            UIView.animate(withDuration: 0.1) { [self] in
                splashscreenPicture.alpha = 0
                myTableView.alpha = 1
                presenter?.animateTableView()
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
        presenter?.updateData()
        myTableView.refreshControl?.endRefreshing()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sleep(1)
        presenter?.saveData()
        presenter?.checkConnection()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.results?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        let model = presenter?.results?[indexPath.row]
        if !(presenter?.imagesArray?.isEmpty ?? false) {
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
        secondvc.modalTransitionStyle = .coverVertical
        secondvc.modalPresentationStyle = .popover
        self.present(secondvc, animated: true, completion: nil)
        myTableView.deselectRow(at: indexPath, animated: true)
    }
}







