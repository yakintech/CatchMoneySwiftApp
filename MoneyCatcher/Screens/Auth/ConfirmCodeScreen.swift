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

struct ConfirmCodeScreen: View {
    @State private var code1: String = ""
    @State private var code2: String = ""
    @State private var code3: String = ""
    @State private var code4: String = ""
    
    
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
                
                TextField("", text: $code2)
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(height: 50)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .frame(width:50)
                
                TextField("", text: $code3)
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(height: 50)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .frame(width:50)
                
                TextField("", text: $code4)
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(height: 50)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .frame(width:50)
            }
            
            .padding()
            Button(action :{
                print("Done.")
            })    {
                Text("Verify")
                    .font(.title3)
                    .frame(width: 230)
                    .frame(height: 35)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
        }

    }
}

#Preview
{
    ConfirmCodeScreen()
}
