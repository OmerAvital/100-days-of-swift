//
//  Dice.swift
//  Dice
//
//  Created by Omer Avital on 6/16/22.
//

import CoreHaptics
import SwiftUI

@MainActor class Dice: ObservableObject {
    @Published private(set) var previousRolls: [DieResult]
    @Published var preferences: Preferences {
        didSet {
            _ = preferencesSaver.save(preferences)
            result = nil
        }
    }
    @Published private(set) var result: DieResult?
    @Published private(set) var isFinalResult = false
    
    var lastRoll: DieResult {
        previousRolls.first ?? DieResult.example
    }
    
    private let rollSaver: DataSaver<[DieResult]>
    private let preferencesSaver: DataSaver<Preferences>
    
    private var rollTimer: Timer?
    private var hapticEngine: CHHapticEngine?
    
    init() {
        rollSaver = DataSaver(fileName: "previousRoles", conformingTo: .json)
        preferencesSaver = DataSaver(fileName: "preferences", conformingTo: .json)
        
        previousRolls = rollSaver.load() ?? []
        preferences = preferencesSaver.load() ?? Preferences()
        
        if !CHHapticEngine.capabilitiesForHardware().supportsHaptics {
            preferences.haptics = false
        }
        
        prepareHaptics()
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("There was an error creating the haptic engine: \(error.localizedDescription)")
        }
    }
    
    private func rollHaptic() {
        guard preferences.haptics else { return }
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        let parameters = [
            CHHapticEventParameter(parameterID: .hapticIntensity, value: 1),
            CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        ]
        
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: parameters, relativeTime: 0)
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription)")
        }
    }
    
    func saveRoll() {
        isFinalResult = true
        
        guard let result = result else { return }
        
        withAnimation {
            previousRolls.insert(result, at: 0)
            trimExtraSavedRolls()
        }
    }
    
    func trimExtraSavedRolls() {
        withAnimation {
            if previousRolls.count > preferences.maxPreviousRolls {
                previousRolls.removeSubrange(preferences.maxPreviousRolls...)
            }
        }
        
        _ = rollSaver.save(self.previousRolls)
    }
    
    private func rollDie() {
        self.rollHaptic()
        let newResult = DieResult(with: self.preferences)
        self.result = newResult
    }
    
    func roll() {
        if let timer = rollTimer {
            timer.invalidate()
            saveRoll()
        }
        
        isFinalResult = false
        
        if UIAccessibility.isVoiceOverRunning {
            rollDie()
            return
        }
        
        var timesRun = 1
        let maxRuns = Int.random(in: 10...15)
        
        rollTimer = Timer.scheduledTimer(withTimeInterval: 0.075, repeats: true) { timer in
            self.rollDie()
            timesRun += 1
            
            if timesRun > maxRuns {
                timer.invalidate()
                self.rollTimer = nil
                self.saveRoll()
            }
        }
    }
    
    func clearPreviousRolls() {
        previousRolls = []
        _ = rollSaver.save(previousRolls)
    }
}
