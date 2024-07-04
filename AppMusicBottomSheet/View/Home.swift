//
//  Home.swift
//  AppMusicBottomSheet
//
//  Created by Koji Kawakami on 2024/07/03.
//

import SwiftUI

struct Home: View {
    ///Animation Properties
    @State private var expandSheet: Bool = false
    @Namespace private var animation
    var body: some View {
      
        ///Tab View
        TabView{
            ListenNow()
                .tabItem {
                    Image(systemName: "play.circle.fill")
                    Text("Listen Now")
                }
                ///Changing Tab Backgrand Color
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(.ultraThickMaterial, for: .tabBar)
                ///Hiding Tab Bar When Sheet is Expanded
                .toolbar(expandSheet ? .hidden : .visible, for: .tabBar)
            SampleTab("Browse", "square.grid.2x2.fill")
            SampleTab("Radio", "dot.radiowaves.left.and.right")
            SampleTab("Music", "play.square.stack")
            SampleTab("Serach", "magnifyingglass")
        }
        ///Changing Tab Indicator Color
        .tint(.red)
        .safeAreaInset(edge: .bottom){
            CustomBottomSheet()
        }
        .overlay {
            if expandSheet {
                ExpandedBottomSheet(expandSheet: $expandSheet, animation: animation)
                ///Transtion for more fluent Animation
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y:-5)))
            }
        }
    }
    
    /// Custom Listen Now View
    @ViewBuilder
    func ListenNow() -> some View{
        NavigationStack{
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 20){
                    Image("Card1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Image("Card2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .padding()
                .padding(.bottom, 100)
            }
            .navigationTitle("Listen Now")
        }
    }
    
    @ViewBuilder
    func CustomBottomSheet() -> some View {
        /// Anmating Sheet Background (To Look Like It's Expanding from The Bottom)
        ZStack{
            if expandSheet {
                Rectangle()
                    .fill(.clear)
            }else {
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .overlay{
                        ///Music Info
                        MusicInfo(expandSheet: $expandSheet, animation: animation)
                    }
                    .matchedGeometryEffect(id: "BGVIEW", in: animation)
            }
        }
        .frame(height: 70)
        /// Separator Line
        .overlay(alignment: .bottom, content: {
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(height:1)
                .offset(y: -5)
        })
        /// 49: Default Tab Bar Height
        .offset(y: -49)
    }
    
    @ViewBuilder
    func SampleTab(_ title: String,_ icon: String) -> some View {
        /// ios Bug. It can be Avoided by wrappng the view inside ScrollView
        ScrollView(.vertical,showsIndicators: false, content: {
            Text(title)
                .padding(.top, 25)
        })
        .tabItem {
            Image(systemName: icon)
            Text(title)
        }
        ///Changing Tab Backgrand Color
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(.ultraThickMaterial, for: .tabBar)
        ///Hiding Tab Bar When Sheet is Expanded
        .toolbar(expandSheet ? .hidden : .visible, for: .tabBar)
    }
}

#Preview {
   ContentView()
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    
}

/// Resuble File
struct MusicInfo: View {
    @Binding var expandSheet: Bool
    var animation:Namespace.ID
    var body: some View {
        HStack(spacing:0){
            ///  Adding Matched Geometry Effect (Hero Animation)
            ZStack{
                if !expandSheet{
                    GeometryReader{
                        let size = $0.size
                        
                        Image("Artwork")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width,height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: expandSheet ? 15 : 5, style: .continuous))
                        
                    }
                    .matchedGeometryEffect(id: "ARTWORK", in: animation)
                }
            }
            
            .frame(width: 45,height: 45)
            
            Text("『ウマ娘 プリティーダービー』WINNING LIVE 19")
                .fontWeight(.semibold)
                .lineLimit(1)
                .padding(.horizontal, 15)
            
            Spacer(minLength: 0)
            
            Button{
                
            }label: {
                Image(systemName: "pause.fill")
                    .font(.title2)
            }
            Button{
                
            }label: {
                Image(systemName: "forward.fill")
                    .font(.title2)
            }
            .padding(.leading, 25)
        }
        .foregroundColor(.primary)
        .padding(.horizontal)
        .padding(.bottom,5)
        .frame(height: 70)
        .contentShape(Rectangle())
        .onTapGesture {
            /// Expanding Bottom Sheet
            withAnimation(.easeInOut(duration: 0.3)){
                expandSheet = true
            }
        }
    }
}
