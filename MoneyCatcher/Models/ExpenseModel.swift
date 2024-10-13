//
//  ExpenseModell.swift
//  MoneyCatcher
//
//  Created by Çağatay Yıldız on 24.09.2024.
//

import Foundation


struct ExpenseModel: Codable {
    let id: String?
    let amount: Double
    let category: FetchCategory
    let date: String
    let description: String?
    let images: [String]?
        
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case amount, category, date, description, images
    }
}
struct AddExpenseModel : Codable, Hashable{
    var _id: String = ""
    var amount : Double
    var description : String = ""
    var date : String = ""
    var category : Category = Category()
    let images: [Data]?
}

struct Category : Codable, Hashable{
    var _id : String = ""
    var name : String = ""
}

struct FetchCategory: Codable
{
        let name: String
}
