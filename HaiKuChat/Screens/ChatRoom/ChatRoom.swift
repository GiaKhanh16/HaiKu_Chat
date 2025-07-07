import SwiftUI

struct ChatRoom: View {
	 @State private var sheet: Bool = false
	 @Environment(\.dismiss) private var dismiss
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
									Image(systemName: "info.square.fill")
										 .foregroundStyle(.black)
										 .font(.system(size: 20))
							 }
						}
						ToolbarItem(placement: .topBarTrailing) {
							 Button {
									sheet.toggle()
							 } label: {
									Image(systemName: "info.square.fill")
										 .foregroundStyle(.black)
										 .font(.system(size: 20))
							 }
						}
						ToolbarItem(placement: .principal) {
							 Button {
									sheet.toggle()
							 } label: {
									Image(systemName: "info.square.fill")
										 .foregroundStyle(.black)
										 .font(.system(size: 20))
							 }
						}
				 }
				 .sheet(isPresented: $sheet) {
						info()
				 }

			}
	 }
}

struct info: View {
	 var body: some View {
			VStack {
				 Text("Room ID:")
			}
			.presentationDetents([.medium])
			.presentationDragIndicator(.visible)
	 }

}


#Preview {
	 ChatRoom()
}


