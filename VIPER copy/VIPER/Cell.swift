import Foundation
import UIKit


final class CustomCell: UITableViewCell {
    
    var personImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    var name: UILabel = {
        let nme = UILabel()
        nme.font = .systemFont(ofSize: 20, weight: .medium)
        nme.numberOfLines = 0
        nme.lineBreakMode = .byWordWrapping
        return nme
    }()
    
    var statusImage: UIImageView = {
       let img = UIImageView()
        return img
    }()
    
    var status: UILabel = {
       let sttus = UILabel()
        sttus.numberOfLines = 0
        return sttus
    }()
    
    var lastKnownLocation: UILabel = {
       let text = UILabel()
        text.numberOfLines = 0
        text.text = "Last known location:"
        text.textColor = .systemGray
        return text
    }()
    
    var location: UILabel = {
       let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 16)
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(personImage)
        self.contentView.addSubview(name)
        self.contentView.addSubview(statusImage)
        self.contentView.addSubview(status)
        self.contentView.addSubview(lastKnownLocation)
        self.contentView.addSubview(location)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setFrames() {
        let inset: CGFloat = 10
        let size = CGSize(width: self.bounds.height, height: self.bounds.height)
        let point = CGPoint(x: self.bounds.minX, y: self.bounds.minY)
        let cellWidth = self.bounds.width
        let cellHeight = self.bounds.height
        let point1 = CGPoint(x: personImage.frame.width + inset, y: personImage.frame.height/3)
        let size1 = CGSize(width: inset*1.5, height: inset*1.5)
        
        self.contentView.layer.borderWidth = 10
        self.contentView.layer.borderColor = UIColor.white.cgColor
        self.contentView.layer.masksToBounds = true
        
        personImage.frame = CGRect(origin: point, size: size)
        name.frame = CGRect(x: personImage.frame.width + inset, y: personImage.frame.height/15, width: cellWidth - personImage.frame.width - inset, height: personImage.frame.height/4)
        statusImage.frame = CGRect(origin: point1, size: size1)
        statusImage.layer.cornerRadius = statusImage.frame.height/2
        status.frame = CGRect(x: statusImage.frame.maxX + inset, y: statusImage.frame.minY, width: cellWidth/3, height: statusImage.frame.height)
        lastKnownLocation.frame = CGRect(x: statusImage.frame.minX, y: cellHeight/2 + inset, width: cellWidth/2, height: statusImage.frame.height)
        location.frame = CGRect(x: statusImage.frame.minX, y: cellHeight/2 + lastKnownLocation.bounds.height + inset, width: cellWidth - inset, height: cellHeight/4)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setFrames()
    }
}
