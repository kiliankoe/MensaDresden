import Foundation
import SwiftUI

extension Binding {
    func `default`<T>(_ defaultValue: T) -> Binding<T> where Value == Optional<T> {
        Binding<T>(
            get: {
                wrappedValue ?? defaultValue
            },
            set: { newValue in
                wrappedValue = newValue
            }
        )
    }

    func didSet(_ didSet: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                didSet(newValue)
            }
        )
    }

//    func sideEffect(_ sideEffect: @escaping (Value) -> Void) -> Binding<Value> {
//        Binding<Value>(
//            get: {
//                wrappedValue
//            },
//            set: { newValue in
//                wrappedValue = newValue
//                sideEffect(newValue)
//            }
//        )
//    }
}
