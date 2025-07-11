import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
	 func application(_ application: UIApplication,
										didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
			FirebaseApp.configure()
			return true
	 }
}

@main
struct HaiKuChatApp: App {
	 @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	 @State private var authModel = authCenter()
	 @State private var firestore = firestoreActions()

	 var body: some Scene {
			WindowGroup {
				 ContentView()
						.environmentObject(authModel)
						.environmentObject(firestore)
						.preferredColorScheme(.light)
			}
	 }
}


#Preview {
	 ContentView()
}
