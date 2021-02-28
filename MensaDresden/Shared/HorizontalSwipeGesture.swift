import SwiftUI

struct HorizontalSwipeGesture: ViewModifier {
    @State private var swipeStartPosition: CGPoint = .zero
    @State private var isSwiping = false

    var onSwipeLeft: () -> Void
    var onSwipeRight: () -> Void

    func body(content: Content) -> some View {
        content.gesture(DragGesture()
                    .onChanged { gesture in
                        if isSwiping {
                            swipeStartPosition = gesture.location
                            isSwiping.toggle()
                        }
                    }
                    .onEnded { gesture in
                        let xDist = abs(gesture.location.x - swipeStartPosition.x)
                        let yDist = abs(gesture.location.y - swipeStartPosition.y)
                        if swipeStartPosition.x > gesture.location.x && yDist < xDist {
                            onSwipeLeft()
                        }
                        else if swipeStartPosition.x < gesture.location.x && yDist < xDist {
                            onSwipeRight()
                        }
                        isSwiping.toggle()
                    }
        )
    }
}

extension View {
    func horizontalSwipeGesture(onSwipeLeft: @escaping () -> Void, onSwipeRight: @escaping () -> Void) -> some View {
        modifier(HorizontalSwipeGesture(onSwipeLeft: onSwipeLeft, onSwipeRight: onSwipeRight))
    }
}
