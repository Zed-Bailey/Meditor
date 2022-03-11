//
//  SettingsStructure.swift
//  Meditor
//
//  Created by Zed on 10/3/2022.
//

import Foundation
//import CodeEditor
//import Highlightr
import SwiftUI
import SwiftDown



class SettingsModel: ObservableObject {
//    use app storage to store user settings, now i dont have to mess around with coredata and they are automatically updated on state change
    @AppStorage("markdownTheme") var markdownTheme = "markdown"
    @AppStorage("editorTheme") var editorTheme = "default-dark"
    // Themes should be saved in the Resources/Themes group
    private let customThemeNames = ["github-dark"]
    var AvailableThemes: [String:Theme] = ["default-dark": Theme.BuiltIn.defaultDark.theme(), "default-light": Theme.BuiltIn.defaultLight.theme()]
//    [:]
    
    
    init() {
        print("[MEDITOR] Settings Model initalized")
        print("Current markdown theme: \(self.markdownTheme)")
        print("Current editor theme: \(self.editorTheme)")
        loadCustomThemes()
    }
    
    private func loadCustomThemes() {
        for themeName in self.customThemeNames {
            if let path = Bundle.main.path(forResource: themeName, ofType: "json") {
                self.AvailableThemes[themeName] = Theme(themePath: path)
                print("[MEDITOR] initalized custom theme \(themeName)")
            }
        }
    }
    
    public func GetTheme(name: String) -> Theme {
        
        if let theme = self.AvailableThemes[name] {
            print("got new theme \(name)")
            return theme
        }
        print("return default theme")
          return Theme.BuiltIn.defaultDark.theme()
    }
}
