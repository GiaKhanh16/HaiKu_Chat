import SwiftUI

struct ContentView: View {
	 @EnvironmentObject var authModel: googleAuth

	 var body: some View {
			Group {
				 if authModel.isSignedIn {
						TabBarView()
				 } else {
						WelcomeView()
				 }
			}
			.animation(.easeInOut(duration: 0.4), value: authModel.isSignedIn)
	 }
}
