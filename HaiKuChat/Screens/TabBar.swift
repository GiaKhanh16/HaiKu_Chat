	 //
	 //  ContentView.swift
	 //  Floating_Tab_Bar
	 //
	 //  Created by Balaji Venkatesh on 30/04/25.
	 //

import SwiftUI

enum AppTab: String, CaseIterable, FloatingTabProtocol {
	 case home = "Home"
	 case profile = "Profile"

	 var symbolImage: String {
			switch self {
				 case .home: "message.badge.circle.fill"
				 case .profile: "brain.head.profile"
			}
	 }
}

struct TabBarView: View {
	 @State private var activeTab: AppTab = .home
	 @State private var config: FloatingTabConfig = .init()
	 var body: some View {
			FloatingTabView(config, selection: $activeTab) { tab, tabBarHeight in
				 /// YOUR TAB VIEWS
				 switch tab {
							 case .home:
							 Home()
							 case .profile: Text("Green day")

							 }
				 }
			}
}



#Preview {
	 TabBarView()
}
