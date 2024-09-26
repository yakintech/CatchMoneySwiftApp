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
    
    let dateFormatter: ISO8601DateFormatter = {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return formatter
        }()
        
        let displayFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM yyyy EEEE HH:mm"
            formatter.locale = Locale(identifier: "en_US")
            return formatter
        }()


    

    var body: some View {
        NavigationView {
        ScrollView {
                   VStack(spacing: 18) {  // Her öğe arasında daha fazla boşluk
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
                                   
                                   Text(formatDate(item.date))
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
            let request = AF.request(
                "\(APIConfig.apiUrl)/expense", encoding: JSONEncoding.default
            ).responseDecodable(of: [ExpenseModel].self) { response in

                expenses = response.value ?? []
                print(expenses)
            }
        }
    }
    
    func formatDate(_ dateString: String) -> String {
            if let date = dateFormatter.date(from: dateString) {
                return displayFormatter.string(from: date)
            } else {
                return dateString  // Eğer dönüştürülemiyorsa orijinal stringi gösterir
            }
        }

}

#Preview {
    ExpenseMainScreen()
}
