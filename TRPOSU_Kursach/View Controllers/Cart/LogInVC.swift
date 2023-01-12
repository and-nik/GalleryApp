//
//  LogInViewController.swift
//  TRPOSU_Kursach
//
//  Created by And Nik on 14.11.22.
//

import Foundation
import UIKit
import Firebase


protocol CartViewControllerDelegate
{
    func reloadViewControllerDelegate()
}

class LoginViewController : UIViewController
{
    public var delegate : CartViewControllerDelegate?
    
    private lazy var logInRegisterButton = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(handleLogInRegister))
    
    @objc private func handleLogInRegister()
    {
        self.isLogin = !self.isLogin
    }
    
    private var isLogin : Bool = true
    {
        willSet
        {
            if newValue
            {
                self.navigationItem.title = "Log In"
                self.logInRegisterButton.title = "Register"
                self.nameTextField.isHidden = true
            }
            else
            {
                self.navigationItem.title = "Register"
                self.logInRegisterButton.title = "Log In"
                self.nameTextField.isHidden = false
            }
        }
    }
    
    func navigationBarConfig()
    {
        self.navigationItem.title = "Log In"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationController?.navigationBar.tintColor = Sources.Colors.systemColor
        
        self.navigationItem.rightBarButtonItem = self.logInRegisterButton
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
    }
    
    @objc private func handleCancel()
    {
        self.dismiss(animated: true)
    }
    
    private let containerView = UIView()
    private func containerViewConfig()
    {
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.containerView)
        
        NSLayoutConstraint.activate([
            self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.containerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        self.containerView.backgroundColor = .secondarySystemBackground
    }
    
    private let nameTextField = UITextField()
    private func nameTextFieldConfig()
    {
        self.nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.nameTextField)
        
        NSLayoutConstraint.activate([
            self.nameTextField.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 20),
            self.nameTextField.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            self.nameTextField.heightAnchor.constraint(equalToConstant: 30),
            self.nameTextField.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 30)
        ])
        
        self.nameTextField.placeholder = "Enter name"
    }
    
    private let emailTextField = UITextField()
    private func emailTextFieldConfig()
    {
        self.emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.emailTextField)
        
        NSLayoutConstraint.activate([
            self.emailTextField.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 20),
            self.emailTextField.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            self.emailTextField.heightAnchor.constraint(equalToConstant: 30),
            self.emailTextField.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor, constant: 30)
        ])
        
        self.emailTextField.placeholder = "Enter email"
    }
    
    private let passwordTextField = UITextField()
    private func passwordTextFieldConfig()
    {
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.passwordTextField)
        
        NSLayoutConstraint.activate([
            self.passwordTextField.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 20),
            self.passwordTextField.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            self.passwordTextField.heightAnchor.constraint(equalToConstant: 30),
            self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 30)
        ])
        
        self.passwordTextField.placeholder = "Enter password"
    }
    
    private let signInButton = UIButton(type: .system)
    private func signInButtonConfig()
    {
        self.signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.signInButton)
        
        NSLayoutConstraint.activate([
            self.signInButton.heightAnchor.constraint(equalToConstant: 45),
            self.signInButton.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 40),
            self.signInButton.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -40),
            self.signInButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 30),
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
        let name = self.nameTextField.text!
        let email = self.emailTextField.text!
        let password = self.passwordTextField.text!
        
        if !isLogin
        {
            if name == "" { print("Enter name!"); return }
            if email == "" { print("Enter mail!"); return }
            if password == "" { print("Enter password!"); return }
            
            //email must be like xxxxx@xxx.xxx
            //password must be not less then 6 symbols
            
            Firebase.Auth.auth().createUser(withEmail: email, password: password)
            { result, error in
                if error == nil
                {
                    if let result = result
                    {
                        print(result.user.uid)
                        let ref = Database.database(url: "https://booksgallery-3b9f2-default-rtdb.europe-west1.firebasedatabase.app").reference().child("users")
                        ref.child(result.user.uid).updateChildValues(["name" : name, "email" : email, "password" : password])
                        self.dismiss(animated: true)
                        self.delegate?.reloadViewControllerDelegate()
                        print((Auth.auth().currentUser?.email)!)
                    }
                }
                else
                {
                    print("error")
                }
            }
        }
        else
        {
            if email == "" { print("Enter mail!"); return }
            if password == "" { print("Enter password!"); return }
            
            Auth.auth().signIn(withEmail: email, password: password)
            { result, error in
                if error == nil
                {
                    if let result = result
                    {
                        print(result.user.uid)
                        self.delegate?.reloadViewControllerDelegate()
                        self.dismiss(animated: true)
                        
                    }
                    //show success log in alert
                    //dismiss
                    
                }
                else
                {
                    print("error to login")
                }
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.navigationBarConfig()
        
        self.containerViewConfig()
        
        self.nameTextFieldConfig()
        self.emailTextFieldConfig()
        self.passwordTextFieldConfig()
        
        self.signInButtonConfig()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.nameTextField.isHidden = true
    }
}
