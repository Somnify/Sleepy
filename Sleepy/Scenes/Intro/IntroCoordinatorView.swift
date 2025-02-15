// Copyright (c) 2022 Sleepy.

import SwiftUI

import FirebaseAnalytics
import SwiftUI
import XUI

struct IntroCoordinatorView: View {
    @Store var viewModel: IntroCoordinator
    @Binding var shouldShowIntro: Bool

    var body: some View {
        MainIntroView(shouldShowIntro: self.$shouldShowIntro)
    }

    private func sendAnalytics() {
        FirebaseAnalytics.Analytics.logEvent("IntroView_viewed", parameters: nil)
    }
}
