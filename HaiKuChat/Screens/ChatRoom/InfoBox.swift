	 //
	 //  ThemeChangeView.swift
	 //  ThemeChanger
	 //
	 //  Created by Balaji Venkatesh on 22/12/23.
	 //

import SwiftUI

struct InfoBox: View {
	 var body: some View {
			VStack(spacing: 20) {
				 VStack {

							 // Room Header
						HStack( spacing: 10	) {
							 Text("Khanh's Haiku")
									.font(.title3.bold())
									.foregroundColor(.primary)
							 Spacer()
							 Text("RANDOMID25")
									.font(.caption)
									.foregroundColor(.secondary)
						}
						.frame(maxWidth: .infinity, alignment: .leading)

				 }
				 .padding(.top, 25)
				 .padding(.horizontal, 20)

				 VStack (spacing: 10) {

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
						}
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding()
						.background(Color.gray.opacity(0.1))
						.clipShape(RoundedRectangle(cornerRadius: 16))
						.padding(.horizontal)

						HStack(spacing: 16) {
							 Image(systemName: "bell.slash.circle.fill")
									.font(.title2)
									.foregroundColor(.black)
									.frame(width: 40, height: 40)
									.background(Color.black.opacity(0.1))
									.clipShape(RoundedRectangle(cornerRadius: 12))

							 VStack(alignment: .leading, spacing: 2) {
									Text("Mute Chat")
										 .font(.headline)
									Text("Mute this chat room")
										 .font(.caption)
										 .foregroundColor(.secondary)
							 }
						}
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding()
						.background(Color.gray.opacity(0.1))
						.clipShape(RoundedRectangle(cornerRadius: 16))
						.padding(.horizontal)
						HStack(spacing: 16) {
							 Image(systemName: "person.crop.circle.fill.badge.minus")
									.font(.title2)
									.foregroundColor(.yellow)
									.frame(width: 40, height: 40)
									.background(Color.yellow.opacity(0.2))
									.clipShape(RoundedRectangle(cornerRadius: 12))

							 VStack(alignment: .leading, spacing: 2) {
									Text("Remove Member")
										 .font(.headline)
									Text("Remove the annoying one")
										 .font(.caption)
										 .foregroundColor(.secondary)
							 }
						}
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding()
						.background(Color.gray.opacity(0.1))
						.clipShape(RoundedRectangle(cornerRadius: 16))
						.padding(.horizontal)

						HStack(spacing: 16) {
							 Image(systemName: "rectangle.portrait.and.arrow.forward.fill")
									.font(.title2)
									.foregroundColor(.red)
									.frame(width: 40, height: 40)
									.background(Color.red.opacity(0.1))
									.clipShape(RoundedRectangle(cornerRadius: 12))

							 VStack(alignment: .leading, spacing: 2) {
									Text("Leave Chat Room")
										 .font(.headline)
									Text("Say bye-bye to this chat room")
										 .font(.caption)
										 .foregroundColor(.secondary)
							 }
						}
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding()
						.background(Color.gray.opacity(0.1))
						.clipShape(RoundedRectangle(cornerRadius: 16))
						.padding(.horizontal)
				 }


				 Spacer()
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.frame(height: safeArea.bottom == .zero ? 395 : 410)
			.background(.white)
			.clipShape(.rect(cornerRadius: 30))
			.padding(.horizontal, 15)
			.padding(.bottom, safeArea.bottom == .zero ? 15 : 0)
	 }
	 var safeArea: UIEdgeInsets {
			if let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets {
				 return safeArea
			}

			return .zero
	 }
}

#Preview {
	 ChatRoom()
}
