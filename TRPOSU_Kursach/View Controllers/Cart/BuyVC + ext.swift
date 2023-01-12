//
//  BuyViewController.swift
//  TRPOSU_Kursach
//
//  Created by And Nik on 28.11.22.
//

import Foundation
import UIKit

protocol BuyViewControllerDelegate
{
    func dismiss()
}

extension BuyViewController : BuyViewControllerDelegate
{
    func dismiss()
    {
        self.dismiss(animated: true)
    }
}

class BuyViewController : UIViewController
{
    public var books = [Bookg]()
    
    private func navigationBarConfig()
    {
        self.navigationItem.title = "Order"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.navigationController?.navigationBar.tintColor = Sources.Colors.systemColor
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                                target: self,
                                                                action: #selector(self.handleClose))
    }
    
    @objc private func handleClose()
    {
        self.dismiss(animated: true)
    }
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private func tableViewConfig()
    {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseID)
        
        self.tableView.backgroundColor = .clear
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    }
    
    private let paymentBottomView = UIView()
    private func paymentBottomViewConfig()
    {
        self.paymentBottomView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.paymentBottomView)
        
        NSLayoutConstraint.activate([
            self.paymentBottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.paymentBottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.paymentBottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.paymentBottomView.heightAnchor.constraint(equalToConstant: 155)
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
    
    private let confirmButton = UIButton(type: .system)
    private func confirmButtonConfig()
    {
        self.confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.paymentBottomView.addSubview(self.confirmButton)
        
        NSLayoutConstraint.activate([
            self.confirmButton.bottomAnchor.constraint(equalTo: self.paymentBottomView.bottomAnchor, constant: -40),
            self.confirmButton.leadingAnchor.constraint(equalTo: self.paymentBottomView.leadingAnchor, constant: 20),
            self.confirmButton.trailingAnchor.constraint(equalTo: self.paymentBottomView.trailingAnchor, constant: -20),
            self.confirmButton.heightAnchor.constraint(equalToConstant: 45),
        ])
        
        self.confirmButton.layoutIfNeeded()
        
        self.confirmButton.layer.cornerRadius = self.confirmButton.bounds.height/2
        
        let gradient = Sources.Functions.addGradient(bounds: self.confirmButton.bounds,
                                                   colors: [UIColor.systemYellow.cgColor, UIColor.systemOrange.cgColor],
                                                   startPoint: CGPoint(x: 0, y: 0),
                                                   endPoint: CGPoint(x: 0.7, y: 0.7))
        
        gradient.cornerRadius = self.confirmButton.bounds.height / 2
        
        self.confirmButton.layer.insertSublayer(gradient, at: 0)
        
        self.confirmButton.setTitle("Confirm", for: .normal)
        self.confirmButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        self.confirmButton.setTitleColor(.white, for: .normal)
        
        self.confirmButton.addTarget(self,
                                 action: #selector(handleConfirm),
                                 for: .touchUpInside)
    }
    
    @objc private func handleConfirm()
    {
        let successVC = SuccessViewController()
        successVC.delegate = self
        self.present(successVC, animated: true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGroupedBackground
        
        self.booksArrayConfig()
        
        self.navigationBarConfig()
        self.tableViewConfig()
        
        self.paymentBottomViewConfig()
        self.fullPriceTextLabelConfig()
        self.fullPriceLabelConfig()
        self.amountTextLabelConfig()
        self.amountLabelConfig()
        self.confirmButtonConfig()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.loadInfo()
    }
    
    private func loadInfo()
    {
        self.fullPriceLabel.text = Sources.Functions.getFormatedPriceInString(price: self.books.map({$0.price*Double($0.count)}).reduce(0, +)) + Sources.moneySymbol
        self.amountLabel.text = String(self.books.map({$0.count}).reduce(0, +))
    }
    
    private func booksArrayConfig()
    {
        self.books = self.books.filter
        { book in
            book.count != 0
        }
    }
}

extension BuyViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        self.books.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        120
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseID, for: indexPath) as! CartTableViewCell
        
        cell.book = self.books[indexPath.item]
        cell.cellConfig()
        cell.buyCellConfig()
        
        return cell
    }
}
