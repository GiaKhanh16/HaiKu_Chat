import SwiftUI

struct MessageItem: View {
	 var room: ChatRoomStruct

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
							 Text("10:57 AM")
									.font(.caption)
									.foregroundStyle(.gray)
						}
						Text("Green Day Green Day")
							 .font(.callout)
							 .fontWeight(.light)
							 .foregroundStyle(.gray)
				 }
			}
			.padding(4)
	 }
}


