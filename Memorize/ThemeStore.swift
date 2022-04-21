//
//  ThemeChooserVM.swift
//  Memorize
//
//  Created by Flynn Traeger on 13/05/2021.
//

import Foundation

import SwiftUI

struct Theme: Identifiable, Codable, Hashable {
    var name: String
    var emojis: [String]
    var pairs: Int
    var themeColor: UIColor.RGB
    var id: Int
    
    fileprivate init(name: String, emojis: [String], pairs: Int, themeColor: UIColor.RGB, id: Int) {
        self.name = name
        self.emojis = emojis
        self.pairs = pairs
        self.themeColor = themeColor
        self.id = id
    }
}

class ThemeStore: ObservableObject {
    let name: String
    
    @Published var themes = [Theme]() {
        didSet {
            storeInUserDefaults()
        }
    }
    
    private var userDefaultsKey: String {
        "ThemeStore:" + name
    }
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(themes), forKey: userDefaultsKey)
    }
    
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedThemes = try? JSONDecoder().decode(Array<Theme>.self, from: jsonData) {
            themes = decodedThemes
        }
    }
    
    let vehicles_set = ["🚗", "✈️", "🚁", "🚀", "🚜", "🏎", "⛵️", "🛥", "🛶", "🚂", "🚢", "🏍"].shuffled() //draw red
    let nature_set = ["🌋", "🏔", "🏝", "🏜", "🌧", "❄️", "☀️", "🌈", "🌪"].shuffled() //draw blue
    let faces_set = ["😀", "🥰", "🤪", "☹️", "😠", "🥺", "😳", "🥲", "😂", "🤯", "😱"].shuffled() //draw yellow
    let animals_set = ["🐶", "🐭", "🦊", "🐻", "🐼", "🐸", "🐷", "🐥", "🐵", "🦁", "🐨"].shuffled() //draw green
    let food_set = ["🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍆", "🥝", "🫐", "🥑", "🍠"].shuffled() //draw orange
    let flags_set =  ["🏴‍☠️", "🇦🇩", "🇦🇹", "🇦🇺", "🇺🇸", "🏴󠁧󠁢󠁳󠁣󠁴󠁿", "🏴󠁧󠁢󠁷󠁬󠁳󠁿", "🇬🇧", "🇷🇺", "🇳🇿", "🇳🇱", "🇬🇷", "🇭🇷"].shuffled() //draw purple
    
    init(named name: String) {
        self.name = name
        if themes.isEmpty {
            insertTheme(named: "Vehicles", emojis: vehicles_set, pairs: 5, themeColor: UIColor.RGB(red: 0.6, green: 0.3, blue: 0.1, alpha: 1.0))
            insertTheme(named: "Nature", emojis: nature_set, pairs: 5, themeColor: UIColor.RGB(red: 0.6, green: 0.3, blue: 0.1, alpha: 1.0))
            insertTheme(named: "Faces", emojis: faces_set, pairs: 5, themeColor: UIColor.RGB(red: 0.6, green: 0.3, blue: 0.1, alpha: 1.0))
            insertTheme(named: "Animals", emojis: animals_set, pairs: 5, themeColor: UIColor.RGB(red: 0.6, green: 0.3, blue: 0.1, alpha: 1.0))
            insertTheme(named: "Food", emojis: food_set, pairs: 5, themeColor: UIColor.RGB(red: 0.6, green: 0.3, blue: 0.1, alpha: 1.0))
            insertTheme(named: "Flags", emojis: flags_set, pairs: 5, themeColor: UIColor.RGB(red: 0.6, green: 0.3, blue: 0.1, alpha: 1.0))
        }
    }

    // MARK: - Intent

    func theme(at index: Int) -> Theme {
        let safeIndex = min(max(index, 0), themes.count - 1)
        return themes[safeIndex]
    }

    @discardableResult
    func removePalette(at index: Int) -> Int {
        if themes.count > 1, themes.indices.contains(index) {
            themes.remove(at: index)
        }
        return index % themes.count
    }

    func insertTheme(named name: String, emojis: [String]? = nil, pairs: Int, themeColor: UIColor.RGB, at index: Int = 0) {
        let unique = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        let theme = Theme(name: name, emojis: emojis ?? [""], pairs: pairs, themeColor: themeColor, id: unique)
        let safeIndex = min(max(index, 0), themes.count)
        themes.insert(theme, at: safeIndex)
    }
}
