// Copyright (c) 2022 Sleepy.

import FirebaseAnalytics
import Foundation
import SettingsKit
import UIComponents
import XUI

class SettingsCoordinator: ObservableObject, ViewModel {
    public enum Constants {
        public static let email = "sleepydevelop@gmail.com"
        public static let twitterURL = "https://twitter.com/SleepyiOSApp"
        public static let appstoreURL = "https://www.apple.com" // TODO: replace when published
    }

    enum IconType: String, CaseIterable {
        case dark = "darkIcon"
        case white = "whiteIcon"
    }

    private unowned let parent: RootCoordinator

    @Published var openedURL: URL?

    @Published var sleepGoalValue = 480
    @Published var bitrateValue = 12000
    @Published var currentIconType: IconType = .white
    @Published var recognisionConfidenceValue: Int = 30
    @Published var isSharePresented: Bool = false

    init(parent: RootCoordinator) {
        self.parent = parent
    }

    func open(_ url: URL) {
        self.openedURL = url
    }
}

extension SettingsCoordinator {
    func saveSetting(with value: Int, forKey key: String) {
        FirebaseAnalytics.Analytics.logEvent("Settings_saved", parameters: [
            "key": key,
            "value": value,
        ])
        UserDefaults.standard.set(value, forKey: key)
    }

    func getAllValuesFromUserDefaults() {
        self.sleepGoalValue = UserDefaults.standard.integer(forKey: SleepySettingsKeys.sleepGoal.rawValue)
        self.bitrateValue = UserDefaults.standard.integer(forKey: SleepySettingsKeys.soundBitrate.rawValue)
        self.recognisionConfidenceValue = UserDefaults.standard.integer(forKey: SleepySettingsKeys.soundRecognisionConfidence.rawValue)
    }

    func setIcon(iconType: IconType) {
        let application = UIApplication.shared

        if application.supportsAlternateIcons {
            if application.alternateIconName == nil, iconType == .dark {
                application.setAlternateIconName("darkIcon")
                self.currentIconType = .dark
            } else if application.alternateIconName == "darkIcon", iconType == .white {
                application.setAlternateIconName(nil)
                self.currentIconType = .white
            }
        }
    }

    /// needs to be called in the main thread. So it should be called in viewDidAppear method
    func retrieveCurrentIcon() {
        let application = UIApplication.shared
        if application.supportsAlternateIcons, application.alternateIconName != nil {
            self.currentIconType = .dark
        } else {
            self.currentIconType = .white
        }
    }
}
