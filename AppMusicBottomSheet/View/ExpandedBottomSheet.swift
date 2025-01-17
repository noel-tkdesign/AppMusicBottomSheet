//
//  ExpandedBottomSheet.swift
//  AppMusicBottomSheet
//
//  Created by Koji Kawakami on 2024/07/04.
//

import SwiftUI

struct ExpandedBottomSheet: View {
    @Binding var expandSheet: Bool
    var animation : Namespace.ID
    /// View Properties
    @State private var animateContent: Bool = false
    @State private var offsetY : CGFloat = 0
    var body: some View {
        GeometryReader{
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack{
                /// Making it as Rouded Rectangle with Device Corner Radius
                RoundedRectangle(cornerRadius: animateContent ? deviveCornerRadius : 0,style: .continuous)
                    .fill(.ultraThickMaterial)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: animateContent ? deviveCornerRadius : 0,style: .continuous)
                            .fill(Color("BG"))
                            .opacity(animateContent ? 1 : 0)
                    })
                    .overlay(alignment: .top){
                        MusicInfo(expandSheet: $expandSheet, animation: animation)
                        /// Disabling Interaction (Sine it's not Necessary Here)
                            .allowsHitTesting(false)
                            .opacity(animateContent ? 0 : 1)
                    }
                    .matchedGeometryEffect(id: "BGVIEW", in: animation)
                
                VStack(spacing: 15){
                    /// Grab Indicator
                    Capsule()
                        .fill(.gray)
                        .frame(width: 40,height: 5)
                        .opacity(animateContent ? 1 : 0)
                         /// Mathing with Slide Animation
                        .offset(y: animateContent ? 0 : size.height)
                    
                    /// Artwork Hero View
                    GeometryReader {
                        let size = $0.size
                        
                        Image("Artwork")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width,height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: animateContent ? 15 : 5, style: .continuous))
                    }
                    .matchedGeometryEffect(id: "ARTWORK", in: animation)
                    /// For squre Artwork Image
                    .frame(height: size.width - 50)
                    /// For Smaller Devices the Padding will be 10 amd larger devices the padding will be 30
                    .padding(.vertical,size.height < 700 ? 10 : 30)
                    
                    ///Player View
                    PlayerView(size)
                    /// Noving it From Bottom
                        .offset(y: animateContent ? 0 : size.height)
                }
                .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
                .padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
                .padding(.horizontal, 25)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .clipped()
                /// For Testing UI
            }
            .contentShape(Rectangle())
            .offset(y: offsetY)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let translationY  = value.translation.height
                        offsetY = (translationY > 0 ? translationY :0)
                    }).onEnded({ value in
                        withAnimation(.easeInOut(duration: 0.3)){
                            if offsetY > size.height * 0.4 {
                                expandSheet = false
                                animateContent = false
                                
                            }else{
                                offsetY = .zero
                            }
                        }
                    })
            )
            .ignoresSafeArea(.container, edges: .all)
        }
     
        .onAppear{
            withAnimation(.easeInOut(duration: 0.35)){
                animateContent = true
            }
        }
    }
    
    @ViewBuilder
    func PlayerView(_ mainSize: CGSize) -> some View{
        GeometryReader{
            let size = $0.size
            /// Dynamic Spacing Using Available Heght
            let spacing = size.height * 0.04
            
            /// Sizing it  for more Compact look
            VStack(spacing: spacing){
                VStack(spacing: spacing){
                    HStack(alignment: .center, spacing: 15){
                        VStack(alignment: .leading, spacing: 4){
                            Text("『ウマ娘 プリティーダービー』WINNING LIVE 19")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text("ウマ娘")
                                .foregroundStyle(.gray)
                        }
                        .frame(maxWidth: .infinity,alignment: .leading)
                        
                        Button{
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                                .padding(12)
                                .background {
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .environment(\.colorScheme, .light)
                                }
                        }
                    }
                    
                    /// Timing Indicator
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .environment(\.colorScheme, .light)
                        .frame(height: 5)
                        .padding(.top,spacing)
                    
                    /// Timing View
                    HStack{
                        Text("0:00")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer(minLength: 0)
                        
                        Text("3:33")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                /// Moving it to Top
                .frame(height: size.height / 2.5, alignment: .top)
                
                /// Playback Controls
                HStack(spacing: size.width * 0.18){
                    Button{
                        
                    } label: {
                        Image(systemName: "backward.fill")
                         /// Dynamic sizing for Smaller to Larger iphones
                             .font(size.height < 300 ? .title3 : .title)
                    }
                    
                    /// Making Play/Pause Little Bigger
                    Button{
                        
                    } label: {
                        Image(systemName: "pause.fill")
                         /// Dynamic sizing for Smaller to Larger iphones
                            .font(size.height < 300 ? .largeTitle: .system(size: 50))
                    }
                    Button{
                        
                    } label: {
                        Image(systemName: "forward.fill")
                         /// Dynamic sizing for Smaller to Larger iphones
                             .font(size.height < 300 ? .title3 : .title)
                    }
                }
                .foregroundColor(.white)
                .frame(maxHeight: .infinity)
                
                /// Volume & Other controls
                VStack(spacing: spacing){
                    HStack(spacing: 15){
                        Image(systemName: "speaker.fill")
                            .foregroundColor(.gray)
                        
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .environment(\.colorScheme, .light)
                            .frame(height: 5)
                        
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundColor(.gray)
                    }
                    
                    HStack(alignment: .top, spacing: size.width * 0.13){
                        Button{
                            
                        } label: {
                            Image(systemName: "quote.bubble")
                                .font(.title2)
                        }
                        VStack(spacing: 6){
                            Button{
                                
                            } label: {
                                Image(systemName: "airpods.gen3")
                                    .font(.title2)
                            }
                            Text("iJustine's Airpods")
                                .font(.caption)
                        }
                        Button{
                            
                        } label: {
                            Image(systemName: "list.bullet")
                                .font(.title2)
                        }
                    }
                    .foregroundColor(.white)
                    .blendMode(.overlay)
                    .padding(.top,spacing)
                }
                ///Moving  it to bottom
                .frame(height: size.height / 2.5, alignment: .bottom)
            }
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}

extension View{
    var deviveCornerRadius : CGFloat{
        let key = "_displayCornerRadius"
        if let screen = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.screen {
            if let cornerRadius = screen.value(forKey: key) as? CGFloat{
                return cornerRadius
            }
            return 0
        }
        return 0
    }
}
