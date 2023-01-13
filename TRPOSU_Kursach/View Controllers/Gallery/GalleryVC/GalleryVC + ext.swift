//
//  GalleryViewController.swift
//  TRPOSU_Kursach
//
//  Created by And Nik on 30.10.22.
//

import UIKit
import Firebase
import FirebaseStorage

protocol GalleryViewControllerDelegate
{
    func loadUserCartData()
}

//MARK: - Gallery view controller

extension GalleryViewController : GalleryViewControllerDelegate{}

class GalleryViewController : UIViewController
{
    private var gallery = [GallerySectiong]()
    
    private func navigationBarConfig()
    {
        self.navigationItem.title = "Gallery"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private let searchController = UISearchController(searchResultsController: SearchBookViewController())
    private func searchControllerConfig()
    {
        self.navigationItem.searchController = self.searchController
        
        self.searchController.searchBar.placeholder = "Search book"
        
        self.searchController.searchResultsUpdater = self
        self.searchController.showsSearchResultsController = true//show result controller content even searchBar.text is empty
        
        self.searchController.searchBar.tintColor = Sources.Colors.systemColor
        
        self.definesPresentationContext = true//,,,,,,,,,,,,<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    }
    
    private let galleryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private func galleryCollectionViewConfig()
    {
        self.galleryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.galleryCollectionView)
        
        NSLayoutConstraint.activate([
            self.galleryCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.galleryCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.galleryCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.galleryCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        self.galleryCollectionView.collectionViewLayout = createCompositionalLayout()
        
        self.galleryCollectionView.delegate = self
        self.galleryCollectionView.dataSource = self
        
        self.galleryCollectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseID)
        self.galleryCollectionView.register(GalleryCollectionViewCell2.self, forCellWithReuseIdentifier: GalleryCollectionViewCell2.reuseID)
        self.galleryCollectionView.register(GalleryCollectionViewHeaderInSection.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GalleryCollectionViewHeaderInSection.reuseID)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.startLoadingAlert()
        
        self.loadDataFromFirebase()
        self.loadUserCartData()

        self.navigationBarConfig()
        self.searchControllerConfig()
        
        self.galleryCollectionViewConfig()
        
        self.view.backgroundColor = .systemBackground
    }
    
    private func startLoadingAlert()
    {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()

        alert.view.addSubview(loadingIndicator)

        OperationQueue.main.addOperation
        {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func loadDataFromFirebase()
    {
        let ref = Database.database(url: "https://booksgallery-3b9f2-default-rtdb.europe-west1.firebasedatabase.app").reference().child("gallery")
        
        var sectionRef : DatabaseReference!

        ref.observe(.childAdded)
        { data in
            //guard let array = data.value as? [String : [String : Any]] else {return}
            let section : String = data.key
            
            sectionRef = ref.child(section)
            
            sectionRef.observe(.childAdded)
            { snapshot,arg  in
                let bookId = snapshot.key

                guard let values = snapshot.value as? [String : Any] else {return}

                if let title = values["title"] as? String,
                   let price = values["price"] as? Double,
                   let author = values["author"] as? String,
                   let description = values["description"] as? String
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
                                     count: 1)

                    if !Sources.Functions.isExist(sectionName: section, gallery: self.gallery)
                    {
                        self.gallery.append(GallerySectiong(sectionName: section))
                    }

                    for sec in self.gallery where sec.sectionName == section
                    {
                        sec.books.append(book)
                        self.galleryCollectionView.reloadData()
                    }
                }
                OperationQueue.main.addOperation
                {
                    self.dismiss(animated: true)
                }
            }
        }
        
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
    
    internal func loadUserCartData()
    {
        var usersCart = [Bookg]()

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

                usersCart.append(book)
                self.tabBarController?.tabBar.items![1].badgeValue = String(usersCart.map({$0.count}).reduce(0, +))
            }
        }
    }

    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout
    {
        return UICollectionViewCompositionalLayout
        { sectionIndex, layoutEnvironment in

            if (sectionIndex + 1) % 2 == 0
            {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.95), heightDimension: .fractionalHeight(0.95)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 0)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.95), heightDimension: .absolute(260)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.interGroupSpacing = 0
                section.boundarySupplementaryItems = [self.headerInSection()]//header in section
                return section
            }
            else
            {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.95), heightDimension: .fractionalHeight(0.95)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(160), heightDimension: .absolute(240)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 0
                //section.contentInsets = .init(top: 10, leading: 20, bottom: 10, trailing: 20)
                section.boundarySupplementaryItems = [self.headerInSection()]//header in section
                return section
            }
        }
    }
    
}

extension GalleryViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    //MARK: Header in section
    //------------------------------------------------------------
    private func headerInSection() -> NSCollectionLayoutBoundarySupplementaryItem
    {
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        return header
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let header = self.galleryCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                                 withReuseIdentifier: GalleryCollectionViewHeaderInSection.reuseID,
                                                                                 for: indexPath) as! GalleryCollectionViewHeaderInSection
        header.config(title: self.gallery[indexPath.section].sectionName)

        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        CGSize(width: self.view.frame.width, height: 50)
    }
    //------------------------------------------------------------
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return self.gallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.gallery[section].books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if (indexPath.section+1) % 2 == 0
        {
            let cell = self.galleryCollectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell2.reuseID, for: indexPath) as! GalleryCollectionViewCell2
            cell.book = self.gallery[indexPath.section].books[indexPath.item]
            cell.config()
            return cell
        }
        else
        {
            let cell = self.galleryCollectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseID, for: indexPath) as! GalleryCollectionViewCell
            cell.book = self.gallery[indexPath.section].books[indexPath.item]
            cell.config()
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.galleryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        let bookVC = BookViewController()
        bookVC.booksArray = self.gallery[indexPath.section].books
        bookVC.index = IndexPath(item: indexPath.item, section: 0)
        bookVC.modalPresentationStyle = .overFullScreen
        bookVC.delegate = self
        
        self.present(bookVC, animated: true)
    }
}

extension GalleryViewController : UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        guard let text = self.searchController.searchBar.text else {return}
        
        var filteredGallery = [GallerySectiong]()
        
        if text == ""
        {
            filteredGallery = self.gallery
        }
        else
        {
            for i in 0...self.gallery.count - 1
            {
                let sec = GallerySectiong(sectionName: self.gallery[i].sectionName)
                filteredGallery.append(sec)
                
                for book in self.gallery[i].books
                {
                    if book.title.lowercased().contains(text.lowercased())
                    {
                        filteredGallery[i].books.append(book)
                    }
                }
            }
        }
        
        guard let searchResultsVC = self.searchController.searchResultsController as? SearchBookViewController else {return}
        searchResultsVC.filteredGallery = filteredGallery
        searchResultsVC.galleryTableView.reloadData()
    }
    
    
}
