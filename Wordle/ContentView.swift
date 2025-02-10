//
//  ContentView.swift
//  Wordle
//
//  Created by Даниил Иваньков on 06.02.2025.
//

import SwiftUI

struct ContentView: View {
    @State var game = WorldeGame()
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                ForEach(0...5, id: \.self) { row in
                    HStack(spacing: 15) {
                        ForEach(0...4, id: \.self) { col in
                            WordSquare(letter: $game.grid[row][col])
                        }
                    }
                }
                Spacer()
                Keyboard(game: $game)
            }
            .overlay(
                Text("Слово должно содержать 5 букв")
                    .showAlerts(game.isShowAlertsMinLetter)
                
            )
            .overlay(
                VStack {
                    Text("Вы проиграли")
                    Text("Загаданное слово - \(game.showTargetWord())")
                }
                    .showAlerts(game.isShowAlertsAttempting)
            )
            .overlay(
                Text("Вы выйграли")
                    .showAlerts(game.isWin)
                
            )
            .overlay(content: {
                Text("Нет такого слова в словаре")
                    .showAlerts(game.isCantFindWord)
            })
            .padding(.top, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.mainBg)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    // TimerView()
                    Text("1'23\"")
                        .font(Font.custom("Chalkboard SE", size: 20))
                }
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 0) {
                        Text("Уровень")
                        Text(" #1")
                            .font(Font.custom("Chalkboard SE", size: 20))
                        
                    }
                }
            })
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct WordSquare: View {
    @Binding var letter: LetterCell
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(.mainWordle)
                .frame(width: 60, height: 60)
            RoundedRectangle(cornerRadius: 5)
                .fill(setColorForSquare(letter.status))
                .frame(width: 45, height: 45)
            Text("\(letter.letter)")
                .font(.system(size: 40, weight: .bold))
        }
    }
    
    func setColorForSquare(_ status: LetterStatus) -> Color {
        
        switch status {
            
        case .empty:
            Color.white
        case .correct:
            Color.wordGreen
        case .missplaced:
            Color.wordBlue
        case .wrong:
            Color.mainWordle
        }
    }
}

private struct Keyboard: View {
    let keys = ["ЙЦУКЕНГШЩЗХЪ", "ФЫВАПРОЛДЖЭ", "ЯЧСМИТЬБЮ12"]
    @Binding var game: WorldeGame
    
    var body: some View {
        VStack(spacing: 6) {
            ForEach(keys, id: \.self) { row in
                HStack(spacing: 4) {
                    ForEach(row.map { String($0) }, id: \.self) { letter in
                        let color = game.keyColors[letter] ?? Color.white
                        Group {
                            if letter == "1" {
                                Button {
                                    game.deleteLetter()
                                } label: {
                                    Image(systemName: "delete.left")
                                }
                            } else if letter == "2" {
                                Button {
                                    game.submitGuess()
                                } label: {
                                    Text("OK")
                                }
                            }  else {
                                Button {
                                    game.insertLetter(letter: letter)
                                } label: {
                                    Text(String(letter))
                                }
                                
                            }
                        }
                        .frame(width: 28, height: 40)
                        .background(color)
                        .clipShape(Capsule())
                        .font(.system(size: 14))
                        .foregroundStyle(.black)
                        
                        
                    }
                    
                }
            }
        }
    }
}


#Preview {
    NavigationStack {
        ContentView()
    }
}
