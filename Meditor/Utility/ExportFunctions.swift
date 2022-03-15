//
//  ConvertToPDF.swift
//  Meditor
//
//  Created by Zed on 8/3/2022.
//

import Foundation
import Cocoa
import TPPDF





extension String {
    /// extract the string from between 2 strings
    /// https://stackoverflow.com/a/31727051
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    
    ///https://stackoverflow.com/a/65167409
    /// same as slice, but returns multiple
    func sliceMultipleTimes(from: String, to: String) -> [String] {
           components(separatedBy: from).dropFirst().compactMap { sub in
               (sub.range(of: to)?.lowerBound).flatMap { endRange in
                   String(sub[sub.startIndex ..< endRange])
               }
           }
       }
}

class ExportFunctions {

    static func ExportPDF(html: String, fileName file: String) -> (Bool, String) {
        let htmlData = Data(html.utf8)
        var backgroundColour = Color.white

        if let stylesheet = html.slice(from: "<style>", to: "</style>") {
            print("extracted  stylesheet \(stylesheet)")

            // extract body from stylesheet
            let bodies = stylesheet.sliceMultipleTimes(from: "body {", to: "}")
            for body in bodies {
                let attributes = body.split(separator: ";")
                for attribute in attributes {
                    if attribute.contains("background") {
                        let hex = String(attribute.split(separator: ":")[1]) // eg. background: #12345 -> ['background : #', ' 12345']
                        print("hex colour: \(hex)")

                        // https://stackoverflow.com/a/33397427
                        var int = UInt64()
                        Scanner(string: hex).scanHexInt64(&int)
                        let (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
                        backgroundColour = Color(red: CGFloat(r) / 255 , green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)

                        // exit
                        break
                    }
                }
            }


        }

        // convert html to attributed string
//         [.documentType: NSAttributedString.DocumentType.html]
        if let attribHtml = try? NSAttributedString(data: htmlData, options:[:], documentAttributes: nil) {
            do {

                let document = PDFDocument(format: .a4)

                // create a group and adjust the background color
                // https://github.com/techprimate/TPPDF/blob/master/Documentation/Usage.md#groups
                let group = PDFGroup(backgroundColor: backgroundColour, padding: .init(top: 5, left: 5, bottom: 5, right: 5))
                
                group.add(attributedText: attribHtml)

                // add group to document
                document.add(group: group)



                let generator = PDFGenerator(document: document)

                // create url to desktop
                let desktop = NSHomeDirectory() + "/Desktop/" + file.replacingOccurrences(of: ".md", with: ".pdf")

                // generate url on desktop
                try generator.generate(to: URL(fileURLWithPath: desktop))
                print("PDF generated, url=\(desktop)")
                return (true, "Exported pdf to \(desktop)")
            } catch let error {
                print("ERROR -> \(error)")
                return (false, "\(error)")
            }
        }
        return (false, "failed to parse markdown")
    }
    
    static func ExportHTML(html: String) -> (Bool, String) {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        let done = pasteboard.setString(html, forType: .string)
        return (done, done ? "Copied to clipboard!" : "Failed to copy to clipboard")
    }
    
    static func ExportText(markdown: String) -> (Bool, String) {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        let done = pasteboard.setString(markdown, forType: .string)
        return (done, done ? "Copied to clipboard!" : "Failed to copy to clipboard")
    }
}
