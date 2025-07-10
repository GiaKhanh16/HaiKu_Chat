import SwiftUI

struct ProfilePage: View {
	 @EnvironmentObject var auth: authCenter

	 var firstName: String {
			let fullName = auth.userSession?.displayName ?? ""
			return fullName.components(separatedBy: " ").first ?? ""
	 }

	 var body: some View {
			Text("hello \(firstName)")
			Button {
				 auth.signOut()
			} label: {
				 Text("Logout")
			}
	 }
}
