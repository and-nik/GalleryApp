//
//  BookVC + ext.swift
//  TRPOSU_Kursach
//
//  Created by And Nik on 12.01.23.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

protocol BookViewControllerDelegate
{
    func presentAlert(VC: UIViewController)
}

extension BookViewController : BookViewControllerDelegate
{
    func presentAlert(VC: UIViewController)
    {
        self.present(VC, animated: true)
    }
}

//MARK: - Book view controller

class BookViewController : UIViewController
{
    public var delegate : GalleryViewControllerDelegate?
    
    public var booksArray = [Bookg]()
    
    public var usersCart = [Bookg]()
    
    public var index = IndexPath()
    
    internal func loadUserCartData()
    {
        guard let user = Auth.auth().currentUser else {return}

        let ref = Database.database(url: "https://booksgallery-3b9f2-default-rtdb.europe-west1.firebasedatabase.app").reference().child("users").child(user.uid).child("cart")

        ref.observe(.childAdded)
        { snapshot,arg in
            let bookId = snapshot.key

            guard let values = snapshot.value as? [String : Any] else {return}

            if let title = values["title"] as? String,
               let price = values["price"] as? Double,
               let author = values["author"] as? String,
               let description = values["description"] as? String,
               let count = values["count"] as? Int
            {
                var bookImage = UIImage()

                Sources.Functions.getImage(bookId: bookId) { image in
                    bookImage = image
                }

                let book = Bookg(bookId: bookId,
                                 title: title,
                                 price: price,
                                 author: author,
                                 description: description,
                                 image: bookImage,
                                 count: count)

                self.usersCart.append(book)
                self.collectionView.reloadData()
            }
        }
    }
    
    private let cancelButton = UIButton()
    private func cancelButtonConfig()
    {
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.cancelButton)
        
        NSLayoutConstraint.activate([
            self.cancelButton.heightAnchor.constraint(equalToConstant: 30),
            self.cancelButton.widthAnchor.constraint(equalToConstant: 90),
            self.cancelButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60),
            self.cancelButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 100)
        ])
        
        self.cancelButton.layoutIfNeeded()
        
        self.cancelButton.backgroundColor = .secondarySystemGroupedBackground
        self.cancelButton.layer.cornerRadius = self.cancelButton.frame.height/2
        
        self.cancelButton.setTitle("Cancel", for: .normal)
        self.cancelButton.setTitleColor(Sources.Colors.systemColor, for: .normal)
        self.cancelButton.setTitleColor(.systemGray, for: .selected)
        
        self.cancelButton.addTarget(self,
                                    action: #selector(handleBack),
                                    for: .touchUpInside)
    }
    
    @objc private func handleBack(sender: UIButton)
    {
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = Sources.Colors.systemColor.cgColor
        colorAnimation.duration = 0.2
        sender.layer.add(colorAnimation, forKey: "ColorPulse")
        
        self.dismiss(animated: true)
    }
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private func collectionViewConfig()
    {
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.collectionView.collectionViewLayout = createCompositionalLayout()
        
        self.view.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 90),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(BookControllerCollectionViewCell.self, forCellWithReuseIdentifier: BookControllerCollectionViewCell.reuseID)
        
        self.collectionView.backgroundColor = .clear
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.cancelButtonConfig()
        self.collectionViewConfig()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.loadUserCartData()
        self.view.layoutIfNeeded()
        super.viewWillAppear(animated)
        self.collectionView.scrollToItem(at: self.index, at: .centeredHorizontally, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        self.animate()
        
        UIView.animate(withDuration: 0.25, delay: 0) {
            self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.25, delay: 0) {
            self.view.backgroundColor = .clear
        }
        self.delegate?.loadUserCartData()
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout
    {
        return UICollectionViewCompositionalLayout
        { sectionIndex, layoutEnvironment in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 10, trailing: 5)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.92), heightDimension: .fractionalHeight(1)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.interGroupSpacing = 0
            section.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
            return section
        }
    }
    
    private func animate()
    {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping:0.8,
                       initialSpringVelocity: 2,
                       options: .curveEaseOut,
                       animations: {
            
            self.cancelButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
            self.view.layoutIfNeeded()

        })
    }
    
}

extension BookViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        self.booksArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: BookControllerCollectionViewCell.reuseID, for: indexPath) as! BookControllerCollectionViewCell
        
        cell.book = self.booksArray[indexPath.item]
        cell.delegate = self
        
        for book in self.usersCart
        {
            if book.bookId == self.booksArray[indexPath.item].bookId
            {
                cell.renameMoveToCartButton()
            }
        }
        
        cell.cellConfig()
        
        return cell
    }
}
