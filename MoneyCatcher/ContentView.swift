//
//  ContentView.swift
//  MoneyCatcher
//
//  Created by Çağatay Yıldız on 18.09.2024.
//

import SwiftUI
import Alamofire

class LoginManager: ObservableObject {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
}

struct ContentView: View {
    @StateObject private var loginManager = LoginManager()
    @State var loading = true
    
    var body: some View {
        
        VStack{
            if(loading == false){
                if(loginManager.isLoggedIn){
                    TabMain(loginManager: LoginManager())
                }
                else{
                    AuthScreen(loginManager: LoginManager())
                }
            }
            else{
                Text("Loading...")
            }
        }
        .onAppear(){
            
            let email = UserDefaults.standard.string(forKey: "email")
            
            let checkParameter : [String : Any] = [
                "email":email
            ]
            
            
            AF.request("https://walrus-app-hqcca.ondigitalocean.app/checkuser", method: .post, parameters: checkParameter, encoding: JSONEncoding.default).responseDecodable(of:CheckUserResponseModel.self ){response in
                
                if(response.response?.statusCode == 200){
                    loading = false
                    loginManager.isLoggedIn = true
                }
                else{
                    loading = false
                }
                
                
            }
            
        }
        
    }
}

#Preview {
    ContentView()
}
struct CheckUserResponseModel : Codable{
    var message : String = ""
}
