//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Flynn Traeger on 29/03/2021.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var store = ThemeStore(named: "Standard")
    var body: some Scene {
        WindowGroup {
            ThemeManager().environmentObject(store)
        }
    }
}
