//
//  ExpenseMainScreen.swift
//  MoneyCatcher
//
//  Created by Çağatay Yıldız on 18.09.2024.
//

import Alamofire
import SwiftUI

struct ExpenseMainScreen: View {

    @State var expenses: [ExpenseModel] = []
    var dateFilters : [DateFilterModel] = [DateFilterModel(key: "today", text:"Today"),DateFilterModel(key: "yesterday", text:"Yesterday"),DateFilterModel(key: "last_week", text:"Last Week"),DateFilterModel(key: "last_month", text:"Last Month"),DateFilterModel(key: "all", text:"All")]
    @State private var selectedDateFilter = DateFilterModel(key: "today", text:"today")
    
    
    @State var categories : [CategoryPickerModel] = []
    @State private var selectedCategory = CategoryPickerModel()
    
    
    @State var minAmount : String = ""
    @State var maxAmount : String = ""
    

    var body: some View {
        NavigationView {
        ScrollView {
                   VStack(spacing: 18) {  // Her öğe arasında daha fazla boşluk
                       
                       Picker("Please choose a filter", selection: $selectedDateFilter) {
                                      ForEach(dateFilters, id: \.self) {
                                          Text($0.text)
                                      }
                                  }
                       .onChange(of:selectedDateFilter) { newValue in
                           let request = AF.request(
                            "\(APIConfig.apiUrl)/expense/filter?period=\(selectedDateFilter.key)&category=\(selectedCategory._id)", encoding: JSONEncoding.default
                           ).responseDecodable(of: [ExpenseModel].self) { response in

                               expenses = response.value ?? []
                           }
                                  }
                       Divider()
                       
                       Picker("Please choose a category", selection: $selectedCategory) {
                                      ForEach(categories, id: \.self) {
                                          Text($0.name)
                                      }
                                  }
                       .onChange(of:selectedCategory) { newValue in
                           let request = AF.request(
                            "\(APIConfig.apiUrl)/expense/filter?period=\(selectedDateFilter.key)&category=\(selectedCategory._id)", encoding: JSONEncoding.default
                           ).responseDecodable(of: [ExpenseModel].self) { response in

                               expenses = response.value ?? []
                           }
                                  }
                       
                       Divider()
                       
                       TextField("Min: ", text: $minAmount)
                           .padding()
                       
                       TextField("Max: ", text: $maxAmount)
                           .padding()
                       
                       Button("Search"){
                           
                       }
                       
                       
                       
                       ForEach(expenses, id: \._id) { item in
                           ZStack {
                               RoundedRectangle(cornerRadius: 20)
                                   .fill(LinearGradient(
                                       gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing
                                   ))
                                   .shadow(radius: 5)  // Gölge etkisi
                               
                               VStack(alignment: .leading, spacing: 12) {
                                   HStack {
                                       Text(item.description)
                                           .font(.title3)
                                           .bold()
                                           .foregroundColor(.white)

                                       Spacer()

                                       Text(String(format: "%.2f ₺", item.amount))
                                           .font(.title3)
                                           .foregroundColor(.yellow.opacity(1))
                                           .bold()
                                   }

                                   HStack {
                                       Text("Category:")
                                           .font(.subheadline)
                                           .foregroundColor(.white.opacity(0.8))

                                       Text(item.category.name)
                                           .font(.subheadline)
                                           .foregroundColor(.yellow)
                                           .bold()
                                   }
                                   
                                   Text(DateHelper.formatDate(item.date))
                                       .font(.footnote)
                                       .foregroundColor(.white.opacity(0.8))
                               }
                               
                               .padding(16)
                           }
                           
                           .frame(height: 120)  // Kartların yüksekliği
                       }
                   }
               }
                   .navigationBarItems(trailing: Button(action: {
                       // Butona basıldığında herhangi bir işlem yapılmıyor
                       print("Add Expense butonuna basıldı")
                   }) {
                       Text("Add Expense")
                           .foregroundColor(.blue)  
                   })
        }
        /*ScrollView{
            VStack{

                ForEach(expenses, id:\._id){item in
                    Text("\(item.description) \(item.amount) \(item.category.name)")
                        .padding()

                    Text(item.date)
                        .padding()
                }*/
        .onAppear {
            AF.request(
                "\(APIConfig.apiUrl)/expense/filter?period=today", encoding: JSONEncoding.default
            ).responseDecodable(of: [ExpenseModel].self) { response in

                expenses = response.value ?? []
                print(expenses)
                
                AF.request(
                    "\(APIConfig.apiUrl)/category", encoding: JSONEncoding.default
                ).responseDecodable(of: [CategoryPickerModel].self) { response in

                    categories = response.value ?? []
                }
            }
            
           
        }
    }
    


}

#Preview {
    ExpenseMainScreen()
}



struct DateFilterModel : Hashable{
    var key : String = ""
    var text : String = ""
}


struct CategoryPickerModel : Codable, Hashable{
    var _id : String = ""
    var name : String = ""
}
