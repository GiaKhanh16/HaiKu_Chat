import SwiftUI

struct RoomActionSheet: View {
	 @Environment(\.dismiss) private var dismiss
	 @Binding var actionSheet: Bool
	 @Binding var navigateToChatRoom: Bool
	 @State private var currentTab = "Create Room"
	 @State private var roomID = ""
	 @State private var roomName = ""

	 let tabs = ["Create Room", "Join Room"]

	 var body: some View {
			VStack(alignment: .leading, spacing: 24) {
				 Picker("", selection: $currentTab) {
						ForEach(tabs, id: \.self) { tab in
							 Text(tab)
						}
				 }
				 .pickerStyle(.segmented)

				 Group {
						if currentTab == "Join Room" {
							 VStack(alignment: .leading, spacing: 12) {
									TextField("Enter room's ID", text: $roomID)
										 .padding(.horizontal, 15)
										 .padding(.vertical, 10)
										 .background {
												ZStack {
													 Rectangle()
															.fill(.gray.opacity(0.2))

													 Rectangle()
															.fill(.ultraThinMaterial)
												}
												.clipShape(.rect(cornerRadius: 15))
										 }

									Button(action: {
										 dismiss()
										 DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
												navigateToChatRoom = true
										 }
									}, label: {
										 Text("Join Room")
												.fontWeight(.bold)
												.foregroundStyle(.white)
												.frame(maxWidth: .infinity)
												.padding(.vertical, 14)
												.background(
													 .blue.mix(with: .green, by: 0.5).gradient,
													 in: .rect(cornerRadius: 12)
												)
												.contentShape(.rect)
									})
							 }
						} else if currentTab == "Create Room" {
							 VStack(alignment: .leading, spacing: 12) {
									TextField("Enter room's name", text: $roomName)
										 .padding(.horizontal, 15)
										 .padding(.vertical, 10)
										 .background {
												ZStack {
													 Rectangle()
															.fill(.gray.opacity(0.2))

													 Rectangle()
															.fill(.ultraThinMaterial)
												}
												.clipShape(.rect(cornerRadius: 15))
										 }

									Button(
										 action: {
												dismiss()
												DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
													 navigateToChatRoom = true
												}
										 },
										 label: {
												Text("Create Room")
													 .fontWeight(.bold)
													 .foregroundStyle(.white)
													 .frame(maxWidth: .infinity)
													 .padding(.vertical, 14)
													 .background(
															.blue.mix(with: .green, by: 0.5).gradient,
															in: .rect(cornerRadius: 12)
													 )
													 .contentShape(.rect)
										 })
							 }
						}
				 }
				 .padding(.top)
				 Spacer()

			}
			.padding()
			.padding(.top, 30)
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
	 }
}

#Preview {
	 TabBarView()
}
