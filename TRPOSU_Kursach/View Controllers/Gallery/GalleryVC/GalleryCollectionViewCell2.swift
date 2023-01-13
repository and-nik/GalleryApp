//
//  GalleryCollectionViewCell2.swift
//  TRPOSU_Kursach
//
//  Created by And Nik on 13.01.23.
//

import Foundation
import UIKit

class GalleryCollectionViewCell2 : UICollectionViewCell
{
    var book : Bookg?
    
    static let reuseID = "GalleryCollectionViewCell2"
    
    private let containerView = UIView()
    private func containerViewConfig()
    {
        self.containerView.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(self.containerView)

        NSLayoutConstraint.activate([
            self.containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.containerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])

        self.containerView.layoutIfNeeded()

        self.containerView.layer.cornerRadius = 20

        self.containerView.backgroundColor = .secondarySystemGroupedBackground
        
        self.containerView.layer.shadowRadius = 10
        self.containerView.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.containerView.layer.shadowOpacity = 0.5
    }
    
    private let bookImageView = UIImageView()
    private func bookImageViewConfig()
    {
        self.bookImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.bookImageView)
        
        NSLayoutConstraint.activate([
            //self.bookImageView.leadingAnchor.constraint(equalTo: self.containerView),
            self.bookImageView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -20),
            self.bookImageView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 10),
            self.bookImageView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -10),
            self.bookImageView.widthAnchor.constraint(equalToConstant: 130)
        ])
        
        self.bookImageView.layoutIfNeeded()
        
        self.bookImageView.layer.cornerRadius = 10
        
        self.bookImageView.contentMode = .scaleAspectFill
        
        self.bookImageView.layer.shadowRadius = 5
        self.bookImageView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.bookImageView.layer.shadowOpacity = 0.5
        
        self.bookImageView.backgroundColor = Sources.Colors.systemColor
    }
    
    private let nameLabel = UILabel()
    private func nameLabelConfig()
    {
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.nameLabel)
        
        NSLayoutConstraint.activate([
            self.nameLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 20),
            self.nameLabel.trailingAnchor.constraint(equalTo: self.bookImageView.leadingAnchor, constant: -10),
            self.nameLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 20),
            self.nameLabel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -20),
        ])
        
        self.nameLabel.layoutIfNeeded()
        
        self.nameLabel.numberOfLines = 2
        self.nameLabel.font = .systemFont(ofSize: 25)
        self.nameLabel.textAlignment = .left
        self.nameLabel.lineBreakMode = .byWordWrapping
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.containerViewConfig()
        self.bookImageViewConfig()
        self.nameLabelConfig()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config()
    {
        self.nameLabel.text = self.book?.title
        Sources.Functions.getImage(bookId: self.book?.bookId)
        { image in
                self.bookImageView.image = image
        }
    }
}
