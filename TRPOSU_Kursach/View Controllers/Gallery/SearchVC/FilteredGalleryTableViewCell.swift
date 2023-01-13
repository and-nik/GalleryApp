//
//  FilteredGalleryTableViewCell.swift
//  TRPOSU_Kursach
//
//  Created by And Nik on 13.01.23.
//

import Foundation
import UIKit

class FilteredGalleryTableViewCell : UITableViewCell
{
    public var book : Bookg?
    
    static let reuseID = "GilteredGalleryTableViewCell"
    
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

        self.containerView.backgroundColor = .systemBackground
    }
    
    private let bookImageView = UIImageView()
    private func bookImageViewConfig()
    {
        self.bookImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.bookImageView)
        
        NSLayoutConstraint.activate([
            self.bookImageView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 20),
            self.bookImageView.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
            self.bookImageView.heightAnchor.constraint(equalToConstant: 100),
            self.bookImageView.widthAnchor.constraint(equalToConstant: 70),
        ])
        
        self.bookImageView.contentMode = .scaleAspectFit
        
        self.bookImageView.layer.shadowRadius = 5
        self.bookImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.bookImageView.layer.shadowOpacity = 0.5
    }
    
    private let nameLabel = UILabel()
    private func nameLabelConfig()
    {
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.nameLabel)
        
        NSLayoutConstraint.activate([
            self.nameLabel.leadingAnchor.constraint(equalTo: self.bookImageView.trailingAnchor, constant: 5),
            self.nameLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 10),
            self.nameLabel.heightAnchor.constraint(equalToConstant: 40),
            self.nameLabel.widthAnchor.constraint(equalToConstant: 160)
        ])
        
        self.nameLabel.layoutIfNeeded()
        
        self.nameLabel.numberOfLines = 2
        self.nameLabel.font = .boldSystemFont(ofSize: 16)
        self.nameLabel.textAlignment = .left
        self.nameLabel.lineBreakMode = .byWordWrapping
    }
    
    private let authorLabel = UILabel()
    private func authorLabelConfig()
    {
        self.authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.authorLabel)
        
        NSLayoutConstraint.activate([
            self.authorLabel.leadingAnchor.constraint(equalTo: self.bookImageView.trailingAnchor, constant: 5),
            self.authorLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -20),
            self.authorLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor),
            self.authorLabel.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        self.authorLabel.font = .systemFont(ofSize: 12)
        self.authorLabel.textColor = .secondaryLabel
        self.authorLabel.textAlignment = .left
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        self.containerViewConfig()
        
        self.bookImageViewConfig()
        self.nameLabelConfig()
        self.authorLabelConfig()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func cellConfig()
    {
        self.nameLabel.text = self.book?.title
        self.authorLabel.text = self.book?.author
        Sources.Functions.getImage(bookId: self.book?.bookId) { image in
            self.bookImageView.image = image
        }
    }
}

