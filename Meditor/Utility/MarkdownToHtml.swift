//
//  MarkdownToHtml.swift
//  Meditor
//
//  Created by Zed on 13/3/2022.
//

import Foundation
import Ink

class MarkdownToHtml {
    static let MDParser = MarkdownParser()
    
    static func Convert(markdown:String, theme:String ) -> String {
//        var renderTheme: String
        /// Markdown parser instance
        
        
        /// Parses markdown into html using the Ink library, returns html as a string
//        var html: String {
            
            let result = MDParser.html(from: markdown)
            
            // wrap the generated html in a body and add styling tags
            // the web view will now render the html styled however we want
            return """
            <!doctype html>
             <html>
                <head>
                  <style>
                      \(theme)
                  </style>
                </head>
                <body>
                  \(result)
                </body>
              </html>
            """
//        }
    }
}
