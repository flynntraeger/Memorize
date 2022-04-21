//
//  ThemeManager.swift
//  Memorize
//
//  Created by Flynn Traeger on 13/05/2021.
//

import SwiftUI

struct ThemeManager: View {
    @EnvironmentObject var store: ThemeStore
    
    // a Binding to a PresentationMode
    // which lets us dismiss() ourselves if we are isPresented
    @Environment(\.presentationMode) var presentationMode
    
    // we inject a Binding to this in the environment for the List and EditButton
    // using the \.editMode in EnvironmentValues
    @State private var editMode: EditMode = .inactive
    @State private var changing = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(destination: EmojiMemoryGameView(game: EmojiMemoryGame(theme: theme))) {
                        VStack(alignment: .leading) {
                            Text(theme.name)
                            Text(theme.emojis.joined())
                        }
                        .gesture(editMode == .active ? tap : nil)
                    }
                    .sheet(isPresented: $changing) {
                        ThemeEditor(theme: $store.themes[theme])
                    }
                }
                // teach the ForEach how to delete items
                // at the indices in indexSet from its array
                .onDelete { indexSet in
                    store.themes.remove(atOffsets: indexSet)
                }
                // teach the ForEach how to move items
                // at the indices in indexSet to a newOffset in its array
                .onMove { indexSet, newOffset in
                    store.themes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
            }
            .navigationTitle("Manage Themes")
            .navigationBarTitleDisplayMode(.inline)
            // add an EditButton on the trailing side of our NavigationView
            // and a Close button on the leading side
            // notice we are adding this .toolbar to the List
            // (not to the NavigationView)
            // (NavigationView looks at the View it is currently showing for toolbar info)
            // (ditto title and titledisplaymode above)
            .toolbar {
                ToolbarItem { EditButton() }
                ToolbarItem(placement: .navigationBarLeading) {
                    if presentationMode.wrappedValue.isPresented,
                       UIDevice.current.userInterfaceIdiom != .pad {
                        Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        store.insertTheme(named: "New Theme", emojis: nil, pairs: 0, themeColor: UIColor.RGB(red: 1, green: 1, blue: 1, alpha: 1))
                    }, label: {
                        Image(systemName: "plus.circle")
                    })
                }
            }
            // see comment for editMode @State above
            .environment(\.editMode, $editMode)
        }
    }
    
    var tap: some Gesture {
        if editMode == .inactive {
            return TapGesture().onEnded { }
        } else {
            changing = true
            return TapGesture().onEnded { }
        }
    }
}

struct ThemeManager_Previews: PreviewProvider {
    static var previews: some View {
        ThemeManager()
            .previewDevice("iPhone 8")
            .environmentObject(ThemeStore(named: "Preview"))
            .preferredColorScheme(.light)
    }
}

struct ThemeManagerPreview: PreviewProvider {
    static var previews: some View {
        ThemeManager()
            .previewDevice("iPhone 8")
            .environmentObject(ThemeStore(named: "Prevdiew"))
            .preferredColorScheme(.light)
    }
}
