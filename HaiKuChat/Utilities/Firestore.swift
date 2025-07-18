import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import UserNotifications

struct ChatRoomStruct: Identifiable, Equatable {
	 var id: String
	 var name: String
	 var participants: [String]
	 var messages: [MessageStruct]?
	 var lastMessage: LastMessageStruct?
	 var readReceipts: [String: Date] = [:] // userID -> last read timestamp
	 
}

struct LastMessageStruct: Equatable {
	 var text: String
	 var timestamp: Date
	 var senderID: String
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

	 private static var messageListener: ListenerRegistration?

			// MARK: - Create Room
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
						return
				 }

				 if snapshot?.exists == true {
						self.errorMessage = "❌ Room ID already exists. Try again."
						return
				 }

				 let now = Timestamp(date: Date())

				 let roomData: [String: Any] = [
						"name": name,
						"createdBy": user.uid,
						"createdAt": now,
						"participants": [user.uid],
						"readReceipts": [user.uid: now],
						"lastMessage": [
							 "text": "",
							 "senderID": "",
							 "timestamp": now
						]
				 ]

				 roomRef.setData(roomData) { error in
						if let error = error {
							 self.errorMessage = "❌ Error creating room: \(error.localizedDescription)"
						} else {
							 self.currentRoom = ChatRoomStruct(
									id: roomID,
									name: name,
									participants: [user.uid],
									lastMessage: nil,
									readReceipts: [user.uid: Date()]
							 )
							 self.fetchRoomsCreatedByCurrentUser()
						}
				 }
			}
	 }

			// MARK: - Join Room
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
				 var readReceipts = data["readReceipts"] as? [String: Timestamp] ?? [:]

				 if !participants.contains(user.uid) {
						participants.append(user.uid)
						readReceipts[user.uid] = Timestamp(date: Date())
						roomRef.updateData([
							 "participants": participants,
							 "readReceipts": readReceipts
						])
				 }

				 self.currentRoom = self.parseRoom(docID: roomID, data: data)
				 self.fetchRoomsCreatedByCurrentUser()
			}
	 }

			// MARK: - Fetch Rooms (sorted by lastMessage.timestamp)
	 func fetchRoomsCreatedByCurrentUser() {
			guard let user = Auth.auth().currentUser else {
				 self.errorMessage = "❌ No user signed in"
				 return
			}

			let db = Firestore.firestore()
			let roomsRef = db.collection("rooms")

			roomsRef
				 .whereField("participants", arrayContains: user.uid)
				 .order(by: "lastMessage.timestamp", descending: true)
				 .addSnapshotListener { [weak self] snapshot, error in
						guard let self = self else { return }

						if let error = error {
							 self.errorMessage = "❌ Failed to fetch rooms: \(error.localizedDescription)"
							 return
						}

						self.chatRooms = snapshot?.documents.compactMap {
							 self.parseRoom(docID: $0.documentID, data: $0.data())
						} ?? []
				 }
	 }

			// MARK: - Listen to Messages
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
							 self.errorMessage = "❌ Realtime fetch failed: \(error.localizedDescription)"
							 return
						}

						let liveMessages = snapshot?.documents.compactMap { doc -> MessageStruct? in
							 let data = doc.data()
							 guard let senderID = data["senderID"] as? String,
										 let text = data["text"] as? String,
										 let timestamp = (data["timestamp"] as? Timestamp)?.dateValue()
							 else { return nil }

							 return MessageStruct(id: doc.documentID, senderID: senderID, text_content: text, timestamp: timestamp)
						} ?? []

						if var room = self.chatRooms.first(where: { $0.id == roomID }) {
							 room.messages = liveMessages
							 self.currentRoom = room
						} else if var room = self.currentRoom, room.id == roomID {
							 room.messages = liveMessages
							 self.currentRoom = room
						}
				 }
	 }

	 func stopListeningToMessages() {
			firestoreActions.messageListener?.remove()
			firestoreActions.messageListener = nil
	 }

			// MARK: - Post Message
	 func postMessage(to roomID: String, content: String) {
			let db = Firestore.firestore()
			guard let userID = Auth.auth().currentUser?.uid else {
				 errorMessage = "❌ You must be logged in to send a message."
				 return
			}

			let now = Timestamp(date: Date())
			let newMessage: [String: Any] = [
				 "senderID": userID,
				 "text": content,
				 "timestamp": now
			]

			db.collection("rooms")
				 .document(roomID)
				 .collection("messages")
				 .addDocument(data: newMessage) { [weak self] error in
						if let error = error {
							 self?.errorMessage = "❌ Failed to send message: \(error.localizedDescription)"
							 return
						}

						db.collection("rooms")
							 .document(roomID)
							 .updateData([
									"lastMessage": [
										 "text": content,
										 "senderID": userID,
										 "timestamp": now
									]
							 ])
				 }
	 }

			// MARK: - Mark Room As Read
	 func markRoomAsRead(roomID: String) {
			guard let userID = Auth.auth().currentUser?.uid else { return }
			let db = Firestore.firestore()
			db.collection("rooms").document(roomID).updateData([
				 "readReceipts.\(userID)": Timestamp(date: Date())
			])
	 }

			// MARK: - Helper
	 private func parseRoom(docID: String, data: [String: Any]) -> ChatRoomStruct? {
			guard let name = data["name"] as? String,
						let participants = data["participants"] as? [String]
			else { return nil }

			var lastMessage: LastMessageStruct? = nil
			if let lastMsg = data["lastMessage"] as? [String: Any],
				 let text = lastMsg["text"] as? String,
				 let timestamp = (lastMsg["timestamp"] as? Timestamp)?.dateValue(),
				 let senderID = lastMsg["senderID"] as? String {
				 lastMessage = LastMessageStruct(text: text, timestamp: timestamp, senderID: senderID)
			}

			var readReceipts: [String: Date] = [:]
			if let raw = data["readReceipts"] as? [String: Timestamp] {
				 for (uid, ts) in raw {
						readReceipts[uid] = ts.dateValue()
				 }
			}

			return ChatRoomStruct(
				 id: docID,
				 name: name,
				 participants: participants,
				 messages: nil,
				 lastMessage: lastMessage,
				 readReceipts: readReceipts
			)
	 }
}
