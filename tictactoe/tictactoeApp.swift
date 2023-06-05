//
//  tictactoeApp.swift
//  tictactoe
//
//  Created by Alex de la Rosa on 6/4/23.
//

import SwiftUI
import ComposableArchitecture

@main
struct tictactoeApp: App {
    var body: some Scene {
        WindowGroup {
            GameView(
                store: Store(initialState: TicTacToeFeature.State()) {
                    TicTacToeFeature()
                }
            )
        }
    }
}
