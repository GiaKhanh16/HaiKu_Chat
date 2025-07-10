import SwiftUI
import FirebaseFirestore
import FirebaseAuth



struct ChatRoomStruct: Identifiable {
	 var id: String // documentID
	 var name: String
	 var participants: [String]
}


@Observable
class firestoreActions: ObservableObject {
	 var chatRooms: [ChatRoomStruct] = []
	 var errorMessage: String? = nil


	 var currentRoom: ChatRoomStruct? = nil

	 func createRoom(withName name: String, roomID: String) {
			guard let user = Auth.auth().currentUser else {
				 errorMessage = "❌ No user signed in"
				 return
			}

			let db = Firestore.firestore()
			let roomRef = db.collection("rooms").document(roomID)

			roomRef.getDocument { [weak self] snapshot, error in
				 guard let self = self else { return }

				 if let error = error {
						self.errorMessage = "❌ Error checking room: \(error.localizedDescription)"
						print(self.errorMessage!)
						return
				 }

				 if let snapshot = snapshot, snapshot.exists {
						self.errorMessage = "❌ Room ID already exists. Try again."
						print(self.errorMessage!)
						return
				 }

				 let roomData: [String: Any] = [
						"name": name,
						"createdBy": user.uid,
						"createdAt": Timestamp(),
						"participants": [user.uid]
				 ]

				 roomRef.setData(roomData) { error in
						if let error = error {
							 self.errorMessage = "❌ Error creating room: \(error.localizedDescription)"
							 print(self.errorMessage!)
						} else {
							 DispatchQueue.main.async {
									self.currentRoom = ChatRoomStruct(
										 id: roomID,
										 name: name,
										 participants: [user.uid]
									)
									print("✅ Room created with custom ID: \(roomID)")
							 }
						}
				 }
			}
	 }


	 func fetchRoomDetails(for roomID: String) {
			let db = Firestore.firestore()
			let roomRef = db.collection("rooms").document(roomID)

			roomRef.getDocument { [weak self] snapshot, error in
				 guard let self = self else { return }

				 if let error = error {
						self.errorMessage = "❌ Failed to fetch room: \(error.localizedDescription)"
						print(self.errorMessage!)
						return
				 }

				 guard let data = snapshot?.data() else {
						self.errorMessage = "❌ Room not found."
						print(self.errorMessage!)
						return
				 }

				 let name = data["name"] as? String ?? "Unknown Room"
				 let participants = data["participants"] as? [String] ?? []

				 DispatchQueue.main.async {
						self.currentRoom = ChatRoomStruct(id: roomID, name: name, participants: participants)
						print("✅ Room loaded: \(self.currentRoom?.name ?? "Unnamed")")
				 }
			}
	 }

	 func fetchRoomsCreatedByCurrentUser() {
			guard let user = Auth.auth().currentUser else {
				 self.errorMessage = "❌ No user signed in"
				 return
			}

			let db = Firestore.firestore()
			let roomsRef = db.collection("rooms")

			roomsRef.whereField("createdBy", isEqualTo: user.uid).getDocuments { snapshot, error in
				 if let error = error {
						self.errorMessage = "❌ Failed to fetch rooms: \(error.localizedDescription)"
						print(self.errorMessage!)
						return
				 }

				 guard let documents = snapshot?.documents else {
						self.errorMessage = "❌ No rooms found"
						print(self.errorMessage!)
						return
				 }

				 self.chatRooms = documents.compactMap { doc in
						let data = doc.data()
						guard let name = data["name"] as? String,
									let participants = data["participants"] as? [String] else {
							 return nil
						}
						return ChatRoomStruct(id: doc.documentID, name: name, participants: participants)
				 }

				 print("✅ Fetched \(self.chatRooms.count) rooms created by user.")
			}
	 }
}
