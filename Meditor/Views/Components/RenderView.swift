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
    
    var body: some View {
        if showRenderView {
            WebView(html: MarkdownToHtml.Convert(markdown: documentText, theme: renderTheme))
        }
    }
}

//struct RenderView_Previews: PreviewProvider {
//    static var previews: some View {
//        RenderView()
//    }
//}
