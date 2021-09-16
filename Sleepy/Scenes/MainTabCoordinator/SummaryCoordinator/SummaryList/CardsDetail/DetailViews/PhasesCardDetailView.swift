import SwiftUI
import HKStatistics
import HKVisualKit
import HKCoreSleep
import XUI

struct PhasesCardDetailView: View {

    @Store var viewModel: CardDetailViewCoordinator

    @EnvironmentObject var cardService: CardService

    var body: some View {
        GeometryReader { geometry in
            ZStack {

                viewModel.colorProvider.sleepyColorScheme.getColor(of: .general(.appBackgroundColor))
                    .edgesIgnoringSafeArea(.all)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center) {

                        if let phasesViewModel = cardService.phasesViewModel,
                           let generalViewModel = cardService.generalViewModel {
                            StandardChartView(colorProvider: viewModel.colorProvider,
                                              chartType: .phasesChart,
                                              chartHeight: 75,
                                              points: phasesViewModel.phasesData,
                                              chartColor: viewModel.colorProvider.sleepyColorScheme.getColor(of: .heart(.heartColor)),
                                              dateInterval: generalViewModel.sleepInterval)
                                .roundedCardBackground(color: viewModel.colorProvider.sleepyColorScheme.getColor(of: .card(.cardBackgroundColor)))
                                .padding(.top)

                            CardNameTextView(text: "Summary".localized,
                                             color: viewModel.colorProvider.sleepyColorScheme.getColor(of: .textsColors(.standartText)))

                            HorizontalStatisticCellView(data: [StatisticsCellData(title: "Total NREM sleep duration".localized,
                                                                                  value: phasesViewModel.timeInDeepPhase),
                                                               StatisticsCellData(title: "Max NREM sleep interval".localized,
                                                                                  value: phasesViewModel.mostIntervalInDeepPhase),
                                                               StatisticsCellData(title: "Total REM sleep duration".localized,
                                                                                  value: phasesViewModel.timeInLightPhase),
                                                               StatisticsCellData(title: "Max REM sleep interval".localized,
                                                                                  value: phasesViewModel.mostIntervalInLightPhase)
                                                              ],
                                                        colorScheme: viewModel.colorProvider.sleepyColorScheme)
                        }

                        CardNameTextView(text: "What else?".localized,
                                         color: viewModel.colorProvider.sleepyColorScheme.getColor(of: .textsColors(.standartText)))

                        UsefulInfoCardView(imageName: "sleep3", title: "title", description: "description")
                            .usefulInfoCardBackground(color: viewModel.colorProvider.sleepyColorScheme.getColor(of: .card(.cardBackgroundColor)))
                    }
                }
                .navigationTitle("Sleep phases")
            }
        }
    }

}
