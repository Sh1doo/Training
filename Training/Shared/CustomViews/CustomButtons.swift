import SwiftUI

struct TrainingMenuButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue100)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 5, x: 0, y: 5)
    }
}

struct StepperButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color.black)
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(in: RoundedRectangle(cornerRadius:10))
            .backgroundStyle(Color.white20)
    }
}
