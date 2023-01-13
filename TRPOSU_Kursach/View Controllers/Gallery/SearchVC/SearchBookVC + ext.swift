//
//  SearchBookViewController.swift
//  TRPOSU_Kursach
//
//  Created by And Nik on 22.11.22.
//

import Foundation
import UIKit

class SearchBookViewController : UIViewController
{
    public var filteredGallery = [GallerySectiong]()
    
    public let galleryTableView = UITableView(frame: .zero, style: .plain)
    private func galleryTableViewConfig()
    {
        self.galleryTableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.galleryTableView)
        
        NSLayoutConstraint.activate([
            self.galleryTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.galleryTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.galleryTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.galleryTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        self.galleryTableView.delegate = self
        self.galleryTableView.dataSource = self
        
        self.galleryTableView.register(FilteredGalleryTableViewCell.self, forCellReuseIdentifier: FilteredGalleryTableViewCell.reuseID)
        
        self.galleryTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.galleryTableViewConfig()
    }
}

extension SearchBookViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        self.filteredGallery[section].sectionName
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        self.filteredGallery.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        self.filteredGallery[section].books.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = galleryTableView.dequeueReusableCell(withIdentifier: FilteredGalleryTableViewCell.reuseID, for: indexPath) as! FilteredGalleryTableViewCell
        
        cell.book = self.filteredGallery[indexPath.section].books[indexPath.row]
        cell.cellConfig()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let bookVC = BookViewController()
        bookVC.booksArray = self.filteredGallery[indexPath.section].books
        bookVC.index = IndexPath(item: indexPath.item, section: 0)
        bookVC.modalPresentationStyle = .overFullScreen
        
        self.present(bookVC, animated: true)
    }
}

