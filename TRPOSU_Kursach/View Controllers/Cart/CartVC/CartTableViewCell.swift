//
//  CartTableViewCell.swift
//  TRPOSU_Kursach
//
//  Created by And Nik on 13.01.23.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class CartTableViewCell : UITableViewCell
{
    public var delegate : CartViewControllerDelegate?
    
    public var book : Bookg?
    
    static let reuseID = "CartTableViewCell"
    
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
    
    private let numerOfBookLabel = UILabel()
    private func numerOfBookLabelConfig()
    {
        self.numerOfBookLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.numerOfBookLabel)
        
        NSLayoutConstraint.activate([
            self.numerOfBookLabel.heightAnchor.constraint(equalToConstant: 20),
            self.numerOfBookLabel.widthAnchor.constraint(equalToConstant: 20),
            self.numerOfBookLabel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -15),
            self.numerOfBookLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -20)
        ])
        
        self.numerOfBookLabel.font = .boldSystemFont(ofSize: 16)
        self.numerOfBookLabel.textColor = .label
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
    
    private let priceView = UIView()
    private func priceViewConfig()
    {
        self.priceView.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.insertSubview(self.priceView, at: 0)
        
        NSLayoutConstraint.activate([
            self.priceView.leadingAnchor.constraint(equalTo: self.priceLabel.leadingAnchor, constant: -10),
            self.priceView.trailingAnchor.constraint(equalTo: self.priceLabel.trailingAnchor, constant: 10),
            self.priceView.topAnchor.constraint(equalTo: self.priceLabel.topAnchor, constant: -5),
            self.priceView.bottomAnchor.constraint(equalTo: self.priceLabel.bottomAnchor, constant: 5),
        ])
        
        self.priceView.layoutIfNeeded()
        
        self.priceView.layer.cornerRadius = self.priceView.bounds.height/2
        
        self.priceView.backgroundColor = Sources.Colors.systemColor
    }
    
    private let priceLabel = UILabel()
    private func priceLabelConfig()
    {
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.priceLabel)
        
        NSLayoutConstraint.activate([
            self.priceLabel.heightAnchor.constraint(equalToConstant: 20),
            self.priceLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 15),
            self.priceLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -20)
        ])
        
        self.priceLabel.font = .boldSystemFont(ofSize: 16)
        self.priceLabel.textAlignment = .right
        self.priceLabel.textColor = .white
        self.priceLabel.sizeToFit()
    }
    
    private let removeButton = UIButton()
    private func removeButtonConfig()
    {
        self.removeButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.removeButton)
        
        NSLayoutConstraint.activate([
            self.removeButton.leadingAnchor.constraint(equalTo: self.bookImageView.trailingAnchor, constant: 5),
            self.removeButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -15),
            self.removeButton.widthAnchor.constraint(equalToConstant: 40),
            self.removeButton.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        self.removeButton.layoutIfNeeded()
        
        self.removeButton.backgroundColor = .systemGray4
        
        let corner = CAShapeLayer()
        corner.path = UIBezierPath(roundedRect:self.removeButton.bounds,
                                   byRoundingCorners:[.topLeft, .bottomLeft],
                                      cornerRadii: CGSize(width: self.removeButton.frame.height/4, height: self.removeButton.frame.height/4)).cgPath
        
        self.removeButton.layer.mask = corner
        
        self.removeButton.setTitle("-", for: .normal)
        self.removeButton.setTitleColor(.secondaryLabel, for: .normal)
        self.removeButton.titleLabel?.font = .systemFont(ofSize: 25)
        
        self.removeButton.addTarget(self,
                                    action: #selector(handleRemove),
                                    for: .touchUpInside)
    }
    
    @objc private func handleRemove(sender: UIButton)
    {
        UIView.animate(withDuration: 0.15, delay: 0)
        {
            sender.backgroundColor = .systemGray
        } completion:
        { _ in
            sender.backgroundColor = .systemGray4
        }
        
        var count = self.book!.count
        
        if count <= 0 {return}
        
        count -= 1
        
        let ref = Database.database(url: "https://booksgallery-3b9f2-default-rtdb.europe-west1.firebasedatabase.app").reference().child("users").child(Auth.auth().currentUser!.uid).child("cart")

        ref.child(self.book!.bookId).updateChildValues(["count" : count])
        
        self.delegate?.reloadViewControllerDelegate()
    }
    
    private let addButton = UIButton()
    private func addButtonConfig()
    {
        self.addButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.addButton)
        
        NSLayoutConstraint.activate([
            self.addButton.leadingAnchor.constraint(equalTo: self.removeButton.trailingAnchor, constant: 3),
            self.addButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -15),
            self.addButton.widthAnchor.constraint(equalToConstant: 40),
            self.addButton.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        self.addButton.layoutIfNeeded()
        
        self.addButton.backgroundColor = .systemGray4
        
        let corner = CAShapeLayer()
        corner.path = UIBezierPath(roundedRect:self.addButton.bounds,
                                   byRoundingCorners:[.topRight, .bottomRight],
                                      cornerRadii: CGSize(width: self.addButton.frame.height/4, height: self.addButton.frame.height/4)).cgPath
        
        self.addButton.layer.mask = corner
        
        self.addButton.setTitle("+", for: .normal)
        self.addButton.setTitleColor(.secondaryLabel, for: .normal)
        self.addButton.titleLabel?.font = .systemFont(ofSize: 25, weight: .light)
        
        self.addButton.addTarget(self,
                                    action: #selector(handleAdd),
                                    for: .touchUpInside)
    }
    
    @objc private func handleAdd(sender: UIButton)
    {
        UIView.animate(withDuration: 0.15, delay: 0)
        {
            sender.backgroundColor = .systemGray
        } completion:
        { _ in
            sender.backgroundColor = .systemGray4
        }
        
        var count = self.book!.count
        
        count += 1
        
        let ref = Database.database(url: "https://booksgallery-3b9f2-default-rtdb.europe-west1.firebasedatabase.app").reference().child("users").child(Auth.auth().currentUser!.uid).child("cart")

        ref.child(self.book!.bookId).updateChildValues(["count" : count])
        
        self.delegate?.reloadViewControllerDelegate()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        self.containerViewConfig()
        self.numerOfBookLabelConfig()
        
        self.bookImageViewConfig()
        self.nameLabelConfig()
        self.authorLabelConfig()
        self.priceLabelConfig()
        self.priceViewConfig()
        
        self.removeButtonConfig()
        self.addButtonConfig()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func cellConfig()
    {
        self.numerOfBookLabel.text = String(self.book!.count)
        self.nameLabel.text = self.book?.title
        self.authorLabel.text = self.book?.author
        self.priceLabel.text = Sources.Functions.getFormatedPriceInString(price: self.book!.price) + Sources.moneySymbol
        Sources.Functions.getImage(bookId: self.book?.bookId) { image in
            self.bookImageView.image = image
        }
    }
    
    public func buyCellConfig()
    {
        self.containerView.backgroundColor = .secondarySystemGroupedBackground
        self.addButton.isHidden = true
        self.removeButton.isHidden = true
    }
    
}

