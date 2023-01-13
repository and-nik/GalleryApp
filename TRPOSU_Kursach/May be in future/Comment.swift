//
//  Comment.swift
//  TRPOSU_Kursach
//
//  Created by And Nik on 13.01.23.
//

import Foundation

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
