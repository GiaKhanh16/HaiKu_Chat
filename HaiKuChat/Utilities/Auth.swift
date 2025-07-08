//
//  Auth.swift
//  HaiKuChat
//
//  Created by Khanh Nguyen on 7/4/25.
//
import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

@Observable
class googleAuth: ObservableObject {
	 var isSignedIn: Bool = false
	 func login() {
				 // simulate login
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				 self.isSignedIn = true
			}
	 }

	 @MainActor
	 func signInGoogle() async throws -> Bool {
			guard let clientID = FirebaseApp.app()?.options.clientID else {
				 fatalError("No client ID found in Firebase")
			}

			let config = GIDConfiguration(clientID: clientID)
			GIDSignIn.sharedInstance.configuration = config

			guard let windowScene =  UIApplication.shared.connectedScenes.first as? UIWindowScene,
						let window =  windowScene.windows.first,
						let rootViewController =  window.rootViewController else {
				 fatalError("Could not find root view controller")
			}

			let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
			let user = userAuthentication.user

			guard let idToken = user.idToken else {
				 fatalError("Token Missing")
			}

			let accessToken = user.accessToken
			let credential = GoogleAuthProvider.credential(
				 withIDToken: idToken.tokenString,
				 accessToken: accessToken.tokenString
			)

			let result = try await Auth.auth().signIn(with: credential)
			let return_user = result.user

			if !return_user.uid.isEmpty {
				 self.isSignedIn = true
				 return true
			} else {
				 print("❌ something wrong with Google Auth: invalid user UID")
				 return false
			}
	 }
}
