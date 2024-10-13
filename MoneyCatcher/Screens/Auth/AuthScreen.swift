//
//  AuthScreen.swift
//  MoneyCatcher
//
//  Created by Çağatay Yıldız on 18.09.2024.
//

import Alamofire
import SwiftUI

struct AuthScreen: View {
    @State private var email = ""
    @State var isActive: Bool = false
    @State var goHome: Bool = false
    @ObservedObject var loginManager: LoginManager
    @State private var showAlert: Bool = false
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                Text("Login")
                    .font(.largeTitle)
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                
                Button(action: {
                    let user: [String: Any] = [
                        "email": email
                        
                    ]
                    
                    if isValidEmail(email) {
                        // Email geçerli, bir sonraki adıma geç
                        AF.request(
                            "\(APIConfig.apiUrl)/auth", method: .post,
                            parameters: user, encoding: JSONEncoding.default
                        ).responseDecodable(of: RegisterModel.self) {
                            response in
                            
                            UserDefaults.standard.setValue(
                                email, forKey: "email")
                            isActive = true
                        }
                        
                    } else {
                        // Email geçersiz ise hata göster
                        showAlert = true
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
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Invalid Email"),
                        message: Text("Lütfen email formatında bir veri giriniz."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                Divider()
                
                Button("Google ile auth") {
                    Task {
                        var result = try await GoogleSignInManager.shared
                            .signInWithGoogle()
                        
                        let user: [String: Any] = [
                            "email": result?.profile?.email
                        ]
                        
                        AF.request(
                            "\(APIConfig.apiUrl)/login/gmail", method: .post,
                            parameters: user, encoding: JSONEncoding.default
                        ).responseDecodable(of: GoogleLoginResponseModel.self) { response in
                            if response.response?.statusCode == 200 {
                                UserDefaults.standard.setValue(
                                    email, forKey: "email")
                                goHome = true
                                loginManager.isLoggedIn = true
                            }
                            
                        }
                        
                    }
                }
                
                Button("Logout") {
                    Task {
                        try await GoogleSignInManager.shared.signOutFromGoogle()
                    }
                }
                NavigationLink(
                    destination: ConfirmCodeScreen(loginManager: LoginManager())
                        .navigationBarBackButtonHidden(true),
                    isActive: $isActive
                ) {
                    EmptyView()
                }
                
                NavigationLink(
                    destination: TabMain(loginManager: loginManager)
                        .navigationBarBackButtonHidden(true), isActive: $goHome
                ) {
                    EmptyView()
                }
                .padding()
            }
            
        }
    }
}

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailPredicate.evaluate(with: email)
}

struct RegisterModel: Codable {
    var email: String
    var confirmCode: String
}

struct GoogleLoginResponseModel: Codable {
    var id: String = ""
}
#Preview {
    AuthScreen(loginManager: LoginManager())
}
