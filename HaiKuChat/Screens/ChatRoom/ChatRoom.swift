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
							 Button {
									sheet.toggle()
							 } label: {
							 Text("Khanh's Haiku")
										 .foregroundStyle(.black)
							 }
						}
				 }
				 .sheet(isPresented: $sheet) {
						InfoBox()
							 .presentationDetents([.height(410)])
							 .presentationBackground(.clear)
				 }
			}
	 }
}

struct info: View {
	 var body: some View {
			VStack {

						// Add Member Button
				 HStack(spacing: 16) {
						Image(systemName: "person.crop.rectangle.badge.plus.fill")
							 .font(.title2)
							 .foregroundColor(.blue)
							 .frame(width: 40, height: 40)
							 .background(Color.blue.opacity(0.1))
							 .clipShape(RoundedRectangle(cornerRadius: 12))

						VStack(alignment: .leading, spacing: 2) {
							 Text("Add Member")
									.font(.headline)
							 Text("Add a new member to this chat room")
									.font(.caption)
									.foregroundColor(.secondary)
						}

							 //							 Spacer()
				 }
				 .frame(maxWidth: .infinity, alignment: .leading)
				 .padding()
				 .background(Color.gray.opacity(0.1))
				 .clipShape(RoundedRectangle(cornerRadius: 16))

						// Member Count
				 Text("Members - 2")
						.font(.subheadline)
						.fontWeight(.semibold)
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.top, 10)

						// Member List
				 VStack(spacing: 12) {
						HStack {
							 Image(systemName: "person.circle.fill")
									.font(.title2)
									.foregroundColor(.green)
							 Text("Khanh Nguyen")
									.font(.body)
							 Spacer()
						}
						Divider()
						HStack {
							 Image(systemName: "person.circle.fill")
									.font(.title2)
									.foregroundColor(.green)
							 Text("Khanh Nguyen")
									.font(.body)
							 Spacer()
						}
				 }
				 .padding()
				 .background(Color.gray.opacity(0.05))
				 .clipShape(RoundedRectangle(cornerRadius: 12))
				 Spacer()
			}
			.padding()
	 }

}


#Preview {
	 ChatRoom()
}


