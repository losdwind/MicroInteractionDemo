//
//  ContentView.swift
//  popoo-ios-animation
//
//  Created by Losd wind on 2022/12/29.
//

import SwiftUI



struct ContentView: View {
    var body: some View{

        TabView {
            AppStoreAnimationView()
                .tabItem {
                    Text("Task 1")
                }
            TabBarView()
                .tabItem {
                    Text("Task 2")
                }
        }


    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
