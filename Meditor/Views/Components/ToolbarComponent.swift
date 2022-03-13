//
//  ToolbarComponent.swift
//  Meditor
//
//  Created by Zed on 12/3/2022.
//

import SwiftUI



/// The Toolbar componet
struct ToolbarComponent: View {
    /// boolean binding, on button click should show rendered markdown in web view
    @Binding var showRenderView: Bool
    @EnvironmentObject var settings: SettingsModel
    var renderThemes: [String]
    @Binding var showThemeChangeToast: Bool
    
    var body: some View {
        HStack {
            Button {
                showRenderView.toggle()
                
            } label: {
                Text("Show Render")
            }.frame(width: 100)
            .padding(.leading, 5.0)

            
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
            .padding(.leading, 5.0)
            //
            Menu{
                ForEach(Array(settings.AvailableThemes.keys), id: \.self) { theme in
                    Button(action: {
                        
                        settings.editorTheme = theme
                        showThemeChangeToast.toggle()
                    }, label: {
                        Text("\(theme.capitalized)")
                    }).tag(theme)
                }
            } label: {
                Text("Editor Themes")
            }.menuStyle(BorderlessButtonMenuStyle())
            .frame(width: 100)
            .padding(.leading, 5.0)
            
            if showRenderView {
                Menu {
                    ForEach(renderThemes, id: \.self) { theme in
                        Button(action: {
                            settings.markdownTheme = theme
                        }, label: {
                            Label("\(theme.capitalized)", systemImage: "paintbrush.pointed")
                        }).tag(theme)
                    }
                } label: {
                    Text("Markdown Themes")
                }.menuStyle(BorderlessButtonMenuStyle())
                .frame(width: 150)
                .padding(.leading, 5.0)
            }
            Spacer()
        }
        .background(
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.blue)
                .frame(height: 30)
        )
       
        
        
    }
}

//struct ToolbarComponent_Previews: PreviewProvider {
//    @State static var render = false
//    @State static var settings = StaticSettingsModel()
//    @State static var md = MarkDownThemes()
//
//    static var previews: some View {
//
//        ToolbarComponent(showRenderView: $render, settings: $settings, MDThemes: $md)
//    }
//}
