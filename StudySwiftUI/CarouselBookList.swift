//
//  CarouselBookList.swift
//  StudySwiftUI
//
//  Created by peter on 2023/06/16.
//

import SwiftUI

struct Book: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var title: String
    var color: Color
    var author: String
    var rating: Int
    var bookViews: Int
}

var tags: [String] = [
    "History", "Classical", "Biography", "Cartoon", "Adventure", "Fairy tales", "Fantasy"
]

var colors: [Color] = [.pink, .red, .yellow, .green, .blue]
var sampleBooks: [Book] = colors.indices.map { index in
    Book(title: colors[index].description, color: colors[index], author: "\(colors[index].description)\(colors[index].description)\(colors[index].description)", rating: 9, bookViews: 2024)
}

struct CarouselBookList: View {
    var body: some View {
        CarouselBookListHome()
            .preferredColorScheme(.light)
    }
}

struct CarouselBookListHome: View {
    @State private var activeTag: String = "Biography"
    @State private var carouselMode: Bool = false
    
    /// For Matched Geometry Effect
    /// To make the Tab indicator run smoothly, we need to add a matched geometry effect.
    ///  In order to add a matched geometry effect, we need an animation namespace.
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Browse")
                    .font(.largeTitle.bold())
                
                Text("Recommended")
                    .fontWeight(.semibold)
                    .padding(.leading, 15)
                    .foregroundColor(.gray)
                    .offset(y: 2)
                
                Spacer(minLength: 10)
                
                Menu {
                    Button("Toggle Carousel Mode \(carouselMode ? "Off" : "On")") { carouselMode.toggle() }
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.init(degrees: -90))
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            
            TagViews()
            
            GeometryReader {
                let size = $0.size
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 30) {
                        ForEach(sampleBooks) { BookCardView($0) }
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 20)
                    .padding(.bottom, bottomPadding(size))
                    .background {
                        ScrollViewDetector(carouselMode: $carouselMode, totalCardCount: sampleBooks.count)
                    }
                }
                /// Since we need offset from here not  from global View.
                .coordinateSpace(name: "SCROLLVIEW")
            }
            .padding(.top, 15)
        }
    }
    
    /// Bottom Padding for last card to move up to the top
    func bottomPadding(_ size: CGSize = .zero) -> CGFloat {
        let cardHeight: CGFloat = 220
        let scrollViewHeight: CGFloat = size.height
        
        /// Thus, we need to show the last card.
        /// So we're removing one card's height from the scrollview total height
        ///
        ///  final -20 came from the vertical padding of 20, so if we remove the 40 (vertical padding 20).
        ///  then we will have the top stating point, which is 20.
        return scrollViewHeight - cardHeight - 40
    }
    
    @ViewBuilder
    func BookCardView(_ book: Book) -> some View {
        GeometryReader {
            let size = $0.size
            let rect = $0.frame(in: .named("SCROLLVIEW"))
            
            HStack(spacing: -25) {
                // MARK: Book Detail Card
                VStack(alignment: .leading, spacing: 6) {
                    Text(book.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("By \(book.author)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    RatingView(rating: book.rating)
                        .padding(.top, 10)
                    
                    Spacer(minLength: 10)
                    
                    HStack(spacing: 4) {
                        Text("\(book.bookViews)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                        
                        Text("Views")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer(minLength: 0)
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(20)
                .frame(width: size.width / 2, height: size.height * 0.8)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 5, y: 5)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: -5, y: -5)
                }
                .zIndex(1)
                
                // MARK: Book Cover Image
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(book.color)
                        .frame(width: size.width / 2, height: size.height)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                }
            }
            .frame(width: size.width)
            .rotation3DEffect(.init(degrees: convertOffsetToRotation(rect)), axis: (x: 1, y: 0, z: 0), anchor: .bottom, anchorZ: 1, perspective: 0.8)
        }
        .frame(height: 220)
    }
    
    func convertOffsetToRotation(_ rect: CGRect) -> CGFloat {
        let cardHeight = rect.height + 20
        let minY = rect.minY - 20
        
        /// As we don't want to do any rotation for any other cards, we only need to do with the first one.
        /// So when the offset goes beyond zero, we're applying rotation animation to the card.
        let progress = minY < 0 ? (minY / cardHeight) : 0
        /// Limiting progress from 0 to 1, since our offset is a negative value, thus converting it into a positive one.
        let constrainedProgress = min(-progress, 1.0)
        return constrainedProgress * 90
    }
    
    @ViewBuilder
    func TagViews() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background {
                            if activeTag == tag {
                                Capsule().fill(Color.blue)
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            } else {
                                Capsule().fill(.secondary.opacity(0.3))
                            }
                        }
                        .foregroundColor(activeTag == tag ? .white : .secondary)
                        .onTapGesture {
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)) {
                                activeTag = tag
                            }
                        }
                }
            }
            .padding(.horizontal, 15)
        }
    }
}

struct RatingView: View {
    var rating: Int
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundColor(index <= rating ? .yellow : .gray.opacity(0.5))
            }
            
            Text("(\(rating))")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.yellow)
                .padding(.leading, 5)
        }
    }
}

struct ScrollViewDetector: UIViewRepresentable {
    @Binding var carouselMode: Bool
    var totalCardCount: Int
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView {
                scrollView.decelerationRate = carouselMode ? .fast : .normal
                if carouselMode {
                    scrollView.delegate = context.coordinator
                } else {
                    scrollView.delegate = nil
                }
                
                /// Updating Total Count in real time
                context.coordinator.totalCount = totalCardCount
            }
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ScrollViewDetector
        init(parent: ScrollViewDetector) {
            self.parent = parent
        }
        
        var totalCount: Int = 0
        var velocityY: CGFloat = 0
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            let cardHeight: CGFloat = 220
            /// Since each card has a spacing, we need to add that to the content offset.
            let cardSpacing: CGFloat = 35
            /// Adding velocity for more natural feel
            let targetEnd: CGFloat = scrollView.contentOffset.y + (velocity.y * 60)
            let index = (targetEnd / cardHeight).rounded()
            let modifiedEnd = index * cardHeight
            let spacing = cardSpacing * index
            
            if !scrollView.isDecelerating {
                targetContentOffset.pointee.y = modifiedEnd + spacing
            }
            velocityY = velocity.y
        }
        
        /// I can notice that there is some glitch in the scroll animation.
        /// That'sw happening because somethimes scrollview can decelerate that it's ending, so we need to address that too.
        func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
            /// Removing Invalid Scroll Position's
            
            let cardHeight: CGFloat = 220
            /// Since each card has a spacing, we need to add that to the content offset.
            let cardSpacing: CGFloat = 35
            /// Adding velocity for more natural feel
            let targetEnd: CGFloat = scrollView.contentOffset.y + (velocityY * 60)
            let index = max(min((targetEnd / cardHeight).rounded(), CGFloat(totalCount - 1)), 0.0) /// Should limit its index range from 0 tot he last card index.
            let modifiedEnd = index * cardHeight
            let spacing = cardSpacing * index
             
            scrollView.setContentOffset(.init(x: 0, y: modifiedEnd + spacing), animated: true)
        }
    }
}

struct CarouselBookList_Previews: PreviewProvider {
    static var previews: some View {
        CarouselBookList()
    }
}
