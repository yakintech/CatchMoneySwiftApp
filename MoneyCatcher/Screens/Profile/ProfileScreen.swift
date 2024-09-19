//
//  ProfileScreen.swift
//  MoneyCatcher
//
//  Created by Çağatay Yıldız on 18.09.2024.
//

import SwiftUI

struct ProfileScreen: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = true  // Oturum durumunu kontrol eder
        
        var body: some View {
            VStack {
                Text("Profile Screen")
                    .font(.title2)
                    .padding()
                
                Button(action: {
                    isLoggedIn = false  // Oturumdan çıkıldığında bu değeri false yapar
                }) {
                    Text("Logout")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
}

#Preview {
    ProfileScreen()
}
