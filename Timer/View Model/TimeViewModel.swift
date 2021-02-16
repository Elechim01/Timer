//
//  TimeViewModel.swift
//  Timer
//
//  Created by Michele Manniello on 15/02/21.
//

import Foundation
import SwiftUI
import UserNotifications
// Timer Model and Data
class TimerData: NSObject,UNUserNotificationCenterDelegate ,ObservableObject {
    @Published var time : Int = 0
    @Published var selectedTime : Int = 0
//    animation propieties...
    @Published var buttonAnmation = false
//    Timer View data
    @Published var timeViewOffset : CGFloat = UIScreen.main.bounds.height
    @Published var timerHeightChange : CGFloat = 0
//    Getting Time When It Leaves The App
    @Published var leftTime : Date = Date()
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        Telling What To do When Receives in foregorund
        completionHandler([.banner,.sound])
    }
//    on tap
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        when tapped resetting view
        completionHandler()
    }
    func resetView(){
        withAnimation(.default){
        time = 0
        selectedTime = 0
        timerHeightChange = 0
        timeViewOffset = UIScreen.main.bounds.height
        buttonAnmation = false
        }
    }
}
