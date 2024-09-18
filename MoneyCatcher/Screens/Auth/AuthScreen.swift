//
//  AuthScreen.swift
//  MoneyCatcher
//
//  Created by Çağatay Yıldız on 18.09.2024.
//

import SwiftUI

struct AuthScreen: View {
    @State var email : String = ""
    var body: some View {
        VStack{
            TextField("EMail", text:$email)
                .padding()
            
            Button("Login or Register"){
                
            }
        }
    }
}

#Preview {
    AuthScreen()
}
