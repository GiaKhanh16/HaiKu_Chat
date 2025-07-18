import SwiftUI
import FirebaseCore
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
	 func application(_ application: UIApplication,
										didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
			FirebaseApp.configure()

			let center = UNUserNotificationCenter.current()
			center.delegate = self
			center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
				 if let error = error {
						print("Notification permission error: \(error.localizedDescription)")
				 } else {
						print("Notification permission granted: \(granted)")
				 }
			}

			return true
	 }

	 func userNotificationCenter(_ center: UNUserNotificationCenter,
															 willPresent notification: UNNotification,
															 withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
			completionHandler([.banner, .sound])
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
	 //chatRoom(
	 //	 room: ChatRoomStruct(
	 //			id: "preview-room-1",
	 //			name: "Preview Room",
	 //			participants: ["user1", "user2"],
	 //			messages: []
	 //			)

	 //.environmentObject(firestoreActions())
