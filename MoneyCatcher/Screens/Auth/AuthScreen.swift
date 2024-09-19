//
//  AuthScreen.swift
//  MoneyCatcher
//
//  Created by Çağatay Yıldız on 18.09.2024.
//

import SwiftUI

struct AuthScreen: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    var body: some View {
        if isLoggedIn {
            TabMain()
            //ConfirmCodeScreen()  // Giriş yapıldıktan sonra gösterilecek ana sayfa
        } else {
            LoginOrRegisterView()  // Giriş veya kayıt ekranı
        }
    }
}

struct LoginOrRegisterView: View {
    @State private var showRegister = false
    
    var body: some View {
        VStack {
            if showRegister {
                RegisterView()
            } else {
                LoginView()
            }
            
            Button(action: {
                showRegister.toggle()  // Arada geçiş yapmak için buton
            }) {
                Text(showRegister ? "Already have an account? Login" : "Don't have an account? Register")
                    .foregroundColor(.blue)
                    .padding()
            }
        }
    }
}

struct LoginView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                // Giriş işlemleri
                isLoggedIn = true
            }) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .padding()
    }
}

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            Text("Register")
                .font(.largeTitle)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                // Kayıt işlemleri
            }) {
                Text("Register")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .padding()
    }
}

struct MainView: View {
    var body: some View {
        Text("Welcome to the App!")
    }
}
#Preview {
    AuthScreen()
}
