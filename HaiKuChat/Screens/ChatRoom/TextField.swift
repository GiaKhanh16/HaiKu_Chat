//
//  TextField.swift
//  HaiKuChat
//
//  Created by Khanh Nguyen on 6/29/25.
//
import SwiftUI

struct textField: View {
	 @State private var inputText: String = ""
	 @State private var infoBox: Bool = false

	 var body: some View {
			VStack {
				 HStack {
						TextField("Title", text: $inputText, axis: .vertical)
							 .lineLimit(4)
							 .frame(maxWidth: .infinity, alignment: .leading)
							 .padding()
							 .onChange(of: inputText) { oldValue, newValue in
									let lines = newValue.split(separator: "\n", omittingEmptySubsequences: false)
									if lines.count > 4 {
										 inputText = lines.prefix(4).joined(separator: "\n")
									}
									if lines.count >= 4 && newValue.last == "\n" {
										 inputText = String(newValue.dropLast())
									}
										 // Update syllable count in real-time
							 }
						Spacer()
						Button {} label: {
							 Text("Send")
									.font(.caption)
									.foregroundStyle(.black)
									.padding(10)
									.background(.gray.opacity(0.3))
									.cornerRadius(10)
									.padding(.trailing, 15)
						}
				 }

				 HStack {
						Text("\(countSyllables(firstLine()))")
							 .fontWeight(.medium)
							 .foregroundStyle(countSyllables(firstLine()) == 5 ? .green : .primary)
						Text("\(countSyllables(secondLine()))")
							 .fontWeight(.medium)
							 .foregroundStyle(countSyllables(secondLine()) == 7 ? .green : .primary)
						Text("\(countSyllables(thirdLine()))")
							 .fontWeight(.medium)
							 .foregroundStyle(countSyllables(thirdLine()) == 5 ? .green : .primary)
						Spacer()
						Button {
							 infoBox.toggle()
						} label: {
							 Image(systemName: "5.lane")
									.foregroundStyle(.black)
									.font(.system(size: 22))
						}
				 }
				 .padding(.horizontal)
			}
			.padding()
			.padding(.bottom, 30)
			.background(.gray.opacity(0.2))
			.clipShape(.rect(topLeadingRadius: 20, topTrailingRadius: 20))
			.onChange(of: inputText) { oldValue, newValue in
				 let lines = newValue.split(separator: "\n", omittingEmptySubsequences: false)
				 if lines.count > 4 {
						inputText = lines.prefix(4).joined(separator: "\n")
				 }
				 if lines.count >= 4 && newValue.last == "\n" {
						inputText = String(newValue.dropLast())
				 }
			}
			.sheet(isPresented: $infoBox, content: {
						InfoBox()
						.presentationDetents([.height(410)])
						.presentationBackground(.clear)
			})
	 }
	 private func firstLine() -> String {
			let lines = inputText.split(separator: "\n", omittingEmptySubsequences: false)
			return lines.isEmpty ? "" : String(lines[0])
	 }

			// Helper function to get the second line
	 private func secondLine() -> String {
			let lines = inputText.split(separator: "\n", omittingEmptySubsequences: false)
			return lines.count > 1 ? String(lines[1]) : ""
	 }

			// Helper function to get the third line
	 private func thirdLine() -> String {
			let lines = inputText.split(separator: "\n", omittingEmptySubsequences: false)
			return lines.count > 2 ? String(lines[2]) : ""
	 }

			// Helper function to check if the input is a valid haiku (5-7-5 syllables)
	 private func isValidHaiku() -> Bool {
			let first = countSyllables(firstLine())
			let second = countSyllables(secondLine())
			let third = countSyllables(thirdLine())
			return first == 5 && second == 7 && third == 5
	 }
}

#Preview {
	 ChatRoom()
}
