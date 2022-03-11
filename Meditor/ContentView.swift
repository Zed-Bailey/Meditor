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
 */

struct ContentView: View {
    @Binding var document: MeditorDocument
    // inject user settings into the view
    @EnvironmentObject var settings: SettingsModel
    
    @State var showRenderView = false
    @State var showThemeChangeToast = false
    
    let MDThemes: MarkDownThemes = MarkDownThemes()
    
    /// Markdown parser instance
    let MDParser = MarkdownParser()
    
    /// Parses markdown into html using the Ink library, returns html as a string
    var html: String {
        
        let result = MDParser.html(from: document.text)
        
        // wrap the generated html in a body and add styling tags
        // the web view will now render the html stylede however we want
        return """
        <!doctype html>
         <html>
            <head>
              <style>
                  \(MDThemes.GetTheme(name: $settings.markdownTheme.wrappedValue))
              </style>
            </head>
            <body>
              \(result)
            </body>
          </html>
        """
    }

    var body: some View {
        
         VStack{
             Toolbar()
             HStack {
            
                 SwiftDownEditor(text: $document.text)
                     .insetsSize(40)
//                     .theme(settings.GetTheme(name: settings.editorTheme))
                     .theme(Theme.BuiltIn.defaultLight.theme())
                     .padding(10)
             
                 
                if showRenderView {
                    WebView(html: html)
                }
             }
        }
    }
    //TODO: extract to own file
    func Toolbar() -> some View {
        
        return HStack {
            Button {
                showRenderView.toggle()
            } label: {
                Text("Show Render")
            }.frame(width: 100)
            .padding(.all, 5.0)

            
            Menu{
                // TODO: Add actions to export
                Button("PDF", action: {})
                Button("HTML", action: {})
//                Button("LaTex", action: {}) // TODO: Future feature?
                Button("Text", action: {})
            } label: {
                Label("Export", systemImage: "square.and.arrow.up")
            }.menuStyle(BorderlessButtonMenuStyle())
            .frame(width: 100)
            .padding(.all, 5.0)
            
            //
            Menu{
                ForEach(Array(settings.AvailableThemes.keys), id: \.self) { theme in
                    Button(action: {
                        
                        settings.editorTheme = theme
                        
                    }, label: {
                        Text("\(theme.capitalized)")
                    }).tag(theme)
                }
            } label: {
                Text("Editor Themes")
            }.menuStyle(BorderlessButtonMenuStyle())
            .frame(width: 100)
            .padding(.all, 5.0)
            
            //
            Menu{
                ForEach(MDThemes.ThemeNameList, id: \.self) { theme in
                    Button(action: {
                        print("before")
                        $settings.markdownTheme.wrappedValue = theme
                        print("afer")
                    }, label: {
                        Label("\(theme.capitalized)", systemImage: "paintbrush.pointed")
                    }).tag(theme)
                }
            } label: {
                Text("Markdown Themes")
            }.menuStyle(BorderlessButtonMenuStyle())
            .frame(width: 150)
            .padding(.all, 5.0)
            
            Spacer()
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



////
//struct ContentView_Previews: PreviewProvider {
//    static let settings = SettingsModel()
//
//    static var previews: some View {
//        ContentView(document: .constant(MeditorDocument()), settings: .init())
////            .environmentObject(settings)
//    }
//}


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
