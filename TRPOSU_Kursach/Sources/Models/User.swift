//
//  User.swift
//  TRPOSU_Kursach
//
//  Created by And Nik on 13.01.23.
//

import Foundation
import UIKit

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
