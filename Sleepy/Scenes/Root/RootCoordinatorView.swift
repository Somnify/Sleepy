import FirebaseAnalytics
import SwiftUI
import XUI

struct RootCoordinatorView: View {
    @Store var viewModel: RootCoordinator

    var body: some View {
        TabView(selection: $viewModel.tab) {
            SummaryNavigationCoordinatorView(viewModel: viewModel.summaryCoordinator)
                .tabItem { Label("summary".localized, systemImage: "bed.double.fill") }
                .tag(TabBarTab.summary)

            HistoryCoordinatorView(viewModel: viewModel.historyCoordinator)
                .tabItem { Label("history".localized, systemImage: "calendar") }
                .tag(TabBarTab.history)

            SoundsCoordinatorView(viewModel: viewModel.soundsCoordinator)
                .tabItem { Label("sounds".localized, systemImage: "waveform.and.mic") }
                .tag(TabBarTab.soundRecognision)

            AlarmCoordinatorView(viewModel: viewModel.alarmCoordinator)
                .tabItem { Label("alarm".localized, systemImage: "alarm.fill") }
                .tag(TabBarTab.alarm)

            SettingsCoordinatorView(viewModel: viewModel.settingsCoordinator)
                .tabItem { Label("settings".localized, systemImage: "gear") }
                .tag(TabBarTab.settings)
        }.onAppear(perform: self.sendAnalytics)
    }

    private func sendAnalytics() {
        FirebaseAnalytics.Analytics.logEvent("RootView_viewed", parameters: [
            "tabOpened": viewModel.tab.rawValue,
        ])
    }
}
