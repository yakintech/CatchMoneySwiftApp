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
    @State var goHome : Bool = false
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
                
                Divider()
                
                Button("Google ile auth"){
                    Task{
                      var result = try await GoogleSignInManager.shared.signInWithGoogle()
                    
                        
                        let user : [String : Any] = [
                            "email":result?.profile?.email
                        ]
                        
                    
                        AF.request("\(APIConfig.apiUrl)/login/gmail", method: .post, parameters: user, encoding: JSONEncoding.default).responseDecodable(of: GoogleLoginResponseModel.self){response in
                            if(response.response?.statusCode == 200){
                                UserDefaults.standard.setValue(email, forKey: "email")
                                goHome = true
                            }
                          
                        }
                        
                    }
                }
                
                Button("Logout"){
                    Task{
                        try await GoogleSignInManager.shared.signOutFromGoogle()
                    }
                }
                NavigationLink(destination: ConfirmCodeScreen(loginManager: LoginManager()).navigationBarBackButtonHidden(true), isActive: $isActive){
                    EmptyView()
                }
                
                NavigationLink(destination: TabMain().navigationBarBackButtonHidden(true), isActive: $goHome){
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



struct GoogleLoginResponseModel : Codable{
    var id : String = ""
}
