import Foundation
import HKCoreSleep
import HKStatistics
import HKVisualKit
import SettingsKit
import XUI

class CardDetailViewCoordinator: ViewModel, ObservableObject, Identifiable {
    
    @Published private(set) var card: SummaryViewCardType

    private unowned let coordinator: SummaryNavigationCoordinator

    // MARK: Properties

    var colorProvider: ColorSchemeProvider
    var statisticsProvider: HKStatisticsProvider

    

    init(card: SummaryViewCardType, coordinator: SummaryNavigationCoordinator) {
        self.coordinator = coordinator
        self.card = card
        self.colorProvider = coordinator.colorProvider
        self.statisticsProvider = coordinator.statisticsProvider
    }

    

    func open(_ url: URL) {
        self.coordinator.open(url)
    }

}
