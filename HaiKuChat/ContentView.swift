import SwiftUI

struct ContentView: View {
	 @State var authModel = googleAuth()

	 var body: some View {
			VStack {
				 if authModel.isSignedIn {
						TabBarView()
							 .transition(.opacity.combined(with: .scale))
				 } else {
						WelcomeView()
							 .transition(.opacity.combined(with: .scale))
				 }
			}
			.animation(.easeInOut(duration: 0.4), value: authModel.isSignedIn)
			.environmentObject(authModel)
	 }
}

#Preview {
	 ContentView()
}
