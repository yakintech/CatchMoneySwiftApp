//
//  AuthScreen.swift
//  MoneyCatcher
//
//  Created by Çağatay Yıldız on 18.09.2024.
//

import SwiftUI
import Alamofire


struct AuthScreen: View {
    @State private var email = ""
    @State var isActive : Bool = false
    @ObservedObject var loginManager: LoginManager
    
    var body: some View {
        
        NavigationView{
            VStack {
                
                
                
                Text("Login")
                    .font(.largeTitle)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
        
                
                Button(action: {
                    let user : [String : Any] = [
                        "email":email
                    ]
                    
                    
                    
                    
                    AF.request("\(APIConfig.apiUrl)/auth", method: .post, parameters: user, encoding: JSONEncoding.default).responseDecodable(of: RegisterModel.self){response in
                        
                        UserDefaults.standard.setValue(email, forKey: "email")
                        isActive = true
                    }
                    
                }) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                
                NavigationLink(destination: ConfirmCodeScreen(loginManager: LoginManager()).navigationBarBackButtonHidden(true), isActive: $isActive){
                    EmptyView()
                }
            }
            .padding()
        }
        
        

    }
}




struct RegisterModel : Codable{
    var email : String
    var confirmCode : String
}
