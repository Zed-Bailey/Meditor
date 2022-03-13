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
 FIXME: Figure out why the markdown themes are being reloaded from file whenever menu option is changed
 */

struct ContentView: View {
    @Binding var document: MeditorDocument
    // inject user settings into the view
    @EnvironmentObject var settings: SettingsModel
    
    @State var showRenderView = false
    @State var showThemeChangeToast = false
    
    @State var currentMarkdownTheme = "markdown"
    
    let MDThemes: MarkDownThemes = MarkDownThemes()

    var body: some View {

        ZStack {
            VStack{
                ToolbarComponent(showRenderView: $showRenderView, settings: _settings, renderThemes: self.MDThemes.ThemeNameList, showThemeChangeToast: $showThemeChangeToast)
                    .padding([.top, .leading, .trailing], 5)
                 HStack {
                
                     SwiftDownEditor(text: $document.text)
                         .insetsSize(40)
                         .theme(settings.GetTheme(name: settings.editorTheme))
                         .padding(10)
                 
                     RenderView(documentText: $document.text, showRenderView: $showRenderView, renderTheme: MDThemes.GetTheme(name: $settings.markdownTheme.wrappedValue))
                         .padding([.leading, .bottom], 5)
                 }
            }.toast(isPresenting: $showThemeChangeToast) {
                    //TODO: test different alert types
                    AlertToast(displayMode: .banner(.slide), type: .regular, title: "Theme changed!", subTitle: "reopen window for it to take effect")
                }
             
        }
    }
    


    
    func createPDF() {
        
        if self.document.triggerSave() {
//            let dialog = NSSavePanel()
//            dialog.title = "Choose PDF Save Location"
//            dialog.begin { (result) -> Void in
//                if result == .OK {
//                    let defaultUrl = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0].appendingPathComponent("Untitled").appendingPathExtension("pdf")
//
//                    var savePath = dialog.url?.deletingPathExtension()
//                    savePath = savePath?.appendingPathExtension("pdf")
//
//                    ConvertToPDf.CreatePDf(html: html, fileName: savePath ?? defaultUrl)
//                }
//            }
            
//            ConvertToPDf.CreatePDFPrint(html: html)
            print("document saved")

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
