//
//  ProfileScreen.swift
//  MoneyCatcher
//
//  Created by Çağatay Yıldız on 18.09.2024.
//

import SwiftUI

struct ProfileScreen: View {
    @ObservedObject var loginManager: LoginManager
    @State var isActive = false
        
        var body: some View {
            NavigationView{
                VStack {
                    Text("Profile Screen")
                        .font(.title2)
                        .padding()
                    
                    Button(action: {
                        UserDefaults.standard.setValue("", forKey: "email")
                        loginManager.isLoggedIn = false
                        isActive = true
                        
                    }) {
                        Text("Logout")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                    
                    NavigationLink(destination: AuthScreen(loginManager: LoginManager()).navigationBarBackButtonHidden(true), isActive: $isActive){
                        EmptyView()
                    }
                }

            }
            
          
        }
}

#Preview {
    ProfileScreen(loginManager: LoginManager())
}
