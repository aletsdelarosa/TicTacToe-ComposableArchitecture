//
//  TicTacToeFeature.swift
//  tictactoe
//
//  Created by Alex de la Rosa on 6/4/23.
//

import ComposableArchitecture

enum Player: String {
    case X
    case O
}

struct Tile: Equatable {
    let row: Int
    let column: Int
}

class TicTacToeFeature: ReducerProtocol {
    struct State: Equatable {
        var currentPlayer: Player = .X
        var board: [[Player?]] = Array(repeating: Array(repeating: nil, count: 3), count: 3)
        var gameEnded = false
        var winner: Player? = nil
        var playerXPoints: Int = 0
        var playerOPoints: Int = 0
    }
    
    enum Action: Equatable {
        case tileSelected(Tile)
        case resetGame
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .tileSelected(let tile):
            return tileSelected(state: &state, tile: tile)
        case .resetGame:
            state.currentPlayer = .X
            state.board = Array(repeating: Array(repeating: nil, count: 3), count: 3)
            state.gameEnded = false
            state.winner = nil
            
            return .none
        }
    }
    
    private func tileSelected(state: inout State, tile: Tile) -> EffectTask<Action> {
        if state.board[tile.row][tile.column] == nil && !state.gameEnded {
            state.board[tile.row][tile.column] = state.currentPlayer
            let win = checkForWin(board: state.board, currentPlayer: state.currentPlayer)
            
            if win {
                if state.currentPlayer == .O {
                    state.playerOPoints += 1
                }
                else {
                    state.playerXPoints += 1
                }
                
                state.winner = state.currentPlayer
                state.gameEnded = true
            }
            else {
                let draw = checkForDraw(board: state.board)
                
                if draw {
                    state.gameEnded = true
                }
                else {
                    state.currentPlayer = state.currentPlayer == .X ? .O : .X
                }
            }
        }
        
        return .none
    }
    
    private func checkForWin(board: [[Player?]], currentPlayer: Player) -> Bool {
        let winPatterns: Set<Set<[Int]>> = [
            [[0, 0], [0, 1], [0, 2]],
            [[1, 0], [1, 1], [1, 2]],
            [[2, 0], [2, 1], [2, 2]],
            [[0, 0], [1, 0], [2, 0]],
            [[0, 1], [1, 1], [2, 1]],
            [[0, 2], [1, 2], [2, 2]],
            [[0, 0], [1, 1], [2, 2]],
            [[0, 2], [1, 1], [2, 0]]
        ]
        
        for pattern in winPatterns {
            var playerWins = true
            for position in pattern {
                if board[position[0]][position[1]] != currentPlayer {
                    playerWins = false
                    break
                }
            }
            if playerWins {
                return true
            }
        }
        
        return false
    }
        
    private func checkForDraw(board: [[Player?]]) -> Bool {
        for row in 0..<3 {
            for column in 0..<3 {
                if board[row][column] == nil {
                    return false
                }
            }
        }
        
        return true
    }
}
