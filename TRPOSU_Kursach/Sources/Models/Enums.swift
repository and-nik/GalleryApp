//
//  File.swift
//  TRPOSU_Kursach
//
//  Created by And Nik on 13.01.23.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

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
