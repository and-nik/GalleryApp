//
//  ViewController.swift
//  TRPOSU_Kursach
//
//  Created by And Nik on 30.10.22.
//

import UIKit
import Firebase
import FirebaseStorage



extension CartViewController : CartViewControllerDelegate
{
    func reloadViewControllerDelegate()
    {
        self.viewWillAppear(true)
    }
}

class CartViewController : UIViewController
{
    private var cartArray = [Bookg]()
    
    //lazy var editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleEdit))
    private lazy var profilButton = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(logOut))
    
    private func navigationBarConfig()
    {
        self.navigationItem.title = "Cart"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationController?.navigationBar.tintColor = Sources.Colors.systemColor
        
        //self.navigationItem.rightBarButtonItem = editButton
        self.navigationItem.leftBarButtonItem = profilButton
    }
    
    @objc private func handleEdit(_ sender: UIBarButtonItem)
    {
        self.cartTableView.isEditing = !self.cartTableView.isEditing
        sender.title = (self.cartTableView.isEditing) ? "Done" : "Edit"
        self.cartTableView.reloadData()
    }
    
    @objc private func logOut()
    {
        let profilVC = ProfileViewController()
        profilVC.delegate = self
        self.navigationController?.pushViewController(profilVC, animated: true)
    }
    
    private let infoImageView = UIImageView()
    private func infoImageViewConfig()
    {
        self.infoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.infoImageView)
        
        NSLayoutConstraint.activate([
            self.infoImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.infoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.infoImageView.widthAnchor.constraint(equalToConstant: 100),
            self.infoImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        self.infoImageView.image = UIImage(systemName: "cart.badge.minus")
        self.infoImageView.contentMode = .scaleAspectFill
        self.infoImageView.tintColor = .secondaryLabel
    }
    
    private let infoLabel = UILabel()
    private func infoLabelConfig()
    {
        self.infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.infoLabel)
        
        NSLayoutConstraint.activate([
            self.infoLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.infoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.infoLabel.topAnchor.constraint(equalTo: self.infoImageView.bottomAnchor, constant: 20),
            self.infoLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        self.infoLabel.text = "Your cart is empy."
        self.infoLabel.font = .systemFont(ofSize: 20)
        self.infoLabel.textColor = .secondaryLabel
        self.infoLabel.textAlignment = .center
    }
    
    private let signInButton = UIButton(type: .system)
    private func signInButtonConfig()
    {
        self.signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.signInButton)
        
        NSLayoutConstraint.activate([
            self.signInButton.heightAnchor.constraint(equalToConstant: 45),
            self.signInButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            self.signInButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            self.signInButton.topAnchor.constraint(equalTo: self.infoLabel.bottomAnchor, constant: 30),
        ])
        
        self.signInButton.layoutIfNeeded()
        
        self.signInButton.layer.cornerRadius = self.signInButton.bounds.height/2
        
        let gradient = Sources.Functions.addGradient(bounds: self.signInButton.bounds,
                                                   colors: [UIColor.systemYellow.cgColor, UIColor.systemOrange.cgColor],
                                                   startPoint: CGPoint(x: 0, y: 0),
                                                   endPoint: CGPoint(x: 0.7, y: 0.7))
        
        gradient.cornerRadius = self.signInButton.bounds.height / 2
        
        self.signInButton.layer.insertSublayer(gradient, at: 0)
        
        self.signInButton.setTitle("Sign In", for: .normal)
        self.signInButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        self.signInButton.setTitleColor(.white, for: .normal)
        
        self.signInButton.addTarget(self,
                                   action: #selector(handleSigIn),
                                   for: .touchUpInside)
        
        self.signInButton.layer.shadowRadius = 10
        self.signInButton.layer.shadowOpacity = 0.3
        self.signInButton.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    @objc private func handleSigIn()
    {
        let loginVC = LoginViewController()
        let navigationLoginVC = UINavigationController(rootViewController: loginVC)
        loginVC.delegate = self
        self.present(navigationLoginVC, animated: true)
    }
    
    private let cartTableView = UITableView(frame: .zero, style: .grouped)
    private func cartTableViewConfig()
    {
        self.cartTableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.cartTableView)
        
        NSLayoutConstraint.activate([
            self.cartTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.cartTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.cartTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.cartTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        self.cartTableView.delegate = self
        self.cartTableView.dataSource = self
        
        self.cartTableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseID)
        
        self.cartTableView.backgroundColor = .clear
        
        self.cartTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    }
    
    private let paymentBottomView = UIView()
    private func paymentBottomViewConfig()
    {
        self.paymentBottomView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.paymentBottomView)
        
        NSLayoutConstraint.activate([
            self.paymentBottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.paymentBottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.paymentBottomView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.paymentBottomView.heightAnchor.constraint(equalToConstant: 135)
        ])
        
        self.paymentBottomView.layoutIfNeeded()
        
        self.paymentBottomView.addSubview(Sources.Functions.addBlurEffect(bounds: self.paymentBottomView.bounds))
        
        self.paymentBottomView.layer.shadowRadius = 10
        self.paymentBottomView.layer.shadowOpacity = 0.3
        self.paymentBottomView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    private let fullPriceTextLabel = UILabel()
    private func fullPriceTextLabelConfig()
    {
        self.fullPriceTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.paymentBottomView.addSubview(self.fullPriceTextLabel)
        
        NSLayoutConstraint.activate([
            self.fullPriceTextLabel.topAnchor.constraint(equalTo: self.paymentBottomView.topAnchor, constant: 10),
            self.fullPriceTextLabel.leadingAnchor.constraint(equalTo: self.paymentBottomView.leadingAnchor, constant: 20),
            self.fullPriceTextLabel.heightAnchor.constraint(equalToConstant: 20),
            self.fullPriceTextLabel.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        self.fullPriceTextLabel.font = .boldSystemFont(ofSize: 18)
        self.fullPriceTextLabel.text = "Total price"
    }
    
    private let fullPriceLabel = UILabel()
    private func fullPriceLabelConfig()
    {
        self.fullPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.paymentBottomView.addSubview(self.fullPriceLabel)
        
        NSLayoutConstraint.activate([
            self.fullPriceLabel.topAnchor.constraint(equalTo: self.paymentBottomView.topAnchor, constant: 10),
            self.fullPriceLabel.leadingAnchor.constraint(equalTo: self.fullPriceTextLabel.trailingAnchor, constant: 10),
            self.fullPriceLabel.trailingAnchor.constraint(equalTo: self.paymentBottomView.trailingAnchor, constant: -20),
            self.fullPriceLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        self.fullPriceLabel.font = .systemFont(ofSize: 18)
        self.fullPriceLabel.textAlignment = .right
    }
    
    private let amountTextLabel = UILabel()
    private func amountTextLabelConfig()
    {
        self.amountTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.paymentBottomView.addSubview(self.amountTextLabel)
        
        NSLayoutConstraint.activate([
            self.amountTextLabel.topAnchor.constraint(equalTo: self.fullPriceTextLabel.bottomAnchor, constant: 10),
            self.amountTextLabel.leadingAnchor.constraint(equalTo: self.paymentBottomView.leadingAnchor, constant: 20),
            self.amountTextLabel.heightAnchor.constraint(equalToConstant: 20),
            self.amountTextLabel.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        self.amountTextLabel.font = .boldSystemFont(ofSize: 18)
        self.amountTextLabel.text = "Books amount"
    }
    
    private let amountLabel = UILabel()
    private func amountLabelConfig()
    {
        self.amountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.paymentBottomView.addSubview(self.amountLabel)
        
        NSLayoutConstraint.activate([
            self.amountLabel.topAnchor.constraint(equalTo: self.fullPriceLabel.bottomAnchor, constant: 10),
            self.amountLabel.leadingAnchor.constraint(equalTo: self.amountTextLabel.trailingAnchor, constant: 10),
            self.amountLabel.trailingAnchor.constraint(equalTo: self.paymentBottomView.trailingAnchor, constant: -20),
            self.amountLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        self.amountLabel.font = .systemFont(ofSize: 18)
        self.amountLabel.textAlignment = .right
    }
    
    private let buyButton = UIButton(type: .system)
    private func buyButtonConfig()
    {
        self.buyButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.paymentBottomView.addSubview(self.buyButton)
        
        NSLayoutConstraint.activate([
            self.buyButton.bottomAnchor.constraint(equalTo: self.paymentBottomView.bottomAnchor, constant: -20),
            self.buyButton.leadingAnchor.constraint(equalTo: self.paymentBottomView.leadingAnchor, constant: 20),
            self.buyButton.trailingAnchor.constraint(equalTo: self.paymentBottomView.trailingAnchor, constant: -20),
            self.buyButton.heightAnchor.constraint(equalToConstant: 45),
        ])
        
        self.buyButton.layoutIfNeeded()
        
        self.buyButton.layer.cornerRadius = self.buyButton.bounds.height/2
        
        let gradient = Sources.Functions.addGradient(bounds: self.buyButton.bounds,
                                                   colors: [UIColor.systemYellow.cgColor, UIColor.systemOrange.cgColor],
                                                   startPoint: CGPoint(x: 0, y: 0),
                                                   endPoint: CGPoint(x: 0.7, y: 0.7))
        
        gradient.cornerRadius = self.buyButton.bounds.height / 2
        
        self.buyButton.layer.insertSublayer(gradient, at: 0)
        
        self.buyButton.setTitle("Buy", for: .normal)
        self.buyButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        self.buyButton.setTitleColor(.white, for: .normal)
        
        self.buyButton.addTarget(self,
                                 action: #selector(handleBuy),
                                 for: .touchUpInside)
    }
    
    @objc private func handleBuy()
    {
        let buyVC = BuyViewController()
        buyVC.books = self.cartArray
        self.present(UINavigationController(rootViewController: buyVC), animated: true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        self.navigationBarConfig()
        self.cartTableViewConfig()
        
        self.infoImageViewConfig()
        self.infoLabelConfig()
        self.signInButtonConfig()
        
        self.paymentBottomViewConfig()
        self.fullPriceTextLabelConfig()
        self.fullPriceLabelConfig()
        self.amountTextLabelConfig()
        self.amountLabelConfig()
        self.buyButtonConfig()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        super.viewWillAppear(animated)
        
        self.cartArray.removeAll()
        
        if Auth.auth().currentUser != nil
        {
            self.loadDataFromFirebase()
        }
        
        self.reloadViewController()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        if self.cartTableView.isEditing
        {
            self.cartTableView.isEditing = false
            //self.editButton.title = "Edit"
        }
    }
    
    private func reloadViewController()
    {
        if Auth.auth().currentUser == nil
        {
            self.profilButton.isEnabled = false
            
            self.profilButton.title = ""
            self.signInButton.isHidden = false
            self.paymentBottomView.isHidden = true
            
            self.infoLabel.isHidden = false
            self.infoImageView.isHidden = false
            
            self.infoImageView.image = UIImage(systemName: "person.fill.questionmark")
            self.infoLabel.text = "Sig In to use cart and by some books."
            
            self.tabBarController?.tabBar.items![1].badgeValue = nil
        }
        else
        {
            self.loadUser()
            self.profilButton.isEnabled = true
            
            self.profilButton.title = "Profile"
            self.signInButton.isHidden = true
            
            if self.cartArray.isEmpty
            {
                self.infoImageView.isHidden = false
                self.infoLabel.isHidden = false
                
                self.infoImageView.image = UIImage(systemName: "cart.badge.minus")
                self.infoLabel.text = "Your cart is empy."
                
                self.paymentBottomView.isHidden = true
                self.tabBarController?.tabBar.items![1].badgeValue = nil
            }
            else
            {
                self.infoImageView.isHidden = true
                self.infoLabel.isHidden = true
                
                self.paymentBottomView.isHidden = false
                self.tabBarController?.tabBar.items![1].badgeValue = String(self.cartArray.map({$0.count}).reduce(0, +))
            }
        }
        
        self.fullPriceLabel.text = Sources.Functions.getFormatedPriceInString(price: self.cartArray.map({$0.price*Double($0.count)}).reduce(0, +)) + Sources.moneySymbol
        self.amountLabel.text = String(self.cartArray.map({$0.count}).reduce(0, +))
        
        self.cartTableView.reloadData()
    }
    
    private func loadDataFromFirebase()
    {
        let ref = Database.database(url: "https://booksgallery-3b9f2-default-rtdb.europe-west1.firebasedatabase.app").reference().child("users").child(Auth.auth().currentUser!.uid).child("cart")

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

                self.cartArray.append(book)
                
                self.reloadViewController()
            }
        }
    }
    
    private func loadUser()
    {
        guard let fireUser = Auth.auth().currentUser else {return}
        
        let userRef = Database.database(url: "https://booksgallery-3b9f2-default-rtdb.europe-west1.firebasedatabase.app").reference().child("users").child(fireUser.uid)
        
        userRef.observe(.value)
        { data in
            guard let value = data.value as? [String : Any] else {return}
            guard let name = value["name"] as? String else {return}
            guard let password = value["password"] as? String else {return}
            
            user.name = name
            user.password = password
        }
        
        user.email = fireUser.email!
    }
}

extension CartViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        self.cartArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseID, for: indexPath) as! CartTableViewCell
        
        cell.book = self.cartArray[indexPath.item]
        cell.cellConfig()
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        let newPosition = self.cartArray[sourceIndexPath.item]
        
        self.cartArray.remove(at: sourceIndexPath.item)
        self.cartArray.insert(newPosition, at: destinationIndexPath.item)
        
        self.reloadViewController()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let ref = Database.database(url: "https://booksgallery-3b9f2-default-rtdb.europe-west1.firebasedatabase.app").reference().child("users").child(Auth.auth().currentUser!.uid).child("cart")
            
            ref.child(self.cartArray[indexPath.row].bookId).removeValue()
            
            self.cartArray.remove(at: indexPath.item)
            self.cartTableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        self.reloadViewController()
    }
}



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
