//
//  AlarmModel.swift
//  Sleepy_WatchOS Extension
//
//  Created by Анас Бен Мустафа on 9/27/21.
//

import Foundation
import WatchKit
import HealthKit

final class SmartAlarmModel: NSObject {

    private var session: WKExtendedRuntimeSession = WKExtendedRuntimeSession()
    private var healthStore: HKHealthStore = HKHealthStore()
    private let healthManager: HealthManager = HealthManager()
    private var didDetectedLightPhase: Bool = false
    private var seconds: Int = 1560 // Equals to 26 mins
    private var timer: Timer?

    required override init() {
        super.init()
        healthManager.delegate = self
    }

    // MARK: Methods

    func deactivateAlarm() {
        guard
            session.state == .scheduled || session.state == .running
        else {
            return
        }
        session.invalidate()
        print("Session was successfully deactivated")
    }

    func activateAlarm(alarmEnd: Date) -> Bool {
        guard
            alarmEnd.minutes(from: Date()) >= 29,
            let scheduledTime = Calendar.current.date(byAdding: .minute, value: -28, to: alarmEnd)
        else {
            return false
        }
        setSessionStartDate(at: scheduledTime)
        return true
    }

    // MARK: Private methods

    private func setSessionStartDate(at scheduledTime: Date) {
        session = WKExtendedRuntimeSession()
        session.delegate = self
        session.start(at: scheduledTime)
        print("Session was succesfully set to run at \(scheduledTime)")
    }

    private func runVibration() {
        UserSettings.isAlarmSet = false
        session.notifyUser(hapticType: .notification) { (_) -> TimeInterval in
            return 2.5
        }
    }

    private func startTimer() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.timer = Timer.scheduledTimer(
                timeInterval: 1,
                target: self,
                selector: #selector(self.updateTimer),
                userInfo: nil,
                repeats: true
            )
            self.timer?.fire()
        }
    }

    @objc
    private func updateTimer() {
        guard seconds != 0 else {
            timer?.invalidate()
            runVibration()
            return
        }
        seconds -= 1
    }

}

// MARK: HealthManagerDelegate

extension SmartAlarmModel: HealthManagerDelegate {

    func lightPhaseDetected() {
        print("HealthManagerDelegate detected light phase")
        didDetectedLightPhase = true
        runVibration()
    }

}

// MARK: WKExtendedRuntimeSessionDelegate

extension SmartAlarmModel: WKExtendedRuntimeSessionDelegate {

    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("RuntimeSession did start")
        healthManager.subscribeToHeartBeatChanges()
        startTimer()
    }

    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("extendedRuntimeSession will expire")
        UserSettings.isAlarmSet = false
    }

    func extendedRuntimeSession(
        _ extendedRuntimeSession: WKExtendedRuntimeSession,
        didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason,
        error: Error?
    ) {
        UserSettings.isAlarmSet = false
    }

}

// MARK: WKExtensionDelegate

extension SmartAlarmModel: WKExtensionDelegate {

    // The system calls this method after launching your app in response to a scheduled extended runtime session.
    // This occurs if your app terminates after scheduling a session but before that session’s start date.
    // The system may also call this method if your app crashes during an extended runtime session, letting you resume that session.
    // When implementing this method, set the session’s delegate to resume the session.
    // If you do not set the session’s delegate, the system ends the session.
    func handle(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        extendedRuntimeSession.delegate = self
        session = extendedRuntimeSession
    }

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

}
