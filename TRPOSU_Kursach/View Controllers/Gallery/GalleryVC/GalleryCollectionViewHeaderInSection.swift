//
//  GalleryCollectionViewHeaderInSection.swift
//  TRPOSU_Kursach
//
//  Created by And Nik on 13.01.23.
//

import Foundation
import UIKit

class GalleryCollectionViewHeaderInSection : UICollectionReusableView
{
    static let reuseID = "GalleryCollectionViewHeaderInSection"
    
    private let titleHeaderLabel = UILabel()
    private func titleHeaderLabelConfig()
    {
        self.titleHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.titleHeaderLabel)
        
        NSLayoutConstraint.activate([
            self.titleHeaderLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.titleHeaderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.titleHeaderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20),
        ])
        
        self.titleHeaderLabel.font = .systemFont(ofSize: 25)
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.titleHeaderLabelConfig()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func config(title: String)
    {
        self.titleHeaderLabel.text = title
    }
}
