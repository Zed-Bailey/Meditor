//
//  MeditorDocument.swift
//  Meditor
//
//  Created by Zed on 6/3/2022.
//

import SwiftUI
import UniformTypeIdentifiers

// https://daringfireball.net/linked/2011/08/05/markdown-uti
extension UTType {
    static var md: UTType {
        UTType(importedAs: "net.daringfireball.markdown")
    }
}


struct MeditorDocument: FileDocument {
    var text: String
    var fileName: String?
    
    init(text: String = "Hello, world!") {
        self.text = text
    }

    static var readableContentTypes: [UTType] { [.md] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8),
              let name = configuration.file.filename
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        text = string
        fileName = name
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = text.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
    
    ///Triggers a save, returns true on success
    func triggerSave() -> Bool {
        //https://stackoverflow.com/questions/68522523/in-a-swiftui-document-app-how-to-save-a-document-from-within-a-function
        return NSApp.sendAction(#selector(NSDocument.save(_:)), to: nil, from: nil)
    }
}
