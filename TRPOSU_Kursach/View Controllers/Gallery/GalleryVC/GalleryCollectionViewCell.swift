//
//  GalleryCollectionViewCell.swift
//  TRPOSU_Kursach
//
//  Created by And Nik on 13.01.23.
//

import Foundation
import UIKit

class GalleryCollectionViewCell : UICollectionViewCell
{
    static let reuseID = "GalleryCollectionViewCell"
    
    public var book : Bookg?
    
    private let bookImageView = UIImageView()
    private func bookImageViewConfig()
    {
        self.bookImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.bookImageView)
        
        NSLayoutConstraint.activate([
            self.bookImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.bookImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bookImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.bookImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.bookImageView.layoutIfNeeded()
        
        self.bookImageView.layer.cornerRadius = 10
        
        self.bookImageView.contentMode = .scaleAspectFill
        
        self.bookImageView.layer.shadowRadius = 10
        self.bookImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.bookImageView.layer.shadowOpacity = 0.5
        
        self.bookImageView.backgroundColor = Sources.Colors.systemColor
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.bookImageViewConfig()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func config()
    {
        Sources.Functions.getImage(bookId: self.book?.bookId)
        { image in
                self.bookImageView.image = image
        }
    }
}
