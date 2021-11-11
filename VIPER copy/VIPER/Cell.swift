import Foundation
import UIKit

class CustomCell: UITableViewCell {
    
    var personImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    var name: UILabel = {
        let nme = UILabel()
        nme.numberOfLines = 0
        nme.translatesAutoresizingMaskIntoConstraints = false
        return nme
    }()
    
    var statusImage: UIImageView = {
       let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 10
        return img
    }()
    
    var status: UILabel = {
       let sttus = UILabel()
        sttus.numberOfLines = 0
        sttus.translatesAutoresizingMaskIntoConstraints = false
        return sttus
    }()
    
    var lastKnownLocation: UILabel = {
       let text = UILabel()
        text.numberOfLines = 0
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Last known location"
        text.textColor = .systemGray
        return text
    }()
    
    var location: UILabel = {
       let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 16)
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
        personImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        personImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        personImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        personImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -250).isActive = true
        
        name.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        name.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -110).isActive = true
        name.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 200).isActive = true
        name.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        
        statusImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 50).isActive = true
        statusImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -80).isActive = true
        statusImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 200).isActive = true
        statusImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -195).isActive = true
        
        status.topAnchor.constraint(equalTo: self.topAnchor, constant: 50).isActive = true
        status.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -80).isActive = true
        status.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 230).isActive = true
        status.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -80).isActive = true
        
        lastKnownLocation.topAnchor.constraint(equalTo: self.topAnchor, constant: 80).isActive = true
        lastKnownLocation.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        lastKnownLocation.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 200).isActive = true
        lastKnownLocation.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50).isActive = true
        
        location.topAnchor.constraint(equalTo: self.topAnchor, constant: 100).isActive = true
        location.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        location.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 200).isActive = true
        location.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
