//
//  ConvertToPDF.swift
//  Meditor
//
//  Created by Zed on 8/3/2022.
//

import Foundation
import Cocoa
import WebKit
import CoreGraphics
import AppKit


class ConvertToPDf {

    
    static func CreatePDFPrint(html: String) {
        let webView = WKWebView()
        webView.loadHTMLString(html, baseURL: nil)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            let printOpts = [NSPrintInfo.AttributeKey.jobDisposition : NSPrintInfo.JobDisposition.save as Any]
            let printInfo: NSPrintInfo = NSPrintInfo(dictionary: printOpts)
            printInfo.paperSize = NSMakeSize(595.22, 841.85)
            printInfo.topMargin = 10.0
            printInfo.leftMargin = 10.0
            printInfo.rightMargin = 10.0
            printInfo.bottomMargin = 10.0
//            let printOp: NSPrintOperation = NSPrintOperation(view: webView, printInfo: printInfo)
//            let printOp: NSPrintOperation = NSPrintOperation(view: webView.frameView.documentView, printInfo: printInfo)
//            printOp.showsPrintPanel = false
//            printOp.showsProgressPanel = false
            
//            printOp.run()
            let operation = webView.printOperation(with: printInfo)
            operation.showsPrintPanel = false
            operation.showsProgressPanel = false
//            operation.view?.knowsPageRange(<#T##NSRangePointer#>)
            operation.run()
        }
    }
        
    static func CreatePDf(html: String, fileName file:URL) {

        
        print("file path: \(file)")
        
        
        
        
        let pageSize = CGSize(width: 595.2, height: 841.8)
        let pageMargins = NSEdgeInsets(top: 72, left: 72, bottom: 72, right: 72)
        
        let printableRect = CGRect(x: pageMargins.left, y: pageMargins.top, width: pageSize.width - pageMargins.left - pageMargins.right, height: pageSize.height - pageMargins.top - pageMargins.bottom)
        
        let htmlData = Data(html.utf8)
        

        if let attribHtml = try? NSAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            //    https://developer.apple.com/forums/thread/661460
            //MARK: setup pdf context
            let data = NSMutableData()
            let consumer = CGDataConsumer(data: data as CFMutableData)!
            var mediaBox = printableRect
            let context = CGContext(consumer: consumer, mediaBox: &mediaBox, nil)!

            NSGraphicsContext.current = NSGraphicsContext(cgContext: context, flipped: false)

            // MARK: Render PDF

            context.beginPDFPage(nil)
            attribHtml.draw(in: printableRect)
            context.endPDFPage()
            context.closePDF()

            // MARK: Save PDF
            try! data.write(to: file, options: [.atomic])
        }
        
        
        
        
        
}
        
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                //https://www.hackingwithswift.com/articles/161/how-to-use-result-in-swift
//                webView.createPDF(configuration: pdfConfiguration) { result in
//                    switch result {
//                        case .success(let data):
//                            do {
//                                try data.write(to: fullUrl, options: [.atomic])
//                                print("saved pdf successfully!")
//                            } catch let error {
//                                print("Error saving pdf: \(error)")
//                            }
//
//                        case .failure(let error):
//                            print("error converting to pdf: \(error)")
//                    }
//                }
//        }
        
    }
    
//    init(fileName: String) {
//        // get the url for the desktop directory
//        let url = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0].absoluteString
//        self.exportUrl = URL(fileURLWithPath: url + fileName)
//        print(self.exportUrl)
//    }
//
//    func convert(html htmlString: String) {
//        // https://www.hackingwithswift.com/example-code/uikit/how-to-render-an-nsattributedstring-to-a-pdf
//        // https://www.hackingwithswift.com/example-code/system/how-to-convert-html-to-an-nsattributedstring
//        let data = Data(htmlString.utf8)
//
//        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
//
//        }
//    }

