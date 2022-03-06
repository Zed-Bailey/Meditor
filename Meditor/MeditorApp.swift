//
//  MeditorApp.swift
//  Meditor
//
//  Created by Zed on 6/3/2022.
//

import SwiftUI

@main
struct MeditorApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: MeditorDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
