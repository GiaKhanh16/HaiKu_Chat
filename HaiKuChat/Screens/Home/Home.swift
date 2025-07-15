import SwiftUI

struct Home: View {
	 @EnvironmentObject var firestore: firestoreActions
	 @State private var offsetY: CGFloat = 0
	 @FocusState private var isExpanded: Bool
	 @Namespace private var namespace
	 @AppStorage("isFirstTime") private var isFirstTime: Bool = true
	 @State private var actionSheet: Bool = false
	 @State private var isTabBarHidden: Bool = false
	 @State private var navigateToChatRoom: Bool = false
	 @State var profilePage: Bool = false

	 var body: some View {
			NavigationStack {
				 ScrollView(.vertical) {
						DummyScrollContent()
							 .offset(y: isExpanded ? -offsetY : 0)
							 .onGeometryChange(for: CGFloat.self) {
									$0.frame(in: .scrollView(axis: .vertical)).minY
							 } action: { newValue in
									offsetY = newValue
							 }
						LazyVStack {
							 ForEach(firestore.chatRooms) { room in
									NavigationLink {
										 chatRoom(room: room)
												.navigationBarBackButtonHidden(true)
												.onAppear { isTabBarHidden = true }
												.onDisappear { isTabBarHidden = false }
												.hideFloatingTabBar(isTabBarHidden)
									} label: {
										 MessageItem(room: room)


									}
									Divider()
							 }

						}
						.padding(.horizontal)
				 }
				 .overlay {
						Rectangle()
							 .fill(.ultraThinMaterial)
							 .background(.background.opacity(0.25))
							 .ignoresSafeArea()
							 .overlay {
									ExpandedSearchView(isExpanded: isExpanded)
										 .offset(y: isExpanded ? 0 : 70)
										 .opacity(isExpanded ? 1 : 0)
										 .allowsHitTesting(isExpanded)

							 }
							 .opacity(isExpanded ? 1 : progress)
				 }
				 .safeAreaInset(edge: .top) {
						HeaderView()
				 }
				 .onChange(of: navigateToChatRoom) { _ , isActive in
						isTabBarHidden = isActive
				 }
				 .hideFloatingTabBar(isExpanded)
				 .animation(.interpolatingSpring(duration: 0.2), value: isExpanded)
				 .sheet(isPresented: $actionSheet, content: {
						RoomActionSheet(actionSheet: $actionSheet, navigateToChatRoom: $navigateToChatRoom)
							 .presentationDetents([.height(250)])
							 .presentationDragIndicator(.visible)
				 })
				 .sheet(isPresented: $isFirstTime, content: {
						IntroScreen()
							 .interactiveDismissDisabled()
				 })
				 .navigationDestination(isPresented: $navigateToChatRoom) {
						if let room = firestore.currentRoom {
									chatRoom(room: room)
									.navigationBarBackButtonHidden(true)
									.onAppear { isTabBarHidden = true }
									.onDisappear { isTabBarHidden = false }
									.hideFloatingTabBar(isTabBarHidden)
						} else {
							 Text("❌ Failed to load chat room.")
						}
				 }
				 .navigationDestination(isPresented: $profilePage) {
						ProfilePage()
							 .onAppear { isTabBarHidden = true }
							 .onDisappear { isTabBarHidden = false }
							 .hideFloatingTabBar(isTabBarHidden)
				 }
				 .onAppear {
						firestore.fetchRoomsCreatedByCurrentUser()
				 }
			}
	 }

			/// Header View
	 @ViewBuilder
	 func HeaderView() -> some View {
			HStack(spacing: 20) {
				 if !isExpanded {
						Button {
							 profilePage.toggle()
						} label: {
							 Image(systemName: "person.circle.fill")
									.font(.title2)

						}
						.transition(.blurReplace)
				 }

						/// Search Bar
				 TextField("Search App", text: .constant(""))
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
						.focused($isExpanded)

				 Button {
						actionSheet.toggle()
				 } label: {

						Image(systemName: "plus.rectangle.fill")
							 .font(.title)
							 .foregroundStyle(
									.blue.mix(with: .green, by: 0.5).gradient
							 )

				 }
				 .opacity(isExpanded ? 0 : 1)
				 .overlay(alignment: .trailing) {
						Button("Cancel") {
							 isExpanded = false
						}
						.fixedSize()
						.opacity(isExpanded ? 1 : 0)
				 }
				 .padding(.leading, isExpanded ? 20 : 0)
			}
			.foregroundStyle(Color.primary)
			.padding(.horizontal, 15)
			.padding(.top, 10)
			.padding(.bottom, 5)
			.background {
				 Rectangle()
						.fill(.background)
						.ignoresSafeArea()
						.opacity(progress == 0 && !isExpanded ? 1 : 0)
			}
	 }

			/// Dummy Scroll Content
	 @ViewBuilder
	 func DummyScrollContent() -> some View {
			VStack(spacing: 15) {
				 HStack(spacing: 30) {
						RoundedRectangle(cornerRadius: 15)
							 .fill(.red.gradient)

						RoundedRectangle(cornerRadius: 15)
							 .fill(.blue.gradient)

						RoundedRectangle(cornerRadius: 15)
							 .fill(.green.gradient)

						RoundedRectangle(cornerRadius: 15)
							 .fill(.yellow.gradient)
				 }
				 .frame(height: 60)
			}
			.padding(.horizontal, 30)
			.padding(.top, 15)
			.padding(.bottom, 10)
	 }

			/// Converting Offset into Progress
	 var progress: CGFloat {
			return max(min(offsetY / 100, 1), 0)
	 }
}



struct OnScrollEnd: ScrollTargetBehavior {
	 /// Return Velocity
	 var onEnd: (CGFloat) -> ()
	 func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
			let dy = context.velocity.dy
			DispatchQueue.main.async {
				 onEnd(dy)
				 }
			}
}

/// Dummy Search View using List View
struct ExpandedSearchView: View {
	 var isExpanded: Bool
	 var body: some View {
			List {
				 let colors: [Color] = [.black]

				 if isExpanded {
						ForEach(colors, id: \.self) { color in
							 Section(String.init(describing: color).capitalized) {
									ForEach(1...5, id: \.self) { index in
										 HStack(spacing: 10) {
												RoundedRectangle(cornerRadius: 10)
													 .fill(color.gradient)
													 .frame(width: 40, height: 40)

												Text("Search Item No: \(index)")
										 }
									}
							 }
							 .listRowBackground(Color.clear)
							 .listRowInsets(.init(top: 12, leading: 0, bottom: 12, trailing: 0))
						}
				 }
			}
			.listStyle(.insetGrouped)
			.scrollContentBackground(.hidden)
			.clipped()
	 }
}



struct MessageItem: View {
	 var room: ChatRoomStruct

			// Date formatter for message time display
	 private var timeFormatter: DateFormatter {
			let formatter = DateFormatter()
			formatter.dateFormat = "h:mm a" // e.g., 10:57 AM
			return formatter
	 }

			// Extract latest message time string
	 private var latestMessageTime: String {
			guard let messages = room.messages, !messages.isEmpty else {
				 return ""
			}
				 // Find the latest message by timestamp
			let latestMessage = messages.max(by: { $0.timestamp < $1.timestamp })
			if let timestamp = latestMessage?.timestamp {
				 return timeFormatter.string(from: timestamp)
			}
			return ""
	 }

	 var body: some View {
			HStack(spacing: 20) {
				 Image(systemName: "apple.logo")
						.resizable()
						.scaledToFill()
						.frame(width: 40, height: 40)
						.clipShape(Circle())
				 VStack(alignment: .leading, spacing: 12) {
						HStack {
							 Text(room.name)
									.fontWeight(.semibold)
									.foregroundStyle(.black.opacity(0.7))
							 Spacer()
							 Text(latestMessageTime)
									.font(.caption)
									.foregroundStyle(.gray)
						}
							 // You can show the latest message text or any snippet if you want
						if let lastMessage = room.messages?.last {
							 Text(lastMessage.text_content)
									.font(.callout)
									.fontWeight(.light)
									.foregroundStyle(.gray)
						} else {
							 Text("No messages yet")
									.font(.callout)
									.fontWeight(.light)
									.foregroundStyle(.gray)
						}
				 }
			}
			.padding(4)
	 }
}
