//
//  Main.swift
//  Wandra
//
//  Created by Mikael Löfgren on 2021-02-23.
//  Sound effects obtained from https://www.zapsplat.com

import SwiftUI

@main
struct Main: App {

  var body: some Scene {
    
    WindowGroup {
            ContentView()
            // https://developer.apple.com/documentation/swiftui/commandgroupplacement
        }.commands {
            // Remove App menu items
            CommandGroup(replacing: .appInfo) {
                    }
            CommandGroup(replacing: .systemServices) {
                    }
            CommandGroup(replacing: .appVisibility) {
                    }
            // Remove File menu items
            CommandGroup(replacing: .newItem) {
                    }
            // Remove Edit menu items
            CommandGroup(replacing: .undoRedo) {
                    }
            // Remove Window menu items Bring to front
            CommandGroup(replacing: .windowList) {
                   }
            CommandGroup(replacing: .windowArrangement) {
                    }
            CommandGroup(replacing: .windowSize) {
                    }
           // Remove Help menu items
            CommandGroup(replacing: .help) {
                    }
            }
        // Hide the Title Bar
       .windowStyle(HiddenTitleBarWindowStyle())
        
        // Show the Title Bar but no Title, kept as reference
        //.windowToolbarStyle(UnifiedWindowToolbarStyle(showsTitle: false))
    }
}




