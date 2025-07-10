import SwiftUI
import AuthenticationServices

struct WelcomeView: View {
	 @EnvironmentObject var auth: authCenter
	 @State private var intros: [Intro] = sampleIntros
	 @State private var activeIntro: Intro?
	 @State private var shouldAnimate: Bool = true

	 var body: some View {
			GeometryReader {
				 let size = $0.size
				 let safeArea = $0.safeAreaInsets

				 VStack(spacing: 0) {
						if let activeIntro {
							 Rectangle()
									.fill(activeIntro.bgColor)
									.padding(.bottom, -30)
									.overlay {
										 Circle()
												.fill(activeIntro.circleColor)
												.frame(width: 38, height: 38)
												.background(alignment: .leading, content: {
													 Capsule()
															.fill(activeIntro.bgColor)
															.frame(width: size.width)
												})
												.background(alignment: .leading) {
													 Text(activeIntro.text)
															.font(.largeTitle)
															.foregroundStyle(activeIntro.textColor)
															.frame(width: textSize(activeIntro.text))
															.offset(x: 10)
															.offset(x: activeIntro.textOffset)
												}
												.offset(x: -activeIntro.circleOffset)
									}
						}

						LoginButtons()
							 .padding(.bottom, safeArea.bottom)
							 .padding(.top, 10)
							 .background(.black, in: .rect(topLeadingRadius: 25, topTrailingRadius: 25))
							 .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 8)
				 }
				 .ignoresSafeArea()
			}
			.task {
				 if activeIntro == nil {
						activeIntro = sampleIntros.first
						try? await Task.sleep(nanoseconds: UInt64(1_000_000_000 * 1))
						animate(0)
				 }
			}
			.onDisappear {
				 shouldAnimate = false
			}
			.overlay {
				 if auth.isLoading {
						LoadingScreen()
				 }
			}
	 }

	 @ViewBuilder
	 func LoadingScreen() -> some View {
			ZStack {
				 Rectangle()
						.fill(.ultraThinMaterial)

				 ProgressView()
						.frame(width: 45, height: 45)
						.background(.background, in: .rect(cornerRadius: 5))
			}
	 }

	 @ViewBuilder
	 func LoginButtons() -> some View {
			VStack(spacing: 12) {
				 SignInWithAppleButton(.signIn) { request in

						let nonce = auth.randomNonceString()
						auth.nonce = nonce
						request.requestedScopes = [.email, .fullName]
						request.nonce = auth.sha256(auth.nonce!)

				 } onCompletion: { result in
						switch result {
							 case .success(let authorization):
									auth.loginWithApple(authorization)
							 case .failure(let error):
									print(error)
						}
				 }
						.frame(maxHeight: 50)
						.signInWithAppleButtonStyle(.whiteOutline)

				 HStack {
						VStack {
							 Divider()
									.background(Color.white)
						}
						Text("or")
							 .foregroundColor(.white)
						VStack {
							 Divider()
									.background(Color.white)
						}
				 }
				 Button {
						Task {
							 try await auth.signInGoogle()
						}
				 } label: {
						Label("Sign Up With Google", systemImage: "envelope.fill")
							 .foregroundStyle(.white)
							 .fillButton(.buton)
				 }




			}
			.padding(15)
	 }

	 func animate(_ index: Int, _ loop: Bool = true) {
			guard shouldAnimate else { return }

			if intros.indices.contains(index + 1) {
				 activeIntro?.text = intros[index].text
				 activeIntro?.textColor = intros[index].textColor

				 withAnimation(.snappy(duration: 1), completionCriteria: .removed) {
						activeIntro?.textOffset = -(textSize(intros[index].text) + 20)
						activeIntro?.circleOffset = -(textSize(intros[index].text) + 20) / 2
				 } completion: {
						withAnimation(.snappy(duration: 0.8), completionCriteria: .logicallyComplete) {
							 activeIntro?.textOffset = 0
							 activeIntro?.circleOffset = 0
							 activeIntro?.circleColor = intros[index + 1].circleColor
							 activeIntro?.bgColor = intros[index + 1].bgColor
						} completion: {
							 animate(index + 1, loop)
						}
				 }
			} else if loop && shouldAnimate {
				 animate(0, loop)
			}
	 }

	 func textSize(_ text: String) -> CGFloat {
			return NSString(string: text).size(
				 withAttributes: [.font: UIFont.preferredFont(forTextStyle: .largeTitle)]
			).width
	 }
}

	 // MARK: - Preview


	 // MARK: - Custom Modifier
extension View {
	 @ViewBuilder
	 func fillButton(_ color: Color) -> some View {
			self
				 .fontWeight(.bold)
				 .frame(maxWidth: .infinity)
				 .padding(.vertical, 15)
				 .background(color, in: .rect(cornerRadius: 15))
	 }
}

	 // MARK: - Model & Sample Data

struct Intro: Identifiable {
	 var id: UUID = .init()
	 var text: String
	 var textColor: Color
	 var circleColor: Color
	 var bgColor: Color
	 var circleOffset: CGFloat = 0
	 var textOffset: CGFloat = 0
}

var sampleIntros: [Intro] = [
	 .init(text: "Five Seven Then Five", textColor: .color4, circleColor: .color4, bgColor: .color1),
	 .init(text: "You, me Haiku Together", textColor: .color1, circleColor: .color1, bgColor: .color2),
	 .init(text: "I ❤️ The Water Tribe", textColor: .color2, circleColor: .color2, bgColor: .color3),
]
