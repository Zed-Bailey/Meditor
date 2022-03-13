//
//  RenderView.swift
//  Meditor
//
//  Created by Zed on 12/3/2022.
//

import SwiftUI
import Ink

struct RenderView: View {
    @EnvironmentObject var settings: SettingsModel
    @Binding var documentText: String
    @Binding var showRenderView: Bool
    var renderTheme: String
    /// Markdown parser instance
    let MDParser = MarkdownParser()
    
    /// Parses markdown into html using the Ink library, returns html as a string
    var html: String {
        
        let result = MDParser.html(from: documentText)
        
        // wrap the generated html in a body and add styling tags
        // the web view will now render the html stylede however we want
        return """
        <!doctype html>
         <html>
            <head>
              <style>
                  \(renderTheme)
              </style>
            </head>
            <body>
              \(result)
            </body>
          </html>
        """
    }
    
    var body: some View {
        if showRenderView {
            WebView(html: html)
        }
    }
}

//struct RenderView_Previews: PreviewProvider {
//    static var previews: some View {
//        RenderView()
//    }
//}
