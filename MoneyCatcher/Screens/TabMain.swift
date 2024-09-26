//
//  TabMain.swift
//  MoneyCatcher
//
//  Created by Çağatay Yıldız on 18.09.2024.
//

import SwiftUI

struct TabMain: View {
    @ObservedObject var loginManager: LoginManager
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
            
            ReportsMainScreen()
                .tabItem {
                    Label("Reports", systemImage: "chart.pie")
                }
            
            ProfileScreen(loginManager: loginManager)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
            
        }
    }
}

#Preview {
    TabMain(loginManager: LoginManager())
}
