import SwiftUI

struct ContentView: View {
	 @EnvironmentObject var authModel: authCenter

	 var body: some View {
			Group {
				 if (authModel.userSession != nil) {
						TabBarView()
				 } else {
						WelcomeView()
				 }
			}
			.animation(.easeInOut(duration: 0.6), value: authModel.userSession)
	 }
}
