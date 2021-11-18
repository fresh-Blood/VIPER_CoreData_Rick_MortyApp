import UIKit
import CoreData

protocol View1 {
    var results : [UserResults]? { get set }
    var imagesArray: [UIImage]? { get set }
    var id: Int? { get set }
    var filteredModel: UserResults? { get set }
}

final class SecondViewController: UIViewController, View1 {
    internal var results: [UserResults]?
    internal var filteredModel: UserResults?
    internal var id: Int?
    internal var imagesArray: [UIImage]?
    
    private func getDataFromBD() {
        let filteredArray = self.results?.filter{
            var model: UserResults?
            if $0.id == self.id { model = $0 }
            return model != nil
        }
        guard let unwrapped = filteredArray else { return }
        for model in unwrapped {
            filteredModel = model
        }
        
        if !imagesArray!.isEmpty {
            guard let unwrappedId = self.id else { return }
            image.image = imagesArray?[unwrappedId-1]
        }
        name.text = filteredModel?.name
        liveStatus.text = filteredModel?.status
        if liveStatus.text == "Alive" { liveStatusImage.backgroundColor = .green }
        else { liveStatusImage.backgroundColor = .red }
        gender.text = filteredModel?.gender
        lastKnownLocation.text = filteredModel?.location?.name
        firstSeenIn.text = filteredModel?.origin?.name
        
    }
    private var image: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        return img
    }()
    private let name: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        return lbl
    }()
    private let liveStatusPanel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Live status:"
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 15)
        return lbl
    }()
    private let liveStatusImage: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .systemGray
        return img
    }()
    private let liveStatus: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
        return lbl
    }()
    private let genderPanel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 15)
        lbl.text = "Species and gender:"
        return lbl
    }()
    private var gender: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
        return lbl
    }()
    private let lastKnownLocationPanel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 15)
        lbl.text = "Last known location:"
        return lbl
    }()
    private let lastKnownLocation: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
        return lbl
    }()
    private let firstSeenInPanel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .systemGray
        lbl.font = .systemFont(ofSize: 15)
        lbl.text = "First seen in:"
        return lbl
    }()
    
    private let firstSeenIn: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(loadingLabel)
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
        let inset: CGFloat = 800
        loadingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: inset).isActive = true
        loadingLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        loadingLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        loadingLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
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
    private let loadingLabel: UILabel = {
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
    private func animateLoading() {
        UIView.animate(withDuration: 0.1, animations: {
            self.loadingLabel.alpha = 1
        }) { finished in
            UIView.animate(withDuration: 1.5) {
                self.loadingLabel.alpha = 0
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateLoading()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getDataFromBD()
    }
}






