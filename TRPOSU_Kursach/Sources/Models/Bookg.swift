//
//  Bookg.swift
//  TRPOSU_Kursach
//
//  Created by And Nik on 13.01.23.
//

import Foundation
import UIKit

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
