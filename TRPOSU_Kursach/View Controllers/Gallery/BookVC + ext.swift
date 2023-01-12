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

class BookControllerCollectionViewCell : UICollectionViewCell
{
    static let reuseID = "BookControllerCollectionViewCell"
    
    public var book : Bookg?
    
    public var delegate : BookViewControllerDelegate?

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
    }
    
    private let bookImageView = UIImageView()
    private func bookImageViewConfig()
    {
        self.bookImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.bookImageView)
        
        NSLayoutConstraint.activate([
            self.bookImageView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 40),
            self.bookImageView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -40),
            self.bookImageView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 40),
            self.bookImageView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -320)
        ])
        
        self.bookImageView.layoutIfNeeded()
        
        self.bookImageView.layer.cornerRadius = 10
        
        self.bookImageView.contentMode = .scaleAspectFit
        
        self.bookImageView.image = UIImage(systemName: "photo.artframe")!
        
        self.bookImageView.layer.shadowRadius = 10
        self.bookImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.bookImageView.layer.shadowOpacity = 0.5
    }
    
    private let nameLabel = UILabel()
    private func nameLabelConfig()
    {
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.nameLabel)
        
        NSLayoutConstraint.activate([
            self.nameLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 20),
            self.nameLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -20),
            self.nameLabel.topAnchor.constraint(equalTo: self.bookImageView.bottomAnchor, constant: 20),
            self.nameLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        self.nameLabel.layoutIfNeeded()
        
        self.nameLabel.numberOfLines = 2
        self.nameLabel.font = .boldSystemFont(ofSize: 25)
        self.nameLabel.textAlignment = .center
        self.nameLabel.lineBreakMode = .byWordWrapping
    }
    
    private let authorLabel = UILabel()
    private func authorLabelConfig()
    {
        self.authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.authorLabel)
        
        NSLayoutConstraint.activate([
            self.authorLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 20),
            self.authorLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -20),
            self.authorLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 10),
            self.authorLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        self.authorLabel.font = .systemFont(ofSize: 18)
        self.authorLabel.textColor = .secondaryLabel
        self.authorLabel.textAlignment = .center
    }
    
    private var priceLabel = UILabel()
    private func priceLabelConfig()
    {
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.priceLabel)
        
        NSLayoutConstraint.activate([
            self.priceLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 40),
            self.priceLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -40),
            self.priceLabel.heightAnchor.constraint(equalToConstant: 45),
            self.priceLabel.topAnchor.constraint(equalTo: self.authorLabel.bottomAnchor, constant: 30)
        ])
        
        self.priceLabel.layoutIfNeeded()
        
        self.priceLabel.layer.borderWidth = 5
        self.priceLabel.layer.borderColor = UIColor.label.cgColor
        self.priceLabel.layer.cornerRadius = self.priceLabel.bounds.height/2
        
        self.priceLabel.textAlignment = .center
        self.priceLabel.font = .boldSystemFont(ofSize: 20)
    }
    
    private let moveToCartButton = UIButton(type: .system)
    private func moveToCartButtonConfig()
    {
        self.moveToCartButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.moveToCartButton)
        
        NSLayoutConstraint.activate([
            self.moveToCartButton.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 40),
            self.moveToCartButton.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -40),
            self.moveToCartButton.heightAnchor.constraint(equalToConstant: 45),
            self.moveToCartButton.topAnchor.constraint(equalTo: self.priceLabel.bottomAnchor, constant: 10)
        ])
        
        self.moveToCartButton.layoutIfNeeded()
        
        self.moveToCartButton.layer.cornerRadius = self.moveToCartButton.frame.height/2
        
        let gradient = Sources.Functions.addGradient(bounds: self.moveToCartButton.bounds,
                                                   colors: [UIColor.systemYellow.cgColor, UIColor.systemOrange.cgColor],
                                                   startPoint: CGPoint(x: 0, y: 0),
                                                   endPoint: CGPoint(x: 0.7, y: 0.7))
        
        gradient.cornerRadius = self.moveToCartButton.bounds.height / 2
        
        self.moveToCartButton.layer.insertSublayer(gradient, at: 0)
        
        self.moveToCartButton.setTitle("Move to Cart", for: .normal)
        
        self.moveToCartButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        self.moveToCartButton.setTitleColor(.white, for: .normal)
        
        self.moveToCartButton.addTarget(self,
                                 action: #selector(handleMoveToCart),
                                 for: .touchUpInside)
        
        self.moveToCartButton.layer.shadowRadius = 10
        self.moveToCartButton.layer.shadowOpacity = 0.3
        self.moveToCartButton.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    @objc private func handleMoveToCart()
    {
        if Auth.auth().currentUser == nil
        {
            let alert = UIAlertController(title: "You not log in", message: "Log in or register to move the books to the cart.", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
            let sigInButton = UIAlertAction(title: "Sign In", style: .default)
            {_ in
                let logInVC = LoginViewController()
                let navigationLogInVC = UINavigationController(rootViewController: logInVC)
                self.delegate?.presentAlert(VC: navigationLogInVC)
            }
            
            alert.addAction(cancelButton)
            alert.addAction(sigInButton)
            
            self.delegate?.presentAlert(VC: alert)
            return
        }

        let ref = Database.database(url: "https://booksgallery-3b9f2-default-rtdb.europe-west1.firebasedatabase.app").reference().child("users").child(Auth.auth().currentUser!.uid).child("cart")

        ref.child(self.book!.bookId).updateChildValues(["price" : self.book!.price,
                                                       "title" : self.book!.title,
                                                       "author" : self.book!.author,
                                                       "description" : self.book!.description,
                                                        "count" : 1])
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.containerViewConfig()
        self.bookImageViewConfig()
        self.nameLabelConfig()
        self.authorLabelConfig()
        self.priceLabelConfig()
        self.moveToCartButtonConfig()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func renameMoveToCartButton()
    {
        self.moveToCartButton.setTitle("Already in cart", for: .normal)
        
        let gradient = Sources.Functions.addGradient(bounds: self.moveToCartButton.bounds,
                                                   colors: [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor],
                                                   startPoint: CGPoint(x: 0, y: 0),
                                                   endPoint: CGPoint(x: 1, y: 1))
        
        gradient.cornerRadius = self.moveToCartButton.bounds.height / 2
        
        self.moveToCartButton.layer.insertSublayer(gradient, at: 1)
        
        self.moveToCartButton.setTitle("Already in Cart", for: .normal)
    }
    
    public func cellConfig()
    {
        Sources.Functions.getImage(bookId: self.book?.bookId) { image in
            self.bookImageView.image = image
        }
        self.priceLabel.text = Sources.Functions.getFormatedPriceInString(price: self.book!.price) + Sources.moneySymbol
        self.nameLabel.text = self.book?.title
        self.authorLabel.text = self.book?.author
    }
}

