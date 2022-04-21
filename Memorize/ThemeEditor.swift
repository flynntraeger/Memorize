//
//  ThemeEditor.swift
//  Memorize
//
//  Created by Flynn Traeger on 13/05/2021.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme  //@Binding lets it edit something that's somewhere else
    
    var body: some View {
        Form {
            nameSection
            pairSection
//            colorSection
            addEmojisSection
            removeEmojiSection
        }
        .navigationTitle("Edit \(theme.name)")
        .frame(minWidth: 300, minHeight: 350)
    }
    
    var nameSection: some View {
        Section(header: Text("Name")) {
            TextField("Name", text: $theme.name)
        }
    }
    
    var pairSection: some View {
        Section(header: Text("Number of pairs")) {
            HStack {
                TextField("Pairs: ", value: $theme.pairs, formatter: NumberFormatter())
                Stepper("", onIncrement: {
                    if theme.pairs < theme.emojis.count {
                        theme.pairs += 1
                    }
                }, onDecrement: {
                    if theme.pairs > 0 {
                        theme.pairs -= 1
                    }
                })
            }
        }
    }
//    @State private var selectedColor = Color(UIColor.RGB(red: theme.themeColor.red, green: theme.themeColor.green, blue: theme.themeColor.blue, alpha: theme.themeColor.alpha))
//
//    var colorSection: some View {
//        Section(header: Text("Select color")) {
//            ColorPicker("\(theme.name) theme color", selection: $selectedColor)
//        }
//    }
//
    @State private var emojisToAdd = String()
    
    var addEmojisSection: some View {
        Section(header: Text("Add Emojis")) {
            TextField("", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emojis in
                    addEmojis(emojis)
                }
        }
    }
    
    func addEmojis(_ emojis: String) {
        withAnimation {
            theme.emojis.append(emojis)
//                .filter { $0.isEmoji }
//                .removingDuplicateCharacters
        }
    }
    
    var removeEmojiSection: some View {
        Section(header: Text("Remove Emoji")) {
            let emojis = theme.emojis.map { String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                theme.emojis.removeAll(where: { String($0) == emoji })
                            }
                        }
                }
            }
            .font(.system(size: 40))
        }
    }
}

struct ThemeEditor_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditor(theme: .constant(ThemeStore(named: "Preview").theme(at: 4)))
            .previewLayout(.fixed(width: 300, height: 350))
    }
}
