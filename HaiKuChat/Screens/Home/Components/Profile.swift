import SwiftUI

struct ProfilePage: View {
	 @EnvironmentObject var auth: authCenter

	 var firstName: String {
			let fullName = auth.userSession?.displayName ?? ""
			return fullName.components(separatedBy: " ").first ?? ""
	 }

	 var body: some View {
			VStack {
						// Profile Header
				 VStack(spacing: 9) {
						Image(systemName: "person.circle.fill")
							 .resizable()
							 .frame(width: 100, height: 100)
							 .foregroundColor(.green)
						Text(firstName)
							 .font(.title)
						Text("mark.bronk@gmail.com")
							 .font(.subheadline)
							 .foregroundColor(.gray)
						Button(action: {}) {
							 Text("Edit profile")
									.font(.subheadline)
									.foregroundColor(.white)
									.padding(10)
									.background(.black)
									.cornerRadius(10)
						}
				 }
				 .padding()

				 Text("Inventories")
						.font(.footnote)
						.foregroundStyle(.gray)
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.horizontal)

				 VStack(alignment: .leading, spacing: 15) {
						HStack(spacing: 20) {
							 Image(systemName: "house.fill")
							 Text("My stores (2)")
							 Spacer()
							 Image(systemName: "chevron.right")
						}
						Divider()
						HStack(spacing: 20) {
							 Image(systemName: "questionmark.circle.fill")
							 Text("Support")
							 Spacer()
							 Image(systemName: "chevron.right")
						}
						Divider()
						HStack(spacing: 20) {
							 Image(systemName: "figure.run")
							 Button(action: {auth.signOut()}) {
									Text("Logout")
										 .foregroundColor(.red)
										 .frame(maxWidth: .infinity, alignment: .leading)
							 }
							 Spacer()
							 Image(systemName: "chevron.right")
						}

				 }
				 .padding()
				 .background(
						RoundedRectangle(cornerRadius: 30)
							 .fill(Color.gray.opacity(0.1))
				 )
				 .padding(.horizontal)
				 Spacer()
			}
	 }
}

