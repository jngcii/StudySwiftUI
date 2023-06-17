//
//  CalendarAccountBook.swift
//  StudySwiftUI
//
//  Created by peter on 2023/06/17.
//

import SwiftUI

// MARK: UserModel and sample data
struct User: Identifiable {
    var id = UUID().uuidString
    var name: String
    var image: String
    var type: String
    var amount: String
    var color: Color
}

var users: [User] = [
    User(name: "iPeter", image: "User1", type: "Received", amount: "+$35", color: Color.orange),
    User(name: "iJustine", image: "User2", type: "Sent", amount: "-$120", color: Color.black),
    User(name: "iJune", image: "User3", type: "Rejected", amount: "-$20", color: Color.red),
    User(name: "iStewie", image: "User4", type: "Received", amount: "+$40", color: Color.orange)
]

struct CalendarAccountBook: View {
    // MARK: Animation Properties
    @State private var animatedStates: [Bool] = Array(repeating: false, count: 3)
    
    // MARK: currentDate for calendar
    @State private var currentDate: Date = Date()
    
    // Hero Effect
    @Namespace var animation
    
    var body: some View {
        ZStack {
            // If we hide the view while its transitioning, it will give some opacity change in the views
            
            // Ignore the warning since the view is anyway going to be removed later
            if !animatedStates[1] {
                RoundedRectangle(cornerRadius: animatedStates[0] ? 30 : 0, style: .continuous)
                    .fill(Color("Purple"))
                    .matchedGeometryEffect(id: "DATEVIEW", in: animation)
                    .ignoresSafeArea()
                
                // Splash Logo
                Image("LOGO")
                    .scaleEffect(animatedStates[0] ? 0.25 : 1)
                    .matchedGeometryEffect(id: "SPLASHLOGO", in: animation)
            }
            
            if animatedStates[0] {
                // MARK: HOME View
                VStack(spacing: 0) {
                    
                    // MARK: Nav Bar
                    Button(action: {}) {
                        Image(systemName: "rectangle.leadinghalf.inset.filled")
                            .font(.title3)
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .overlay {
                        Text("All debts")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .padding(.bottom, 30)
                    
                    // Custom Calendar
                    CustomDatePickerV02(currentDate: $currentDate)
                        .overlay(alignment: .topLeading) {
                            Image("LOGO")
                                .scaleEffect(0.25)
                                .matchedGeometryEffect(id: "SPLASHLOGO", in: animation)
                                .offset(x: -65, y: -127)
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .fill(Color("Purple"))
                                .matchedGeometryEffect(id: "DATEVIEW", in: animation)
                        }
                    
                    // MARK: Users ScrollView
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            ForEach(users) { user in
                                // MARK: User Card View
                                UserCardView(user: user, index: getIndex(user: user))
                            }
                        }
                        .padding(.vertical)
                        .padding(.top, 30)
                    }
                }
                .padding([.horizontal, .top])
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .onAppear(perform: startAnimation)
    }
    
    func getIndex(user: User) -> Int {
        return users.firstIndex { $0.id == user.id } ?? 0
    }
    
    func startAnimation() {
        // MARK: Displaying Splash Icon from Some Time
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.7, blendDuration: 0.7)) {
                animatedStates[0] = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            animatedStates[1] = true
        }
    }
}

struct UserCardView: View {
    var user: User
    var index: Int
    
    @State var showView: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(user.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 8) {
                Text(user.name)
                    .fontWeight(.bold)
                
                Text(user.type)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(user.amount)
                .font(.title3.bold())
                .foregroundColor(user.color)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background {
            RoundedRectangle(cornerRadius: 35, style: .continuous)
                .stroke(.gray.opacity(0.2), lineWidth: 1)
        }
        .offset(y: showView ? 0 : 450)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5).delay(Double(index) * 0.1)) {
                self.showView = true
            }
        }
    }
}

struct CalendarAccountBook_Previews: PreviewProvider {
    static var previews: some View {
        CalendarAccountBook()
    }
}
