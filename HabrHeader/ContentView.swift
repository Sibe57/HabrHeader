//
//  ContentView.swift
//  HabrHeader
//
//  Created by Eronin Fedor NP on 25.05.2023.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            MainScreen(size: size, safeArea: safeArea)
                .ignoresSafeArea(.all, edges: .top)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
