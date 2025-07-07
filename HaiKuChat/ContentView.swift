import SwiftUI

struct ContentView: View {
	 @State var authModel = googleAuth()

	 var body: some View {
			VStack {
				 TabBarView()
			}
//			.animation(.easeInOut(duration: 0.4), value: authModel.isSignedIn)
			.environmentObject(authModel)
	 }
}

#Preview {
	 ContentView()
}
//.transition(.opacity.combined(with: .scale))
//if authModel.isSignedIn {
//	 TabBarView()
//} else {
//	 WelcomeView()
//	 }
