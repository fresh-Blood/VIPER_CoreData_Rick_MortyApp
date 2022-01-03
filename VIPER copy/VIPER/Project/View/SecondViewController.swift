import UIKit
import CoreData

protocol View1 {
    var results : [UserResults]? { get set }
    var id: Int? { get set }
    var filteredModel: UserResults? { get set }
}

final class SecondViewController: UIViewController, View1 {
    var results: [UserResults]?
    var filteredModel: UserResults?
    var id: Int?
    
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
        
        image.downlLoadImage(from: filteredModel?.image ?? "Error")
        name.text = filteredModel?.name
        liveStatus.text = filteredModel?.status
        if liveStatus.text == "Alive" { liveStatusImage.backgroundColor = .green }
        else { liveStatusImage.backgroundColor = .red }
        gender.text = filteredModel?.gender
        lastKnownLocation.text = filteredModel?.location?.name
        firstSeenIn.text = filteredModel?.origin?.name
    }
    
    var image: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private let name: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 27, weight: .heavy)
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
    
    private let loadingLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
        lbl.textAlignment = .center
        lbl.text = "Loading..."
        lbl.numberOfLines = 0
        lbl.backgroundColor = .systemGreen
        lbl.alpha = 0
        return lbl
    }()
    
    let myScrollView: UIScrollView = {
       let scrl = UIScrollView()
        scrl.isScrollEnabled = true
        return scrl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        myScrollView.addSubview(loadingLabel)
        myScrollView.addSubview(image)
        myScrollView.addSubview(name)
        myScrollView.addSubview(liveStatusPanel)
        myScrollView.addSubview(liveStatusImage)
        myScrollView.addSubview(liveStatus)
        myScrollView.addSubview(genderPanel)
        myScrollView.addSubview(gender)
        myScrollView.addSubview(lastKnownLocationPanel)
        myScrollView.addSubview(lastKnownLocation)
        myScrollView.addSubview(firstSeenInPanel)
        myScrollView.addSubview(firstSeenIn)
        view.addSubview(myScrollView)
        self.title = "Details"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setFrames()
    }
    
    private func setFrames() {
        let inset: CGFloat = 20
        let width = view.bounds.width - view.safeAreaInsets.left - view.safeAreaInsets.right
        let height = view.bounds.height
        let minX = view.bounds.minX + view.safeAreaInsets.left
        let minY = view.bounds.minY
        
        myScrollView.frame = CGRect(x: minX,
                                    y: minY,
                                    width: width,
                                    height: height)
        myScrollView.contentSize = CGSize(width: width, height: height+inset*2)
        
        image.frame = CGRect(x: minX,
                             y: minY,
                             width: width,
                             height: height/2)
        name.frame = CGRect(x: inset,
                            y: image.bounds.height + inset*2,
                            width: height,
                            height: inset * 2)
        liveStatusPanel.frame = CGRect(x: inset, y: image.bounds.height + inset*4, width: width, height: inset)
        liveStatusImage.frame = CGRect(x: inset, y: image.bounds.height + inset*5, width: inset, height: inset)
        liveStatusImage.layer.cornerRadius = liveStatusImage.frame.height/2
        liveStatus.frame = CGRect(x: liveStatusImage.bounds.maxX + inset*2, y: image.bounds.height + inset*5, width: width, height: inset)
        genderPanel.frame = CGRect(x: inset, y: image.bounds.height + inset*7, width: width, height: inset)
        gender.frame = CGRect(x: inset, y: image.bounds.height + inset*8, width: width, height: inset)
        lastKnownLocationPanel.frame = CGRect(x: inset, y: image.bounds.height + inset*10, width: width, height: inset)
        lastKnownLocation.frame = CGRect(x: inset, y: image.bounds.height + inset*11, width: width, height: inset)
        firstSeenInPanel.frame = CGRect(x: inset, y: image.bounds.height + inset*13, width: width, height: inset)
        firstSeenIn.frame = CGRect(x: inset, y: image.bounds.height + inset*14, width: width, height: inset)
        loadingLabel.frame = CGRect(x: minX, y: height - inset*3, width: width, height: inset*3)
    }
    
    private func animateLoading() {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.loadingLabel.alpha = 1
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






