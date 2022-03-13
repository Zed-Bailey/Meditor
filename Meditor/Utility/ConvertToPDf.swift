//
//  ConvertToPDF.swift
//  Meditor
//
//  Created by Zed on 8/3/2022.
//

import Foundation
import Cocoa
import TPPDF





class ConvertToPDf {

    static func CreatePDf(html: String, fileName file: String) -> (Bool, String) {
        
        let htmlData = Data(html.utf8)
        

        if let attribHtml = try? NSAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            do {
                let document = PDFDocument(format: .a4)
                document.add(attributedText: attribHtml)
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
}
