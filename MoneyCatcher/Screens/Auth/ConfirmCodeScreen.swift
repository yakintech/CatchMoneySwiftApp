//
//  ConfirmCodeScreen.swift
//  MoneyCatcher
//
//  Created by Çağatay Yıldız on 18.09.2024.
//

//4 tane karecik olacak
//kareler 1 deger alabilecek
//kareler rakam alacak

import SwiftUI
import Alamofire

struct ConfirmCodeScreen: View {
    @State private var code1: String = ""
    @State private var code2: String = ""
    @State private var code3: String = ""
    @State private var code4: String = ""
    @State private var isActive = false
    @ObservedObject var loginManager: LoginManager
    @FocusState private var isFirstFieldFocused: Bool // Focus state for the first text field
    @FocusState private var isSecondFieldFocused: Bool
    @FocusState private var isThirdFieldFocused: Bool
    @FocusState private var isFourthFieldFocused: Bool
    
    var body: some View {
        Text("VERIFICATION")
            .font(.title)
            .fontWeight(.bold)
        
            .padding()
            .padding()
            .padding()
        
        Text("Enter the 4-digit code sent to your email")
            //.padding()
            .foregroundColor(.black)
        VStack{
            
            HStack{
                TextField("", text: $code1)
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(height: 50)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .frame(width:50)
                    .focused($isFirstFieldFocused)
                    .keyboardType(.numberPad) // Set keyboard type to number pad
                    .onChange(of: code1) { newValue in
                        if newValue.count > 1 {
                            code1 = String(newValue.prefix(1)) // Keep only the first character
                        }
                        
                        if newValue.count == 1 {
                            code2 = ""
                            isSecondFieldFocused = true
                            isFirstFieldFocused = false
                            
                        }
                    }
                TextField("", text: $code2)
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(height: 50)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .frame(width:50)
                    .focused($isSecondFieldFocused)
                    .keyboardType(.numberPad)
                    .onChange(of: code2) { newValue in
                        // Limit input to one character
                        if newValue.count > 1 {
                            code2 = String(newValue.prefix(1))
                        }
                        // Dismiss the keyboard if a character is entered
                        if newValue.count == 1 {
                            code3 = ""
                            isThirdFieldFocused = true
                            isSecondFieldFocused = false
                            
                        }
                        if newValue.isEmpty {
                            isFirstFieldFocused = true
                            isSecondFieldFocused = false
                        }
                    }
            
                
                TextField("", text: $code3)
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(height: 50)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .frame(width:50)
                    .focused($isThirdFieldFocused)
                    .keyboardType(.numberPad)
                    .onChange(of: code3) { newValue in
                        // Limit input to one character
                        if newValue.count > 1 {
                            code3 = String(newValue.prefix(1))
                        }
                        // Dismiss the keyboard if a character is entered
                        if newValue.count == 1 {
                            code4 = ""
                            isFourthFieldFocused = true
                            isThirdFieldFocused = false
                        }
                        if newValue.isEmpty {
                            isSecondFieldFocused = true
                            isThirdFieldFocused = false// Focus back on the first text field
                        }
                    }

                
                TextField("", text: $code4)
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(height: 50)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .frame(width:50)
                    .focused($isFourthFieldFocused)
                    .keyboardType(.numberPad)
                    .onChange(of: code4) { newValue in
                        // Limit input to one character
                        if newValue.count > 1 {
                            code4 = String(newValue.prefix(1))
                        }
                        // Dismiss the keyboard if a character is entered
                        if newValue.count == 1 {
                            isFourthFieldFocused = false
                        }
                        if newValue.isEmpty {
                            isThirdFieldFocused = true
                            isFourthFieldFocused = false// Focus back on the first text field
                        }
                    }
            }
            
            .padding()
            Button(action :{
                
                let code = code1 + code2 + code3 + code4
                let email = UserDefaults.standard.string(forKey: "email")
                
                let confirmParameter : [String : Any] = [
                    "confirmCode": code,
                    "email":email
                ]
                
                AF.request("\(APIConfig.apiUrl)/confirm", method: .post, parameters: confirmParameter, encoding: JSONEncoding.default).responseDecodable(of:ConfirmCodeResponseModel.self ){response in
                    
                    if(response.response?.statusCode == 200){
                        print("Kullanıcı girişi başarılı")
                        isActive = true
                        loginManager.isLoggedIn = true
                    }
                    else{
                        print("Kullanıcı girişi hatalı!")
                    }
                }
                
                
            })    {
                Text("Verify")
                    .font(.title3)
                    .frame(width: 230)
                    .frame(height: 35)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            
            NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true), isActive: $isActive){
                EmptyView()
            }
            .onAppear {
                isFirstFieldFocused = true
            }
            .onTapGesture {
                isFirstFieldFocused = false
                isSecondFieldFocused = false
            }
        }

    }
}

#Preview
{
    ConfirmCodeScreen(loginManager: LoginManager())
}



struct ConfirmCodeResponseModel : Codable{
    var message : String = ""
}
