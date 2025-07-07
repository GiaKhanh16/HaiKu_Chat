	 //
	 //  Home.swift
	 //  HaiKuChat
	 //
	 //  Created by Khanh Nguyen on 6/28/25.
	 //

import SwiftUI


struct Onboarding: View {
	 @EnvironmentObject var auth: googleAuth
	 var body: some View {
			NavigationStack {
				 VStack(spacing: 20) {

						Text("Five seven then five\nSyllables marks a Haiku\nRemarkable oath")
							 .padding()
							 .lineSpacing(15)
							 .background(.gray.opacity(0.2))
							 .cornerRadius(10)
							 .frame(maxWidth: .infinity, alignment: .leading)
						Text("Five seven then five\nSyllables marks a Haiku\nRemarkable oath")
							 .padding()
							 .lineSpacing(15)
							 .background(.gray.opacity(0.2))
							 .cornerRadius(10)
							 .frame(maxWidth: .infinity, alignment: .trailing)
						Spacer()
							 .frame(height: 200)
						Button {
							 Task {
									do {
										 let success = try await auth.signInGoogle()
										 if success {
												print("✅ Google sign-in successful")
												auth.isSignedIn.toggle()
										 } else {
												print("❌ Sign-in returned false (unexpected)")
										 }
									} catch {
										 print("❌ Google sign-in error: \(error.localizedDescription)")
									}
							 }
						} label: {
							 Text("Log In With Google")
									.foregroundStyle(.white)
									.padding()
									.frame(maxWidth: .infinity) // Stretch to full width
									.background(.blue.mix(with: .pink, by: 0.2))
									.cornerRadius(10)
						}
						Button {} label: {
							 Text("Log In With Apple")
									.foregroundStyle(.white)
									.padding()
									.frame(maxWidth: .infinity)
									.background(.blue.mix(with: .pink, by: 0.2))
									.cornerRadius(10)
						}
				 }
				 .frame(maxWidth: .infinity, maxHeight: .infinity)
				 .padding()
				 .navigationTitle("HaiKu Battle")
				 .navigationBarTitleDisplayMode(.inline)
			}
	 }
}

#Preview {
	 Onboarding()
}


