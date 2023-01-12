//
//  ProfilViewController.swift
//  TRPOSU_Kursach
//
//  Created by And Nik on 14.11.22.
//

import UIKit
import Firebase

class ProfileViewController : UIViewController
{
    public var delegate : CartViewControllerDelegate?
    
    private func navigationBarConfig()
    {
        self.navigationItem.title = "Profile"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationController?.navigationBar.tintColor = Sources.Colors.systemColor
    }
    
    private let containerView = UIView()
    private func containerViewConfig()
    {
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.containerView)
        
        NSLayoutConstraint.activate([
            self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.containerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.containerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private var nameTextLabel : UILabel =
    {
        let label = UILabel()
        label.text = "User name"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private var nameView : UIView =
    {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    private var emailTextLabel : UILabel =
    {
        let label = UILabel()
        label.text = "Email"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private var emailView : UIView =
    {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    private var passwordTextLabel : UILabel =
    {
        let label = UILabel()
        label.text = "Password"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private var passwordView : UIView =
    {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    private func itemsConfig()
    {
        self.nameTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nameView.translatesAutoresizingMaskIntoConstraints = false
        self.emailTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.emailView.translatesAutoresizingMaskIntoConstraints = false
        self.passwordTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.passwordView.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.nameTextLabel)
        self.containerView.addSubview(self.nameView)
        self.containerView.addSubview(self.emailTextLabel)
        self.containerView.addSubview(self.emailView)
        self.containerView.addSubview(self.passwordTextLabel)
        self.containerView.addSubview(self.passwordView)
        
        NSLayoutConstraint.activate([
            self.nameTextLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 20),
            self.nameTextLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -20),
            self.nameTextLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 0),
            self.nameTextLabel.heightAnchor.constraint(equalToConstant: 20),
            
            self.nameView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0),
            self.nameView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0),
            self.nameView.topAnchor.constraint(equalTo: self.nameTextLabel.bottomAnchor, constant: 5),
            self.nameView.heightAnchor.constraint(equalToConstant: 40),
            
            self.emailTextLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 20),
            self.emailTextLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -20),
            self.emailTextLabel.topAnchor.constraint(equalTo: self.nameView.bottomAnchor, constant: 10),
            self.emailTextLabel.heightAnchor.constraint(equalToConstant: 20),
            
            self.emailView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0),
            self.emailView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0),
            self.emailView.topAnchor.constraint(equalTo: self.emailTextLabel.bottomAnchor, constant: 5),
            self.emailView.heightAnchor.constraint(equalToConstant: 40),
            
            self.passwordTextLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 20),
            self.passwordTextLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -20),
            self.passwordTextLabel.topAnchor.constraint(equalTo: self.emailView.bottomAnchor, constant: 10),
            self.passwordTextLabel.heightAnchor.constraint(equalToConstant: 20),
            
            self.passwordView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0),
            self.passwordView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0),
            self.passwordView.topAnchor.constraint(equalTo: self.passwordTextLabel.bottomAnchor, constant: 5),
            self.passwordView.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        self.view.layoutIfNeeded()
        
        self.nameView.layer.cornerRadius = self.nameView.bounds.height/2
        self.emailView.layer.cornerRadius = self.emailView.bounds.height/2
        self.passwordView.layer.cornerRadius = self.passwordView.bounds.height/2
    }
    
    private let nameLabel = UILabel()
    private func nameLabelConfig()
    {
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.nameLabel)
        
        NSLayoutConstraint.activate([
            self.nameLabel.leadingAnchor.constraint(equalTo: self.nameView.leadingAnchor, constant: 20),
            self.nameLabel.trailingAnchor.constraint(equalTo: self.nameView.trailingAnchor, constant: 20),
            self.nameLabel.topAnchor.constraint(equalTo: self.nameView.topAnchor),
            self.nameLabel.bottomAnchor.constraint(equalTo: self.nameView.bottomAnchor),
        ])
        
        self.nameLabel.text = "User"
        self.nameLabel.font = .systemFont(ofSize: 18)
    }
    
    private let emailLabel = UILabel()
    private func emailLabelConfig()
    {
        self.emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.emailLabel)
        
        NSLayoutConstraint.activate([
            self.emailLabel.leadingAnchor.constraint(equalTo: self.emailView.leadingAnchor, constant: 20),
            self.emailLabel.trailingAnchor.constraint(equalTo: self.emailView.trailingAnchor, constant: 20),
            self.emailLabel.topAnchor.constraint(equalTo: self.emailView.topAnchor),
            self.emailLabel.bottomAnchor.constraint(equalTo: self.emailView.bottomAnchor),
        ])
        
        self.emailLabel.text = "Email"
        self.emailLabel.font = .systemFont(ofSize: 18)
    }
    
    private let passwordLabel = UILabel()
    private func passwordLabelConfig()
    {
        self.passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.passwordLabel)
        
        NSLayoutConstraint.activate([
            self.passwordLabel.leadingAnchor.constraint(equalTo: self.passwordView.leadingAnchor, constant: 20),
            self.passwordLabel.trailingAnchor.constraint(equalTo: self.passwordView.trailingAnchor, constant: 20),
            self.passwordLabel.topAnchor.constraint(equalTo: self.passwordView.topAnchor),
            self.passwordLabel.bottomAnchor.constraint(equalTo: self.passwordView.bottomAnchor),
        ])
        
        self.passwordLabel.text = "Pass"
        self.passwordLabel.font = .systemFont(ofSize: 18)
    }
    
    private let logOutButton = UIButton(type: .system)
    private func logOutButtonConfig()
    {
        self.logOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.logOutButton)
        
        NSLayoutConstraint.activate([
            self.logOutButton.heightAnchor.constraint(equalToConstant: 45),
            self.logOutButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            self.logOutButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            self.logOutButton.topAnchor.constraint(equalTo: self.passwordView.bottomAnchor, constant: 40),
        ])
        
        self.logOutButton.layoutIfNeeded()
        
        self.logOutButton.layer.cornerRadius = self.logOutButton.bounds.height/2
        
        self.logOutButton.backgroundColor = .red
        
        self.logOutButton.setTitle("Log Out", for: .normal)
        self.logOutButton.setTitleColor(.white, for: .normal)
        self.logOutButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        
        self.logOutButton.addTarget(self,
                                   action: #selector(handleSigIn),
                                   for: .touchUpInside)
        
        self.logOutButton.layer.shadowRadius = 10
        self.logOutButton.layer.shadowOpacity = 0.3
        self.logOutButton.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    @objc private func handleSigIn()
    {
        let alert = UIAlertController(title: "Log Out", message: "Do you realy wont to log out?", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
        let sigInButton = UIAlertAction(title: "Log Out", style: .default)
        {_ in
            do
            {
                try Auth.auth().signOut()
            }
            catch
            {
                print("Log Out failure")
            }
            self.navigationController?.popViewController(animated: true)
            self.delegate?.reloadViewControllerDelegate()
        }
        
        alert.addAction(cancelButton)
        alert.addAction(sigInButton)
        
        self.present(alert, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.navigationBarConfig()
        
        self.containerViewConfig()
        
        self.itemsConfig()
        
        self.nameLabelConfig()
        self.emailLabelConfig()
        self.passwordLabelConfig()
        
        self.logOutButtonConfig()
        
        self.configLabels()
    }
    
    private func configLabels()
    {
        self.nameLabel.text = user.name
        self.passwordLabel.text = user.password
        self.emailLabel.text = user.email
    }
}
