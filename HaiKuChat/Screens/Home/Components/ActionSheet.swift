import SwiftUI

struct RoomActionSheet: View {
	 @Environment(\.dismiss) private var dismiss
	 @Binding var actionSheet: Bool
	 @Binding var navigateToChatRoom: Bool
	 @State private var currentTab = "Create Room"
	 @State private var roomID = ""
	 @State private var roomName = ""
	 @State private var roomNameError: String?

	 @EnvironmentObject var firestore: firestoreActions

	 let tabs = ["Create Room", "Join Room"]

	 func generateShortID() -> String {
			let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
			return String((0..<6).compactMap { _ in characters.randomElement() })
	 }

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
										 firestore.joinRoom(withID: roomID)
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

									if let error = roomNameError {
										 Text(error)
												.font(.caption)
												.foregroundColor(.red)
												.transition(.opacity)
									}

									Button(
										 action: {
												let trimmed = roomName.trimmingCharacters(in: .whitespacesAndNewlines)
												if trimmed.isEmpty {
													 roomNameError = "Room name can't be empty."
												} else if trimmed.count > 20  {
													 roomNameError = "Room name is too long (max 25 characters)."
												} else {
													 roomNameError = nil
													 firestore.createRoom(withName: trimmed, roomID: generateShortID())
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
			.onChange(of: firestore.currentRoom) { _, newRoom in
				 if let id = newRoom?.id {
						print("🟢 Room created and ready: \(id)")
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
							 withAnimation(.easeInOut) {
									dismiss()
									navigateToChatRoom = true
							 }
						}
				 }
			}
	 }
}

#Preview {
	 TabBarView()
}
