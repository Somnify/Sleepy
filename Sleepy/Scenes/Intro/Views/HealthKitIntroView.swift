// Copyright (c) 2022 Sleepy.

import FirebaseAnalytics
import HKCoreSleep
import SwiftUI
import UIComponents

struct HealthKitIntroView: View {
    @Binding var shouldShowIntro: Bool
    @State private var index = 0
    @State private var shouldShowNextTab = false

    private let images = ["tutorial3", "tutorial4"]

    var body: some View {
        ZStack {
            ColorsRepository.General.appBackground
                .edgesIgnoringSafeArea(.all)
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        PaginationView(index: $index.animation(), maxIndex: images.count - 1) {
                            ForEach(self.images, id: \.self) { imageName in
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(1.21, contentMode: .fit)
                                    .cornerRadius(12)
                            }
                        }
                        .aspectRatio(1.21, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 15))

                        WelcomeScreenLineView(
                            title: "Access required",
                            subTitle: "Health data is used for analysis.",
                            imageName: "heart.text.square.fill",
                            color: ColorsRepository.General.mainSleepy
                        )

                        WelcomeScreenLineView(
                            title: "We don't keep your data",
                            subTitle: "It is processed locally and is not uploaded to servers.",
                            imageName: "wifi.slash",
                            color: ColorsRepository.General.mainSleepy
                        )

                    }.padding(.top, 16)
                }.padding([.leading, .trailing], 16)

                if !shouldShowNextTab {
                    Text("Grant access")
                        .customButton(color: ColorsRepository.General.mainSleepy)
                        .onTapGesture {
                            HKService.requestPermissions { result, error in
                                guard error == nil, result
                                else {
                                    return
                                }
                                shouldShowNextTab = true
                            }
                        }
                }

                if shouldShowNextTab {
                    NavigationLink(destination: NotificationsIntroView(shouldShowIntro: $shouldShowIntro), isActive: $shouldShowNextTab)
                        {
                            Text("Continue")
                                .customButton(color: ColorsRepository.General.mainSleepy)
                        }
                }
            }
        }
        .navigationTitle("Access to Health")
        .onAppear(perform: self.sendAnalytics)
    }

    private func sendAnalytics() {
        FirebaseAnalytics.Analytics.logEvent("HealthKitIntroView_viewed", parameters: nil)
    }
}
