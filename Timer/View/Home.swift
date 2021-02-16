//
//  Home.swift
//  Timer
//
//  Created by Michele Manniello on 15/02/21.
//

import SwiftUI
//sending notification
import UserNotifications

struct Home: View {
    @EnvironmentObject var data : TimerData
    var body: some View {
        ZStack {
            VStack{
                Spacer()
                ScrollView(.horizontal, showsIndicators: false, content: {
                    HStack(spacing : 20 ){
                        ForEach(1...6,id: \.self){ index in
                         let time = index * 5
                            Text("\(time)")
                                .font(.system(size: 45,weight:.heavy))
                                .frame(width: 100, height: 100)
    //                            cambio colore per la selezione
                                .background(data.time == time ? Color.red:Color.blue)
                                .foregroundColor(Color.white)
                                .clipShape(Circle())
                                .onTapGesture {
                                    withAnimation{
                                        data.time = time
                                        data.selectedTime = time
                                    }
                                }
                        }
                    }
                    .padding()
                })
    //            centriamo
                .offset(y:40)
                .opacity(data.buttonAnmation ? 0:1)
                Spacer()
    //            Start Button
                Button(action: {
                    withAnimation(Animation.easeInOut(duration: 0.65)){
                        data.buttonAnmation.toggle()
                    }
//                    Delay animation...
//                    After Button Goes down View is moving up..
                    withAnimation(Animation.easeIn.delay(0.6)){
                        data.timeViewOffset = 0
                    }
                    performNotifications()
                }, label: {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 80, height: 80)
                })
                .padding(.bottom,35)
    //            dsabilitiamo
                .disabled(data.time == 0)
                .opacity(data.time == 0 ? 0.6 : 1)
    //            Moving down smoothly
                .offset(y: data.buttonAnmation ? 300 : 0)
            }
            Color.red
                .overlay(
                Text("\(data.selectedTime)")
                    .font(.system(size: 55,weight:.heavy))
                    .foregroundColor(.white)
            )
//                Decreasing Height For Each Count
                .frame(height: UIScreen.main.bounds.height - data.timerHeightChange)
                .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .bottom)
                .ignoresSafeArea(.all,edges: .all)
                
            .offset(y: data.timeViewOffset)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.ignoresSafeArea(.all,edges: .all))
//        Timer  Functionality
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect(), perform: { _ in
            if data.time != 0 && data.selectedTime != 0 && data.buttonAnmation{
//                Counting Timer
                data.selectedTime -= 1
//                Updating Height...
                let ProgressHeight = UIScreen.main.bounds.height / CGFloat(data.time)
                let diff = data.time - data.selectedTime
                
                withAnimation(.default){
                    data.timerHeightChange = CGFloat(diff) * ProgressHeight
                }
                if data.selectedTime == 0{
//                    Resetting
                    data.resetView()
                }
            }
        })
        .onAppear(perform: {
//            premission
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert]) { (_, _) in
            }
//            Setting Delegate For In - App Notifications....
            UNUserNotificationCenter.current().delegate = data
        })
    }
    func performNotifications(){
        let content = UNMutableNotificationContent()
        content.title = "Notification From Michele Manniello"
        content.body = "Timer Has Been Finished!"
//        Triggring At Selected Timer...
//        for eg 5 seconds means after 5 seconds ....
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(data.time), repeats: false)
        let request = UNNotificationRequest(identifier: "TIMER", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (err) in
            if err != nil{
                print(err!.localizedDescription)
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
