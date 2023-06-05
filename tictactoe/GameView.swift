//
//  GameView.swift
//  tictactoe
//
//  Created by Alex de la Rosa on 6/4/23.
//

import SwiftUI
import ComposableArchitecture

struct GameView: View {
    
    let store: StoreOf<TicTacToeFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    Text("Tic Tac Toe")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button {
                        viewStore.send(.resetGame)
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.largeTitle)
                    }
                }
                .padding()
                
                Spacer()
                
                Text("Current player: \(viewStore.currentPlayer.rawValue)")
                    .font(.title3)
                    .fontWeight(.medium)
                
                Spacer()
                
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                    ForEach(0..<3, id: \.self) { row in
                        ForEach(0..<3, id: \.self) { column in
                            Button(action: {
                                viewStore.send(.tileSelected(Tile(row: row, column: column)))
                            }) {
                                Text(viewStore.board[row][column]?.rawValue ?? "")
                                    .font(.system(size: 80))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .aspectRatio(1.0, contentMode: .fill)
                                    .foregroundColor(.black)
                                    .background(Color.gray.opacity(0.2).cornerRadius(20.0))
                            }
                        }
                    }
                }
                .padding()
                
                Spacer()
                
                Text(viewStore.winner != nil ? "Player \(viewStore.winner!.rawValue) wins!" : "It's a draw!")
                    .font(.title)
                    .padding()
                    .opacity(viewStore.gameEnded ? 1 : 0)
                
                Spacer()
                
                HStack {
                    Text("Player X: ")
                    Text("\(viewStore.playerXPoints)")
                        .fontWeight(.bold)
                    Spacer()
                    Text("Player O: ")
                    Text("\(viewStore.playerOPoints)")
                        .fontWeight(.bold)
                }
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(
            store: Store(initialState: TicTacToeFeature.State()) {
                TicTacToeFeature()
            }
        )
    }
}
