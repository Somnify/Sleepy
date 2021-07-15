import SwiftUI
import XUI
import HKVisualKit
import HKStatistics

// MARK: - Protocol

protocol FeedListCoordinator: ViewModel {

    var colorProvider: ColorSchemeProvider { get }
    var statisticsProvider: HKStatisticsProvider { get }

    var title: String { get }
    var cards: [CardType]? { get }

    func open(_ card: CardType)

}

// MARK: - Implementation

class FeedListCoordinatorImpl: ObservableObject, FeedListCoordinator {

    // MARK: Stored Properties

    @Published private(set) var title: String
    @Published private(set) var cards: [CardType]?

    private let cardService: CardService
    private unowned let coordinator: FeedNavigationCoordinator
    let colorProvider: ColorSchemeProvider
    let statisticsProvider: HKStatisticsProvider

    // MARK: Initialization

    init(colorProvider: ColorSchemeProvider,
         statisticsProvider: HKStatisticsProvider,
         title: String,
         cardService: CardService,
         coordinator: FeedNavigationCoordinator,
         filter: @escaping (CardType) -> Bool) {

        self.colorProvider = colorProvider
        self.statisticsProvider = statisticsProvider
        self.title = title
        self.coordinator = coordinator
        self.cardService = cardService

        cardService.fetchCards {
            self.cards = $0.filter(filter)
        }

    }

    // MARK: Methods

    func open(_ card: CardType) {
        coordinator.open(card)
    }

}
