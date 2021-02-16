//
//  TimerApp.swift
//  Timer
//
//  Created by Michele Manniello on 15/02/21.
//

import SwiftUI

@main
struct TimerApp: App {
    @StateObject var data = TimerData()
//    Using Scene Phase For scene Data
    @Environment(\.scenePhase) var scene
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(data)
        }
        .onChange(of: scene) { (newScene) in
            if newScene == .background{
//            storing Time
                data.leftTime = Date()
            }
            if newScene == .active && data.time != 0{
//                when it enter checking the difference....
                let diff = Date().timeIntervalSince(data.leftTime)
                let currentTime = data.selectedTime - Int(diff)
                if currentTime >= 0{
                    withAnimation(.default){
                        data.selectedTime = currentTime
                    }
                }else{
//                    Resetting View
                    data.resetView()
                }
            }
        }
    }
}
