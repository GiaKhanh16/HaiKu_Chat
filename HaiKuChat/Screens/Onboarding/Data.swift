	 //
	 //  Intro.swift
	 //  WalkthroughAnimation
	 //
	 //  Created by Balaji on 16/06/23.
	 //

import SwiftUI

	 /// Intro Model
struct Intro: Identifiable {
	 var id: UUID = .init()
	 var text: String
	 var textColor: Color
	 var circleColor: Color
	 var bgColor: Color
	 var circleOffset: CGFloat = 0
	 var textOffset: CGFloat = 0
}

	 /// Sample Intros
var sampleIntros: [Intro] = [
	 .init(
			text: "Five Seven Then Five",
			textColor: .color4,
			circleColor: .color4,
			bgColor: .color1
	 ),
	 .init(
			text: "Let's Haiku Baby",
			textColor: .color1,
			circleColor: .color1,
			bgColor: .color2
	 ),
	 .init(
			text: "I ❤️ Avatar Bending",
			textColor: .color3,
			circleColor: .color3,
			bgColor: .color4
	 ),
	 .init(
			text: "I ❤️ The  Water Tribe",
			textColor: .color2,
			circleColor: .color2,
			bgColor: .color3
	 ),
]
