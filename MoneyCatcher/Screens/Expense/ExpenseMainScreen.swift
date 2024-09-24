//
//  ExpenseMainScreen.swift
//  MoneyCatcher
//
//  Created by Çağatay Yıldız on 18.09.2024.
//

import SwiftUI
import Alamofire

struct ExpenseMainScreen: View {
    
    @State var expenses : [ExpenseModel] = []
    
    var body: some View {
        ScrollView{
            VStack{
                
                ForEach(expenses, id:\._id){item in
                    Text("\(item.description) \(item.amount) \(item.category.name)")
                        .padding()
                    
                    Text(item.date)
                        .padding()
                }
                
            }
            .onAppear(){
                let request = AF.request("\(APIConfig.apiUrl)/expense", encoding: JSONEncoding.default).responseDecodable(of: [ExpenseModel].self){response in
                    
                    expenses = response.value ?? []
                    print(expenses)
                }
            }
        }
      
    }
}

#Preview {
    ExpenseMainScreen()
}
