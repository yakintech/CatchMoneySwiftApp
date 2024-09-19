//
//  ContentView.swift
//  MoneyCatcher
//
//  Created by Çağatay Yıldız on 18.09.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var loginStatus = false
    
    var body: some View {
        
        if(loginStatus){
            TabMain()
        }
        else{
            AuthScreen()
        }
        
    }
}

#Preview {
    ContentView()
}
