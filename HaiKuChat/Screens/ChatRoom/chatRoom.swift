import SwiftUI

struct chatRoom: View {
	 @State private var inputText: String = ""
	 @State private var infoBox: Bool = false
	 @FocusState private var isTextFieldFocused: Bool
	 @State private var sheet: Bool = false
	 @Environment(\.dismiss) private var dismiss
	 @EnvironmentObject var firestore: firestoreActions
	 @EnvironmentObject var auth: authCenter
	 @State private var scrollToBottomTrigger = UUID()
	 @State private var currentLineIndex: Int = 0 // Track the current line being edited

	 var messages: [MessageStruct] {
			firestore.currentRoom?.messages ?? []
	 }

	 var room: ChatRoomStruct

	 var body: some View {
			NavigationView {
				 VStack {
						ScrollViewReader { proxy in
							 ScrollView(showsIndicators: false) {
									VStack(spacing: 20) {
										 ForEach(messages) { msg in
												VStack {
													 Text(msg.text_content)
															.padding()
															.lineSpacing(15)
															.background( msg.senderID == auth.userSession?.uid ? .purple.opacity(0.6) : .purple.opacity(0.3))
															.cornerRadius(10)
															.frame(maxWidth: .infinity, alignment: msg.senderID == auth.userSession?.uid ? .trailing : .leading)
												}
										 }
									}
									Color.clear
										 .frame(height: 1)
										 .id(scrollToBottomTrigger)
							 }
							 .padding(.horizontal)
							 .padding(.bottom, -10)
							 .onChange(of: inputText) { _, _ in
									withAnimation {
										 proxy.scrollTo(scrollToBottomTrigger, anchor: .bottom)
									}
							 }
							 .onChange(of: isTextFieldFocused) { _, focused in
									if focused {
										 DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
												withAnimation {
													 proxy.scrollTo(scrollToBottomTrigger, anchor: .bottom)
												}
										 }
									}
							 }
							 .onAppear {
									DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
										 withAnimation {
												proxy.scrollTo(scrollToBottomTrigger, anchor: .bottom)
										 }
									}
							 }
						}
				 }
				 .contentShape(Rectangle())
				 .onTapGesture {
						isTextFieldFocused = false
				 }
				 .safeAreaInset(edge: .bottom) {
						chatInputArea
							 .ignoresSafeArea(.keyboard, edges: .bottom)
				 }
				 .toolbar {
						ToolbarItem(placement: .topBarLeading) {
							 Button {
									dismiss()
							 } label: {
									Image(systemName: "chevron.left.circle")
										 .foregroundStyle(.black)
										 .font(.system(size: 18))
							 }
						}
						ToolbarItem(placement: .topBarTrailing) {
							 Button {
									sheet.toggle()
							 } label: {
									Image(systemName: "tray.fill")
										 .foregroundStyle(.yellow)
										 .font(.system(size: 16))
							 }
						}
						ToolbarItem(placement: .principal) {
							 Text(room.name)
									.foregroundStyle(.black)
						}
				 }
				 .sheet(isPresented: $sheet) {
						InfoBox()
							 .presentationDetents([.height(410)])
							 .presentationBackground(.clear)
				 }
				 .onAppear {
						firestore.listenToMessages(for: room.id)
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
							 withAnimation {
									scrollToBottomTrigger = UUID()
							 }
						}
				 }
				 .onDisappear {
						firestore.stopListeningToMessages()
				 }
			}
	 }

	 private func firstLine() -> String {
			let lines = inputText.split(separator: "\n", omittingEmptySubsequences: false)
			return lines.isEmpty ? "" : String(lines[0])
	 }

	 private func secondLine() -> String {
			let lines = inputText.split(separator: "\n", omittingEmptySubsequences: false)
			return lines.count > 1 ? String(lines[1]) : ""
	 }

	 private func thirdLine() -> String {
			let lines = inputText.split(separator: "\n", omittingEmptySubsequences: false)
			return lines.count > 2 ? String(lines[2]) : ""
	 }

	 private func isValidHaiku() -> Bool {
			let first = countSyllables(firstLine())
			let second = countSyllables(secondLine())
			let third = countSyllables(thirdLine())
			return first == 5 && second == 7 && third == 5
	 }

	 private func laneSymbol(for count: Int) -> String {
			if count == 0 {
				 return "lane"
			} else {
				 return "\(count).lane"
			}
	 }

	 private var chatInputArea: some View {
			ZStack {
				 Color(.systemBackground)
						.ignoresSafeArea()
						.clipShape(.rect(topLeadingRadius: 60, topTrailingRadius: 60))

				 VStack {
						HStack {
							 TextField("Text", text: $inputText, axis: .vertical)
									.foregroundColor(.black)
									.lineLimit(4)
									.frame(maxWidth: .infinity, alignment: .leading)
									.padding([.top, .horizontal])
									.font(.system(size: 16))
									.focused($isTextFieldFocused)
									.onChange(of: inputText) { _, newValue in
										 let lines = newValue.split(separator: "\n", omittingEmptySubsequences: false)
										 if lines.count > 4 {
												inputText = lines.prefix(4).joined(separator: "\n")
										 }
										 if lines.count >= 4 && newValue.last == "\n" {
												inputText = String(newValue.dropLast())
										 }
												// Update current line index based on the number of lines
										 currentLineIndex = min(lines.count - 1, 2)
									}
							 Spacer()
							 Text("\(syllableCountForCurrentLine())")
									.font(.caption)
//									.foregroundColor(syllableCountForCurrentLine() == targetSyllablesForLine(currentLineIndex) ? .green : .gray)
									.padding(.trailing)
						}

						HStack {
							 Image(systemName: "5.lane")
									.font(.title2)
									.foregroundStyle(countSyllables(firstLine()) == 5 ? .blue.mix(with: .green, by: 0.5) : .primary)
									.if(countSyllables(firstLine()) != 5) {
										 $0.symbolEffect(.wiggle, options: .repeat(.periodic(delay: 0.5)))
									}

							 Image(systemName: "7.lane")
									.font(.title2)
									.foregroundStyle(countSyllables(secondLine()) == 7 ? .blue.mix(with: .green, by: 0.5) : .primary)
									.if(countSyllables(secondLine()) != 7) {
										 $0.symbolEffect(.wiggle, options: .repeat(.periodic(delay: 0.5)))
									}

							 Image(systemName: "5.lane")
									.font(.title2)
									.foregroundStyle(countSyllables(thirdLine()) == 5 ? .blue.mix(with: .green, by: 0.5) : .primary)
									.if(countSyllables(thirdLine()) != 5) {
										 $0.symbolEffect(.wiggle, options: .repeat(.periodic(delay: 0.5)))
									}

							 Spacer()

							 Button {
									sendMessage(inputText: inputText)
									isTextFieldFocused = false
							 } label: {
									Text("Send")
										 .font(.caption)
										 .foregroundStyle(.black)
										 .padding(.horizontal, 9)
										 .padding(.vertical, 9)
										 .background(.gray.opacity(0.3))
										 .cornerRadius(10)
										 .padding(.bottom, 2)
							 }
						}
						.padding(.horizontal)
						.padding(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
				 }
				 .padding(5)
				 .background(.ultraThinMaterial)
				 .clipShape(.rect(cornerRadius: 30))
				 .padding([.horizontal])
				 .padding(.top, -50)
			}
			.offset(y: isTextFieldFocused ? 20 : 40)
			.frame(height: 130)
	 }

	 private func syllableCountForCurrentLine() -> Int {
			switch currentLineIndex {
				 case 0:
						return countSyllables(firstLine())
				 case 1:
						return countSyllables(secondLine())
				 case 2:
						return countSyllables(thirdLine())
				 default:
						return 0
			}
	 }

	 private func targetSyllablesForLine(_ lineIndex: Int) -> Int {
			switch lineIndex {
				 case 0:
						return 5
				 case 1:
						return 7
				 case 2:
						return 5
				 default:
						return 0
			}
	 }

	 func sendMessage(inputText: String) {
			let trimmedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
			guard !trimmedText.isEmpty else { return }

			firestore.postMessage(to: room.id, content: trimmedText)
			self.inputText = ""
			scrollToBottomTrigger = UUID()
			currentLineIndex = 0 // Reset to first line after sending
	 }
}

extension View {
	 @ViewBuilder
	 func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
			if condition {
				 transform(self)
			} else {
				 self
			}
	 }
}

