//
//  Themes.swift
//  Meditor
//
//  Created by Zed on 10/3/2022.
//

import Foundation

    
/// Themes taken from https://github.com/jasonm23/markdown-css-themes/blob/gh-pages/markdown-alt.css
class MarkDownThemes {

    /// dictionairy of theme name keu and css data value
    private var themeCssDict: [String: String] = [:]
    
    /// list of all available themes
    public var ThemeNameList: [String] = []
    
    init() {
        // load the css files in
        let themeFiles = Bundle.main.paths(forResourcesOfType: "css", inDirectory: nil)
        print("available themes -> \(themeFiles)")
        for file in themeFiles {
            let url = URL(fileURLWithPath: file)
            let data = try! Data(contentsOf: url)
            // remove the file extension
            let filename = url.lastPathComponent.replacingOccurrences(of: ".css", with: "")
            
            self.ThemeNameList.append(filename)
            self.themeCssDict[filename] = String(decoding: data, as: UTF8.self)
        }
        // sorts theme names alphabetically
        self.ThemeNameList.sort(by:<)
    }
    
    /// returns the default theme
    func DefaultTheme() -> String {
        return self.themeCssDict["markdown"] ?? ""
    }
    
    /// Pass in theme name, returns css theme as a string
    /// Returns the deafult theme if no match was found in the dictionary
    func GetTheme(name: String) -> String {
        return self.themeCssDict[name] ?? DefaultTheme()
    }
}
