//
//  TabMain.swift
//  MoneyCatcher
//
//  Created by Çağatay Yıldız on 18.09.2024.
//

import SwiftUI

struct TabMain: View {
    var body: some View {
        
        TabView{
            
            ExpenseMainScreen()
                .tabItem {
                    Label("Expense", systemImage: "list.dash")
                }
            
            IncomeMainScreen()
                .tabItem {
                    Label("Income", systemImage: "square.and.pencil")
                }
            
            ProfileScreen()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
            
        }
    }
}

#Preview {
    TabMain()
}
