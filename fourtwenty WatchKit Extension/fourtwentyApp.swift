//
//  fourtwentyApp.swift
//  fourtwenty WatchKit Extension
//
//  Created by Ryuji Ganaha on 4/9/22.
//

import SwiftUI

@main
struct fourtwentyApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
