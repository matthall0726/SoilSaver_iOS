//
//  DeviceRegistration.swift
//  SoilSaver
//
//  Created by Matt Hall on 2/24/24.
//

import Foundation
import SwiftUI
import Swift



struct DeviceRegistration: View {
    @State private var isAnimating = false
    @State private var firstText = ""
    @State private var secondText = ""
    @State private var thirdText = ""
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.0, green: 0.39, blue: 0.0), Color.brown]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack {
                Text("Provisioning your device.")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).padding(.top, 35).padding(.bottom, 10)
                Text("This may take a few minutes.")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                
                Spacer()
            }
            
            VStack {
                HStack {
                    VStack {
                        
                        if !firstText.isEmpty {
                            Text(firstText).padding(.bottom, 10)
                        }
                        if !secondText.isEmpty {
                            Text(secondText).padding(.bottom, 10)
                        }
                        if !thirdText.isEmpty {
                            Text(thirdText).padding(.bottom, 10)
                        }
                    }
                }.onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            firstText = "Configuring wifi..."
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            secondText = "Configuring firebase authentication..."
                            
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            thirdText = "Configuring mqtt client..."
                        }
                    }
                }
            }
                Image(.loadingScreen)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 125, height: 125)
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                    .onAppear() {
                        isAnimating = true
                    }
                
            }
            Spacer()
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        DeviceRegistration()
//    }
//}
