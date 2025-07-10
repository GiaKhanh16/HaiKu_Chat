import SwiftUI

struct ChatRoom: View {
	 @State private var sheet: Bool = false
	 @Environment(\.dismiss) private var dismiss
	 var room: ChatRoomStruct


	 var body: some View {
			NavigationView {
				 VStack(spacing: 20) {
						Messaging(sender: "Five seven then five\nSyllables marks a Haiku\nRemarkable oath", receiver: "Five seven then five\nSyllables marks a Haiku\nRemarkable oath")
				 }
				 .frame(maxWidth: .infinity, maxHeight: .infinity)
				 .safeAreaInset(edge: .bottom) {
						textField()
				 }
				 .ignoresSafeArea()
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
										 .foregroundStyle(.black)
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
			}
	 }
	 @ViewBuilder
	 func Messaging(sender: String, receiver: String) -> some View {
			VStack(spacing: 30) {
				 Text(sender)
						.padding()
						.lineSpacing(15)
						.background(.gray.opacity(0.2))
						.cornerRadius(10)
						.frame(maxWidth: .infinity, alignment: .leading)

				 Text(receiver)
						.padding()
						.lineSpacing(15)
						.background(.gray.opacity(0.2))
						.cornerRadius(10)
						.frame(maxWidth: .infinity, alignment: .trailing)
			}
			.padding()
	 }

}

//
//#Preview {
//	 Home()
//}
//
//
