//
//  HomeScreen.swift
//  HabrHeader
//
//  Created by Eronin Fedor NP on 25.05.2023.
//

import SwiftUI

struct MainScreen: View {
    var size: CGSize
    var safeArea: EdgeInsets
    
    @State private var offsetY: CGFloat = .zero
    
    var body: some View {
        
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack {
                    createHeaderView()
                        .zIndex(1)
                    
                    createMainContent()
                }
                .id("mainScrollView")
                .background {
                    ScrollDetector { offset in
                        offsetY = -offset
                    } onDraggingEnd: { offset, velocity in
                        if needToScroll(offset: offset, velocity: velocity) {
                            withAnimation(.default) {
                                proxy.scrollTo("mainScrollView", anchor: .top)
                            }
                        }
                    }
                }
            }
        }
    }
    
    //данная функция создает эффект "инерции"
    private func needToScroll(offset: CGFloat, velocity: CGFloat) -> Bool {
        let headerHeight = (size.height * 0.25) + safeArea.top
        let minimumHeaderHeigth = 64 + safeArea.top
        
        let targetEnd = offset + (velocity * 45)
        
        return targetEnd < (headerHeight - minimumHeaderHeigth) && targetEnd > 0
    }
    
    //тут вся математика по расчету текущего положения/размера хедера и его контента
    @ViewBuilder
    private func createHeaderView() -> some View {
        let headerHeight = (size.height * 0.25) + safeArea.top
        let minimumHeaderHeigth = 64 + safeArea.top
        let progress = max(min(-offsetY / (headerHeight - minimumHeaderHeigth), 1), 0)
    
        GeometryReader { _ in
            ZStack {
                Rectangle()
                    .fill(Color("habrColor").gradient)
                
                VStack(spacing: 15) {
                    GeometryReader {
                        let rect = $0.frame(in: .global)
                        
                        let halfScaledHeight = (rect.height * 0.2) * 0.5
                        let midY = rect.midY
                        
                        let bottomPadding: CGFloat = 16
                        let reseizedOffsetY = (midY - (minimumHeaderHeigth - halfScaledHeight - bottomPadding))
                        
                        Image("habr")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: rect.width, height: rect.height)
                            .clipShape(Circle())
                            .foregroundColor(Color(.white))
                            .scaleEffect(1 - (progress * 0.5), anchor: .leading)
                            .offset(x: -(rect.minX - 16) * progress, y: -reseizedOffsetY * progress - (progress * 16))
                    }
                    .frame(width: headerHeight * 0.5, height: headerHeight * 0.5)
                    
                    Text("Привет, Хабр👋")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .scaleEffect(1 - (progress * 0.2))
                        .offset(y: -2 * progress)
                    
                }
                .padding(.top, safeArea.top)
                .padding(.bottom)
                
            }
            .shadow(color: .black.opacity(0.2), radius: 25)
            .frame(height: max((headerHeight + offsetY), minimumHeaderHeigth), alignment: .bottom)
            
        }
        .frame(height: headerHeight, alignment: .bottom)
        .offset(y: -offsetY)
    }
    
    @ViewBuilder
    func createMainContent() -> some View {
        VStack(spacing: 16) {
            ForEach(1...25, id: \.self) { num in
                ZStack {
                    HStack {
                        Circle()
                            .frame(height: 56)
                            .foregroundColor(Color("habrColor").opacity(0.1))
                        
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .foregroundColor(Color("habrColor").opacity(0.1))
                            .frame(height: 48)
                    }
                    .padding(.horizontal, 12)
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .foregroundColor(Color("habrColor").opacity(0.1))
                        .shadow(color: .black.opacity(0.2), radius: 5, y: 5)
                        .frame(height: 80)
                }
            }
        }
        .padding()
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
