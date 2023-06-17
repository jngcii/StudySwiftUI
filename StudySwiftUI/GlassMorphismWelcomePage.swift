//
//  GlassMorphismWelcomePage.swift
//  StudySwiftUI
//
//  Created by peter on 2023/06/17.
//

import SwiftUI

struct GlassMorphismWelcomePage: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue, .indigo],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Glass Background
            GeometryReader {
                let size = $0.size
                
                // Slightly Darkening
                Color.black
                    .opacity(0.7)
                    .blur(radius: 200)
                    .ignoresSafeArea()
                
                Circle()
                    .fill(.purple)
                    .padding(50)
                    .blur(radius: 120)
                    .offset(x: -size.width / 1.8, y: -size.height / 5)
                
                Circle()
                    .fill(.cyan)
                    .padding(50)
                    .blur(radius: 150)
                    .offset(x: size.width / 1.8, y: -size.height / 2)
                
                Circle()
                    .fill(.cyan)
                    .padding(50)
                    .blur(radius: 90)
                    .offset(x: size.width / 1.8, y: size.height / 2)
                
                Circle()
                    .fill(.purple)
                    .padding(100)
                    .blur(radius: 110)
                    .offset(x: size.width / 1.8, y: size.height / 2)
                
                Circle()
                    .fill(.purple)
                    .padding(100)
                    .blur(radius: 110)
                    .offset(x: -size.width / 1.8, y: size.height / 2)
            }
            
            VStack {
                
                Spacer(minLength: 10)
                
                // GlassMorphism Card ...
                ZStack {
                    
                    Circle()
                        .fill(Color.purple)
                        .blur(radius: 20)
                        .frame(width: 100, height: 100)
                        .offset(x: 120, y: -80)
                    
                    Circle()
                        .fill(Color.cyan)
                        .blur(radius: 40)
                        .frame(width: 100, height: 100)
                        .offset(x: -120, y: 100)
                    
                    GlassMorphismCard()
                }
                
                Spacer(minLength: 10)
                
                Text("Know Everything\nabout the weather")
                    .font(.system(size: UIScreen.main.bounds.height < 750 ? 30 : 40, weight: .bold))
                
                Text(getAttributedString)
                    .fontWeight(.semibold)
                    .kerning(1.1)
                    .padding(.top)
                
                Button(action: {}) {
                    Text("Get Started")
                        .font(.title3.bold())
                        .padding(.vertical, 22)
                        .frame(maxWidth: .infinity)
                        .background(
                            .linearGradient(
                                .init(colors: [.purple, .pink]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            in: RoundedRectangle(cornerRadius: 20)
                        )
                }
                
                Button(action: {}) {
                    Text("Already have an account?")
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
                .padding(.bottom)
            }
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding()
        }
    }
    
    // going to use AttributesString from iOS 15...
    var getAttributedString: AttributedString {
        var attrStr = AttributedString("Start now and learn more about \n local weather instantly")
        attrStr.foregroundColor = .gray
        
        if let range = attrStr.range(of: "local weather") {
            attrStr[range].foregroundColor = .white
        }
        
        return attrStr
    }
}

struct GlassMorphismCard: View {
    var body: some View {
        let width = UIScreen.main.bounds.width
        
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
                .opacity(0.1)
                .background(
                    Color.white
                        .opacity(0.08)
                        .blur(radius: 10)
                )
                .background {
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(
                            .linearGradient(
                                .init(colors: [.purple, .purple.opacity(0.5), .clear, .clear, .blue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2.5
                        )
                        .padding(2)
                }
                .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
            
            VStack {
                Image(systemName: "sun.max")
                    .font(.system(size: 75, weight: .thin))
                
                Text("26")
                    .font(.system(size: 85, weight: .bold))
                    .padding(.top, 2)
                    .overlay(
                        Text("°C")
                            .font(.title2)
                            .foregroundColor(Color.white.opacity(0.7))
                            .offset(x: 30, y: 15),
                        alignment: .topTrailing
                    )
                    .offset(x: -6)
                
                Text("Seoul, South Korea")
                    .foregroundColor(Color.white.opacity(0.4))
            }
        }
        .frame(width: width / 1.7, height: 270)
    }
}

struct GlassMorphismWelcomePage_Previews: PreviewProvider {
    static var previews: some View {
        GlassMorphismWelcomePage()
    }
}
