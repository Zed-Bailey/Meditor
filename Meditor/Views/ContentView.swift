//
//  ContentView.swift
//  Meditor
//
//  Created by Zed on 6/3/2022.
//

import SwiftUI
import Ink
import WebKit
import SwiftDown
import AlertToast


/*
 TODO: Documentation
 TODO: Auto resize window to double the width when the render button is clicked, resize back when it's un toggled
 */

struct ContentView: View {
    @Binding var document: MeditorDocument
    // inject user settings into the view
    @EnvironmentObject var settings: SettingsModel
    
    @State var showRenderView = false
    @State var showThemeChangeToast = false
    @State var exportToFile = ExportTo.NONE
    
    @State var exportedToFile = false
    @State var exportSuccess = false
    @State var exportMessage = ""
    
    let MDThemes: MarkDownThemes = MarkDownThemes.shared

    var body: some View {

        ZStack {
            VStack{
                ToolbarComponent(showRenderView: $showRenderView, settings: _settings, renderThemes: self.MDThemes.ThemeNameList, showThemeChangeToast: $showThemeChangeToast, exportToFile: $exportToFile)
                    .padding(.all, 15)
                    .padding(.top, 5)
                 HStack {
                
                     SwiftDownEditor(text: $document.text)
                         .insetsSize(40)
                         .theme(settings.GetTheme(name: settings.editorTheme))
                         .padding(.leading, 15)

                 
                     RenderView(documentText: $document.text, showRenderView: $showRenderView, renderTheme: MDThemes.GetTheme(name: $settings.markdownTheme.wrappedValue))
                         .padding([.leading, .bottom], 5)
                 }
            }.toast(isPresenting: $showThemeChangeToast) {
                    //TODO: test different alert types
                AlertToast(displayMode: .banner(.pop), type: .complete(.green), title: "Theme changed!", subTitle: "reopen window for it to take effect")
                    
            }
            .toast(isPresenting: $exportedToFile, duration: 4) {
                AlertToast(displayMode: .alert,
                           type: exportSuccess ? .complete(.green) : .error(.red),
                           title:exportSuccess ? "Exported!" : "Error exporting file",
                           subTitle: self.exportMessage
                )
            }
            

        }.onChange(of: exportToFile) { _ in
            if !self.document.triggerSave(){
                exportSuccess = false
                exportMessage = "Failed to autosave file"
                exportedToFile.toggle()
            }
            var success: Bool = false
            var message: String = ""
            switch exportToFile {
                case .PDF:
                    let html = MarkdownToHtml.Convert(markdown: document.text, theme: MDThemes.GetTheme(name: $settings.markdownTheme.wrappedValue))
                    (success, message) = ExportFunctions.ExportPDF(html: html, fileName: document.fileName ?? "untitled.pdf")
                    break
                case .HTML:
                    let html = MarkdownToHtml.Convert(markdown: document.text, theme: MDThemes.GetTheme(name: $settings.markdownTheme.wrappedValue))
                    (success, message) = ExportFunctions.ExportHTML(html: html)
                    break
                case .TEXT:
                    (success, message) = ExportFunctions.ExportText(markdown: document.text)
                    break
                default:
                    print("not implemented yet")
                    return
            }
            exportSuccess = success
            exportMessage = message
            exportedToFile.toggle()
            exportToFile = .NONE
        }
    }
}




    ///https://github.com/onmyway133/blog/issues/730
//    struct AttributedTextView: NSViewRepresentable {
//        typealias NSViewType = NSScrollView
//
//        let attributedText: NSAttributedString?
//        let isSelectable: Bool
//        var insetSize: CGSize = .zero
//
//        func makeNSView(context: Context) -> NSViewType {
//            let scrollView = NSTextView.scrollableTextView()
//
//            let textView = scrollView.documentView as! NSTextView
//            textView.drawsBackground = true
//            textView.textColor = .controlTextColor
//            textView.textContainerInset = insetSize
//            return scrollView
//        }
//
//        func updateNSView(_ nsView: NSViewType, context: Context) {
//            let textView = (nsView.documentView as! NSTextView)
//            textView.isSelectable = isSelectable
//
//            if let attributedText = attributedText,
//                attributedText != textView.attributedString() {
//                textView.textStorage?.setAttributedString(attributedText)
//            }
//
//            if let lineLimit = context.environment.lineLimit {
//                textView.textContainer?.maximumNumberOfLines = lineLimit
//            }
//        }
//    }
//                AttributedTextView(attributedText: $attributed.wrappedValue, isSelectable: true)
//                    .onAppear {
//                        $attributed.wrappedValue = ConvertToAttributedString(html: html)
//                    }
//                    .onChange(of: $MarkdownTheme.wrappedValue) { _ in
//                        // this will force a re-render
//                        $attributed.wrappedValue = ConvertToAttributedString(html: html)
//                    }
//    @State var attributed: NSAttributedString = NSAttributedString()
//    private func ConvertToAttributedString(html:String) -> NSAttributedString {
//        let htmlData = Data(html.utf8)
//        if let attribHtml = try? NSAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
//            return attribHtml
//        }
//        return NSAttributedString()
//    }
