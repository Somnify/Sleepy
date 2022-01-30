// Copyright (c) 2021 Sleepy.

import AVKit
import SwiftUI
import UIComponents
import XUI

struct AnalysisListView: View {
	@Store var viewModel: SoundsCoordinator

	@Binding var showSheetView: Bool
	@Binding var audioPlayer: AVAudioPlayer

	let result: [SoundAnalysisResult]
	let fileName: String
	let endDate: Date?

	var body: some View {
		NavigationView {
			ZStack {
				ColorsRepository.General.appBackground
					.edgesIgnoringSafeArea(.all)

				ScrollView(.vertical, showsIndicators: false) {
					VStack(alignment: .center, spacing: 2) {
						SectionNameTextView(text: "Recognized sounds",
						                    color: ColorsRepository.Text.standard)
							.padding([.top, .bottom])

						ForEach(result, id: \.self) { item in
							VStack {
                                CardTitleView(with: .init(leadIcon: IconsRepository.waveform,
                                                          title: item.soundType,
                                                          description: String(format: "%.2f%% confidence", item.confidence),
                                                          trailIcon: nil,
                                                          trailText: self.getDescription(item: item, date: endDate),
                                                          titleColor: ColorsRepository.General.mainSleepy,
                                                          descriptionColor: ColorsRepository.Text.secondary,
                                                          shouldShowSeparator: false))

								AudioPlayerView(audioPlayer: self.$audioPlayer,
								                playAtTime: item.start,
								                endAtTime: item.end,
								                audioName: fileName)
                            }.roundedCardBackground(color: ColorsRepository.Card.cardBackground)
						}

						if result.isEmpty {
							Text("No sound recognized. You can try to lower recognisition confidence coefficient in your settings")
								.underline()
								.onTapGesture(perform: self.openSettings)
						}
					}
				}
			}
			.onDisappear(perform: self.stopAudioPlayer)
			.navigationTitle(endDate?.getFormattedDate(format: "MMM d") ?? "")
			.navigationBarItems(trailing: Button("Done", action: { showSheetView = false }))
		}
	}

	private func getDescription(item: SoundAnalysisResult, date: Date?) -> String? {
		if let startDate = date,
		   let startDate = Calendar.current.date(byAdding: .second, value: -Int(item.end - item.start), to: startDate) {
			return startDate.getFormattedDate(format: "HH:mm")
		}
		return nil
	}

	private func openSettings() {
		self.showSheetView = false
		self.viewModel.openSettings()
	}

	private func stopAudioPlayer() {
		self.audioPlayer.stop()
	}
}
