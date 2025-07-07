	 //
	 //  Messaging.swift
	 //  HaiKuChat
	 //
	 //  Created by Khanh Nguyen on 6/28/25.
	 //

import SwiftUI

struct Messaging: View {
	 var sender: String
	 var receiver: String

	 var body: some View {
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

#Preview {
	 Messaging(sender: "Five seven then five\nSyllables marks a Haiku\nRemarkable oath", receiver: "Five seven then five\nSyllables marks a Haiku\nRemarkable oath")
}
