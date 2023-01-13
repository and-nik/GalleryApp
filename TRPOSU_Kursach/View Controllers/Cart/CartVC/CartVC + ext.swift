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
