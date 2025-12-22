import SwiftUI

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                HomeView()
                    .environmentObject(authViewModel)
            } else {
                SignInView(authViewModel: authViewModel)
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AuthViewModel())
}

