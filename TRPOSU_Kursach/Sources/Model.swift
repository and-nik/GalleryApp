//
//  Model.swift
//  TRPOSU_Kursach
//
//  Created by And Nik on 30.10.22.
//

import UIKit
import Firebase
import FirebaseStorage

var description = "This amaizing book will give you amaizing expirience of book reading. Here must be some description of book, but i do not wont write this for evrey book in this arrya. Is a just some words, there doesent have any reason. Do not raed this text becouce it is just for fun. Hey, stop doing this. Oh... You sou persistent. I love you for this and i wont a child from you :3"

var integer: Int = 1

enum Sources
{
    static var moneySymbol = "$"
    
    static var cartArray = [Bookg]()
    
    static var isUserLogin = false
    
    class Functions
    {
        static func isExist(sectionName : String, gallery : [GallerySectiong]) -> Bool
        {
            for section in gallery
            {
                if section.sectionName == sectionName
                {
                    return true
                }
            }
            return false
        }
        
        static func addBlurEffect(bounds: CGRect) -> UIVisualEffectView
        {
            let visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
            visualEffect.frame = bounds
            visualEffect.autoresizingMask = [.flexibleHeight, .flexibleWidth]

            return visualEffect
        }
        
        static func drawLine(rect: CGRect, color: UIColor) -> UIView
        {
            let line = UIView()
            line.frame = rect
            line.layer.borderColor = color.cgColor
            line.layer.borderWidth = 1
            
            return line
        }
        
        static func addGradient(bounds: CGRect, colors: [CGColor], startPoint: CGPoint, endPoint: CGPoint) -> CAGradientLayer
        {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = bounds
            gradientLayer.startPoint = startPoint
            gradientLayer.endPoint = endPoint
            gradientLayer.colors = colors
            return gradientLayer
        }
        
        static func getFormatedPriceInString(price: Double) -> String
        {
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 2//200 -> 200.00
            formatter.numberStyle = .decimal
            
            return formatter.string(from: price as NSNumber)!
        }
        
        static func getImage(bookId : String?, completion: @escaping (UIImage) -> Void)
        {
            let ref = Storage.storage().reference().child("books_images")
            
            var imageFromData = UIImage()
            
            if let bookId = bookId
            {
                let imageRef = ref.child(bookId + ".jpeg")
                imageRef.getData(maxSize: 1024*1024)
                { data, error in
                    if error == nil
                    {
                        imageFromData = UIImage(data: data!)!
                        completion(imageFromData)
                    }
                    else
                    {
                        imageFromData = UIImage(systemName: "photo.artframe")!
                        completion(imageFromData)
                    }
                }
            }
        }
    }
    
    enum Colors
    {
        static var systemColor = UIColor.systemOrange
    }
}

class User
{
    var name : String
    var password : String
    var email : String
    var cart : [Bookg]?
    
    init(name: String, password: String, email: String, cart: [Bookg]? = nil)
    {
        self.name = name
        self.password = password
        self.email = email
        self.cart = cart
    }
}

var user = User(name: "", password: "", email: "")

class Comment
{
    var date : Date
    var title : String
    var userName : String
    var rate : Int
    var comment : String
    
    init(date: Date, title: String, userName: String, rate: Int, comment: String)
    {
        self.date = date
        self.title = title
        self.userName = userName
        self.rate = rate
        self.comment = comment
    }
}

class Bookg
{
    var bookId : String
    var title : String
    var price : Double
    var author : String
    var description : String
    var count : Int
    
    var iamge : UIImage
    
    init(bookId: String, title: String, price: Double, author: String, description: String, image : UIImage, count : Int)
    {
        self.bookId = bookId
        self.title = title
        self.price = price
        self.author = author
        self.description = description
        self.count = count
        
        self.iamge = image
    }

    

}

class GallerySectiong
{
    var sectionName = String()
    var books = [Bookg]()
    
    init(sectionName: String)
    {
        self.sectionName = sectionName
    }
}
