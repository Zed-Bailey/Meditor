//
//  ContentView.swift
//  Meditor
//
//  Created by Zed on 6/3/2022.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: MeditorDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(MeditorDocument()))
    }
}
