	 //
	 //  FloatingTabView.swift
	 //  Floating_Tab_Bar
	 //
	 //  Created by Balaji Venkatesh on 30/04/25.
	 //

import SwiftUI

	 // MARK: Floating Tab Protocol For Enum Cases
protocol FloatingTabProtocol {
	 var symbolImage: String { get }
}

	 // MARK: Floating Tab Bar Configuration
struct FloatingTabConfig {
	 var activeTint: Color = .white.opacity(0.9)
	 var activeBackgroundTint: Color = .blue
	 var inactiveTint: Color = .white
	 var tabAnimation: Animation = .smooth(duration: 0.35, extraBounce: 0)
	 var backgroundColor: Color = .blue.opacity(0.5)
	 var insetAmount: CGFloat = 6
	 var isTranslucent: Bool = false
	 var hPadding: CGFloat = 50
	 var bPadding: CGFloat = 5
			/// Shadows
	 var shadowRadius: CGFloat = 4
}

	 // MARK: Helps to Hide Floating Tab anywhere inside "FloatingTabView" context
fileprivate class FloatingTabViewHelper: ObservableObject {
	 @Published var hideTabBar: Bool = false
}

fileprivate struct HideFloatingTabBarModifier: ViewModifier {
	 var status: Bool
	 @EnvironmentObject private var helper: FloatingTabViewHelper
	 func body(content: Content) -> some View {
			content
				 .onChange(of: status, initial: true) { oldValue, newValue in
						helper.hideTabBar = newValue
				 }
	 }
}

extension View {
	 func hideFloatingTabBar(_ status: Bool) -> some View {
			self
				 .modifier(HideFloatingTabBarModifier(status: status))
	 }
}

	 // MARK: Floating Tab Bar Container
struct FloatingTabView<Content: View, Value: CaseIterable & Hashable & FloatingTabProtocol>: View where Value.AllCases: RandomAccessCollection {
	 var config: FloatingTabConfig
	 @Binding var selection: Value
	 var content: (Value, CGFloat) -> Content

	 init(_ config: FloatingTabConfig = .init(), selection: Binding<Value>, @ViewBuilder content: @escaping (Value, CGFloat) -> Content) {
			self.config = config
			self._selection = selection
			self.content = content
	 }

	 @State private var tabBarSize: CGSize = .zero
	 @StateObject private var helper: FloatingTabViewHelper = .init()

	 var body: some View {
			ZStack(alignment: .bottom) {
				 if #available(iOS 18, *) {
							 /// New Tab View
						TabView(selection: $selection) {
							 ForEach(Value.allCases, id: \.hashValue) { tab in
									Tab.init(value: tab) {
										 content(tab, tabBarSize.height)
												/// Hiding Native Tab Bar
												.toolbarVisibility(.hidden, for: .tabBar)
									}
							 }
						}
				 } else {
							 /// Old Tab View
						TabView(selection: $selection) {
							 ForEach(Value.allCases, id: \.hashValue) { tab in
									content(tab, tabBarSize.height)
										 /// Old tag type tab view
										 .tag(tab)
										 /// Hiding Native Tab Bar
										 .toolbar(.hidden, for: .tabBar)
							 }
						}
				 }

				 FloatingTabBar(config: config, activeTab: $selection)
						.padding(.horizontal, config.hPadding)
						.padding(.bottom, config.bPadding)
						.onGeometryChange(for: CGSize.self) {
							 $0.size
						} action: { newValue in
							 tabBarSize = newValue
						}
						.offset(y: helper.hideTabBar ? (tabBarSize.height + 100) : 0)
						.animation(config.tabAnimation, value: helper.hideTabBar)
			}
			.environmentObject(helper)
	 }
}

// MARK: Floating Tab Bar
fileprivate struct FloatingTabBar<Value: CaseIterable & Hashable & FloatingTabProtocol>: View where Value.AllCases: RandomAccessCollection {

	 var config: FloatingTabConfig
	 @Binding var activeTab: Value
			/// For Tab Sliding Effect
	 @Namespace private var animation
			/// For Symbol Effect
	 @State private var toggleSymbolEffect: [Bool] = Array(repeating: false, count: Value.allCases.count)
	 @State private var hapticsTrigger: Bool = false

	 var body: some View {
			HStack(spacing: 0) {
				 ForEach(Value.allCases, id: \.hashValue) { tab in
						let isActive = activeTab == tab
						let index = (Value.allCases.firstIndex(of: tab) as? Int) ?? 0

						Image(systemName: tab.symbolImage)
							 .font(.title2)
							 .foregroundStyle(isActive ? config.activeTint : config.inactiveTint)
							 .symbolEffect(.bounce.byLayer.down, value: toggleSymbolEffect[index])
							 .frame(maxWidth: 100, maxHeight: .infinity)
							 .contentShape(.rect)
							 .background {
									if isActive {
										 Capsule(style: .continuous)
												.fill(config.activeBackgroundTint.gradient)
												.matchedGeometryEffect(id: "ACTIVETAB", in: animation)
									}
							 }
							 .onTapGesture {
									activeTab = tab
									toggleSymbolEffect[index].toggle()
									hapticsTrigger.toggle()
							 }
							 .padding(.vertical, config.insetAmount)
				 }
			}
			.padding(.horizontal, config.insetAmount)
			.frame(height: 52)
			.background {
				 ZStack {
						if config.isTranslucent {
							 Rectangle()
									.fill(.ultraThinMaterial)
						} else {
							 Rectangle()
									.fill(.background)
						}

						Rectangle()
							 .fill(config.backgroundColor)
				 }
			}
			.clipShape(.capsule(style: .continuous))
			.shadow(radius: config.shadowRadius)
			.animation(config.tabAnimation, value: activeTab)
			.sensoryFeedback(.impact, trigger: hapticsTrigger)
	 }
}


#Preview {
	 TabBarView()
}
