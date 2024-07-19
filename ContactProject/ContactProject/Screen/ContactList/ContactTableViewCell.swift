//
//  ContactTableViewCell.swift
//  ContactProject
//
//  Created by 남지연 on 7/17/24.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    static let identifier = "cell"

    public let contactImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
   
    public lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        //label.adjustsFontForContentSizeCategory = true
        //label.minimumScaleFactor = 0.5
        //label.lineBreakMode = .byTruncatingHead - 텍스트 잘릴 때 줄임표를 사용하는거 ...
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeUI() {
        
        contentView.backgroundColor = .white
        
        [
        contactImageView,
        nameLabel,
        numberLabel
        ].forEach { contentView.addSubview($0)  }
  
        NSLayoutConstraint.activate([
            contactImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            contactImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contactImageView.widthAnchor.constraint(equalToConstant: 70),
            contactImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.leadingAnchor.constraint(equalTo: contactImageView.trailingAnchor, constant: 20),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            numberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
        ])
    }
    
    func configure(_ contact: Contact) {
        
        nameLabel.text = contact.name
        numberLabel.text = contact.number
        if let imageData = contact.imageUrl {
            contactImageView.image = UIImage(data:  imageData)
        } else {
            contactImageView.image = UIImage(systemName: "person.circle")
        }
    } 
}
