import SwiftUI
import FirebaseFirestore
import FirebaseAuth



struct ChatRoomStruct: Identifiable, Equatable {
	 var id: String
	 var name: String
	 var participants: [String]
	 var messages: [MessageStruct]?
}

struct MessageStruct: Identifiable, Equatable {
	 var id: String
	 var senderID: String
	 var text_content: String
	 var timestamp: Date
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
									self.fetchRoomsCreatedByCurrentUser()
							 }
						}
				 }
			}
	 }

	 func joinRoom(withID roomID: String) {
			guard let user = Auth.auth().currentUser else {
				 self.errorMessage = "❌ No user signed in"
				 return
			}

			let db = Firestore.firestore()
			let roomRef = db.collection("rooms").document(roomID)

			roomRef.getDocument { [weak self] snapshot, error in
				 guard let self = self else { return }

				 if let error = error {
						self.errorMessage = "❌ Failed to fetch room: \(error.localizedDescription)"
						return
				 }

				 guard let data = snapshot?.data() else {
						self.errorMessage = "❌ Room not found."
						return
				 }

				 var participants = data["participants"] as? [String] ?? []

						// Check if user is already in the room
				 if participants.contains(user.uid) {
						print("✅ User already joined this room.")
						self.fetchRoomDetails(for: roomID) // Load room locally
						return
				 }

						// Add user to participants
				 participants.append(user.uid)
				 roomRef.updateData(["participants": participants]) { error in
						if let error = error {
							 self.errorMessage = "❌ Failed to join room: \(error.localizedDescription)"
						} else {
							 print("✅ Successfully joined the room.")
							 self.fetchRoomDetails(for: roomID)
							 self.fetchRoomsCreatedByCurrentUser()
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

			roomsRef.whereField("participants", arrayContains: user.uid)
				 .order(by: "createdAt", descending: true)
				 .getDocuments { snapshot, error in
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

extension firestoreActions {

	 private static var messageListener: ListenerRegistration?

	 func listenToMessages(for roomID: String) {
			let db = Firestore.firestore()

			firestoreActions.messageListener?.remove()

			firestoreActions.messageListener = db.collection("rooms")
				 .document(roomID)
				 .collection("messages")
				 .order(by: "timestamp")
				 .addSnapshotListener { [weak self] snapshot, error in
						guard let self = self else { return }

						if let error = error {
							 DispatchQueue.main.async {
									self.errorMessage = "❌ Realtime fetch failed: \(error.localizedDescription)"
							 }
							 return
						}

						guard let documents = snapshot?.documents else {
							 DispatchQueue.main.async {
									self.errorMessage = "❌ No messages found."
							 }
							 return
						}

						let liveMessages: [MessageStruct] = documents.compactMap { doc in
							 let data = doc.data()
							 guard let senderID = data["senderID"] as? String,
										 let text_content = data["text_content"] as? String,
										 let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() else {
									return nil
							 }

							 return MessageStruct(
									id: doc.documentID,
									senderID: senderID,
									text_content: text_content,
									timestamp: timestamp
							 )
						}

						DispatchQueue.main.async {
							 if var room = self.chatRooms.first(where: { $0.id == roomID }) {
									room.messages = liveMessages
									self.currentRoom = room
							 } else if var room = self.currentRoom, room.id == roomID {
									room.messages = liveMessages
									self.currentRoom = room
							 }
						}
				 }
	 }

	 func stopListeningToMessages() {
			firestoreActions.messageListener?.remove()
			firestoreActions.messageListener = nil
	 }

	 func postMessage(to roomID: String, content: String) {
			let db = Firestore.firestore()
			guard let userID = Auth.auth().currentUser?.uid else {
				 errorMessage = "❌ You must be logged in to send a message."
				 return
			}

			let newMessage: [String: Any] = [
				 "senderID": userID,
				 "text_content": content,
				 "timestamp": Timestamp()
			]

			db.collection("rooms")
				 .document(roomID)
				 .collection("messages")
				 .addDocument(data: newMessage) { error in
						if let error = error {
							 DispatchQueue.main.async {
									self.errorMessage = "❌ Failed to send message: \(error.localizedDescription)"
							 }
						}
				 }
	 }
}



