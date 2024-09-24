//
//  ExpenseModell.swift
//  MoneyCatcher
//
//  Created by Çağatay Yıldız on 24.09.2024.
//

import Foundation


struct ExpenseModel : Codable{
    var _id: String = ""
    var amount : Double = 0
    var description : String = ""
    var date : String = ""
    var category : Category = Category()
}


struct Category : Codable{
    var name : String = ""
}
