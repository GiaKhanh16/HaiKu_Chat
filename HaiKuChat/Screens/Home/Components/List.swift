import SwiftUI

struct MessageList: View {
	 @Namespace private var namespace

	 var body: some View {
			NavigationStack {
				 VStack(spacing: 20) {
						List(1...10, id: \.self) { index in
							 NavigationLink {
									ChatRoom()
										 .navigationTransition(
												.zoom(sourceID: index, in: namespace) // Use index as sourceID
										 )
										 .hideFloatingTabBar(true)
							 } label: {
									MessageItem()
										 .matchedTransitionSource(id: index, in: namespace) // Match id to index
							 }
						}
						.listStyle(.plain)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
				 }
				 .navigationTitle("Messages")
			}
	 }
}

struct MessageItem: View {
	 var body: some View {
			HStack(spacing: 20) {
				 Image(systemName: "apple.logo")
						.resizable()
						.scaledToFill()
						.frame(width: 40, height: 40)
						.clipShape(Circle())
				 VStack(alignment: .leading, spacing: 12) {
						HStack {
							 Text("Alex Kornajcik")
									.fontWeight(.semibold)
									.foregroundStyle(.black.opacity(0.7))
							 Spacer()
							 Text("10:57 AM")
									.font(.caption)
									.foregroundStyle(.gray)
						}
						Text("I love your hair")
							 .font(.callout)
							 .fontWeight(.light)
							 .foregroundStyle(.gray)
				 }
			}
			.padding(4)
	 }
}


#Preview {
	 MessageList()
}
