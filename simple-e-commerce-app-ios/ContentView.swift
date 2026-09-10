//
//  ContentView.swift
//  simple-e-commerce-app-ios
//
//  Created by Laurentius Brandon Vikario on 03/09/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View {
        Group {
            if sessionManager.isAuthenticated {
                MainTabView()
            } else {
                LoginView()
            }
        }  
        .animation(.default, value: sessionManager.isAuthenticated)
    }
}

#Preview {
    ContentView()
        .environmentObject(SessionManager())
}
