//
//  SettingsView.swift
//  Meditor
//
//  Created by Zed on 11/3/2022.
//

import SwiftUI
import Preferences

//TODO: Move editor/markdown theme and background colour settings here
struct SettingsView: View {
    private let paneWidth = 450.0
    
    var body: some View {
        Preferences.Container(contentWidth: paneWidth) {
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
