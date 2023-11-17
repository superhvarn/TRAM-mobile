import Foundation
import AppKit 
import SwiftUI

extension View {
    func standardButtonStyle() -> some View {
        self
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

