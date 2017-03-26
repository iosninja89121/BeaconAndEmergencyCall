


//This Code will change as project builds on, these notifiations are used to invoke app from background state.
import Foundation
import UIKit
import AVFoundation
import UserNotifications
import UserNotificationsUI

class LocalNotifications {
    
    static func setup() {
//        let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        
        // added by admin (2017.3.9)
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            
            if granted {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        // -----------------
    }
    
    @available(iOS 10.0, *)
    static func scheduleNotification(_ message: String) {
//        // by admin(2017.3.11)
//        // Requests the notification settings for this app.
//        guard let settings = UIApplication.shared.currentUserNotificationSettings else { return }
//        
//        print("settings.types -> ", settings.types)
//        print("types -> ", UIUserNotificationType())
//        
//        if settings.types == UIUserNotificationType() {
//            print("LocalNotifications:\nStalker does not have permission to schedule notifications.")
//            //return    // by admin (2017.3.9)
//        }
//        
//        
//        let notification = UILocalNotification()
//        notification.fireDate = Date(timeIntervalSinceNow: 1)
//        notification.alertBody = message
//        notification.alertAction = "Go to App"
//        notification.hasAction = true
//        notification.soundName = UILocalNotificationDefaultSoundName
//        notification.userInfo = ["originalMessage": message]
//     
//        
//        // this should be probably handled more gracefully
//        notification.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
//        
//        UIApplication.shared.scheduleLocalNotification(notification)
        
        // by admin(2017.3.11)
        let center = UNUserNotificationCenter.current()
        center.delegate = UYLNotificationDelegate()
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
                print("Notifications not allowed")
                //return  // for future extension
            }
        }
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization( options: options,
                            completionHandler: { ( granted, error) in
                                if !granted {
                                    print("LocalNotifications:\nStalker does not have permission to schedule notifications.")
                                }
                            }
        )
        
        let content = UNMutableNotificationContent()
        content.title = "Don't forget"
        content.body = message
        content.userInfo = ["originalMessage": message]
        content.sound = UNNotificationSound.default()
        
        // for timer
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30,                                                        repeats: false)
        
        let date = Date(timeIntervalSinceNow: 30)
        
        // for oneshot
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,                                                    repeats: false)
        
        // for daily repeat
        //let triggerDaily = Calendar.current.dateComponents([hour,.minute,.second,], from: date)
        //let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        
        // for weekday repeat
        //let triggerWeekly = Calendar.current.dateComponents([.weekday,hour,.minute,.second,], from: date)
        //let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
        
        //let trigger = UNLocationNotificationTrigger(triggerWithRegion:region, repeats:false)
        
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                // Something went wrong
                print("add failure")
            }
        })

        //------------------
    }
    
    static func removeAppIconBadge() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
}

class UYLNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent")
        
        // Play sound and show alert to the user
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceive")
        
        // Determine the user action
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Snooze":
            print("Snooze")
        case "Delete":
            print("Delete")  
        default:
            print("Unknown action")
        }
        completionHandler()
    }
}
