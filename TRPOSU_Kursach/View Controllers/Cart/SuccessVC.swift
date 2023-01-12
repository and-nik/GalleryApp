//
//  SuccessViewController.swift
//  TRPOSU_Kursach
//
//  Created by And Nik on 28.11.22.
//

import Foundation
import UIKit

class SuccessViewController : UIViewController
{
    public var delegate : BuyViewControllerDelegate?
    
    private let containerView = UIView()
    private func containerViewConfig()
    {
        self.containerView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(self.containerView)

        NSLayoutConstraint.activate([
            self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            self.containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            self.containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100),
            self.containerView.heightAnchor.constraint(equalToConstant: 400)
        ])

        self.containerView.layoutIfNeeded()

        self.containerView.backgroundColor = .systemBackground
        
        self.containerView.layer.cornerRadius = 50
    }
    
    private let imageView = UIImageView(image: .init(named: "success"))
    private func imageViewConfig()
    {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.imageView)
        
        NSLayoutConstraint.activate([
            self.imageView.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor, constant: -50),
            self.imageView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.imageView.heightAnchor.constraint(equalToConstant: 100),
            self.imageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        self.imageView.contentMode = .scaleAspectFill
    }
    
    private let successLabel = UILabel()
    private func successLabelConfig()
    {
        self.successLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.successLabel)
        
        NSLayoutConstraint.activate([
            self.successLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.successLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            self.successLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 10),
            self.successLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        self.successLabel.font = .boldSystemFont(ofSize: 40)
        self.successLabel.textAlignment = .center
        self.successLabel.textColor = .systemGreen
        
        self.successLabel.text = "SUCCESS!"
    }
    
    private let successTextLabel = UILabel()
    private func successTextLabelConfig()
    {
        self.successTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.successTextLabel)
        
        NSLayoutConstraint.activate([
            self.successTextLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.successTextLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            self.successTextLabel.topAnchor.constraint(equalTo: self.successLabel.bottomAnchor, constant: 10),
            self.successTextLabel.heightAnchor.constraint(equalToConstant: 20),
            
        ])
        
        self.successTextLabel.font = .systemFont(ofSize: 20)
        self.successTextLabel.textAlignment = .center
        self.successTextLabel.textColor = .secondaryLabel
        
        self.successTextLabel.text = "Your order successfully made!"
    }
    
    private let doneButton = UIButton(type: .system)
    private func doneButtonConfig()
    {
        self.doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.doneButton)
        
        NSLayoutConstraint.activate([
            self.doneButton.heightAnchor.constraint(equalToConstant: 45),
            self.doneButton.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 40),
            self.doneButton.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -40),
            self.doneButton.topAnchor.constraint(equalTo: self.successTextLabel.bottomAnchor, constant: 30),
        ])
        
        self.doneButton.layoutIfNeeded()
        
        self.doneButton.layer.cornerRadius = self.doneButton.bounds.height/2
        
        let gradient = Sources.Functions.addGradient(bounds: self.doneButton.bounds,
                                                   colors: [UIColor.systemYellow.cgColor, UIColor.systemGreen.cgColor],
                                                   startPoint: CGPoint(x: 0, y: 0),
                                                   endPoint: CGPoint(x: 0.7, y: 0.7))
        
        gradient.cornerRadius = self.doneButton.bounds.height / 2
        
        self.doneButton.layer.insertSublayer(gradient, at: 0)
        
        self.doneButton.setTitle("Done", for: .normal)
        self.doneButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        self.doneButton.setTitleColor(.white, for: .normal)
        
        self.doneButton.addTarget(self,
                                   action: #selector(handleDone),
                                   for: .touchUpInside)
        
        self.doneButton.layer.shadowRadius = 10
        self.doneButton.layer.shadowOpacity = 0.3
        self.doneButton.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    @objc private func handleDone()
    {
        self.dismiss(animated: true)
        self.delegate?.dismiss()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.containerViewConfig()
        self.imageViewConfig()
        self.successLabelConfig()
        self.successTextLabelConfig()
        self.doneButtonConfig()
    }
}
