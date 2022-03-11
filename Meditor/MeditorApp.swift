//
//  MeditorApp.swift
//  Meditor
//
//  Created by Zed on 6/3/2022.
//

import SwiftUI
//App Sandbox Boolean YES
@main
struct MeditorApp: App {
    // create a settings object
    @StateObject var settings = SettingsModel()
    
    var body: some Scene {
        DocumentGroup(newDocument: MeditorDocument()) { file in
            ContentView(document: file.$document)
                .environmentObject(settings)
        }
    }
}
