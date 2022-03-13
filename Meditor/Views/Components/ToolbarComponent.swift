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
    @Binding var exportToFile: ExportTo
    
    var body: some View {
        HStack {
            Button {
                showRenderView.toggle()
                
            } label: {
                Text("Show Render")
            }
            .frame(width: 100)
            .buttonStyle(BorderlessButtonStyle())
            .padding(.leading, 5.0)
            

            
            Menu{
                Button("PDF",  action: { exportToFile = .PDF  })
                Button("HTML", action: { exportToFile = .HTML })
                Button("Text", action: { exportToFile = .TEXT })
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
                .frame(height: 35)
        )
       
        
        
    }
}
