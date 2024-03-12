//
//  ContentView.swift
//  iRecipe
//
//  Created by Feihuan Peng on 3/9/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = DataViewModel()
    
    var body: some View {
//        DebugView(vm: vm) 
        
        
        TabView{
            HomeView(vm: vm)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            SettingView(vm: vm)
                .tabItem {
                    Label("Setting", systemImage: "gearshape")
                }
            DebugView(vm: vm)
                .tabItem {
                    Label("Debug", systemImage: "ant.circle")
                }// comment out this
        }
        .accentColor(.black)
        
        
        
    }
}

#Preview {
    ContentView()
}

