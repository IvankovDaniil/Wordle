//
//  WorldeGame.swift
//  Wordle
//
//  Created by Даниил Иваньков on 07.02.2025.
//

import Foundation
import SwiftUI

enum WordleStatus {
    case maxAttempt
    case minLetter
    case win
    case cantFindInDictionary
}

@Observable
class WorldeGame {
    var grid: [[LetterCell]] = Array(
        repeating: Array(repeating: LetterCell(), count: 5),
        count: 6)
    var keyColors: [String: Color] = [:]
    var curRow = 0
    var curCell = 0
    var isShowAlertsMinLetter = false
    var isShowAlertsAttempting = false
    var isWin = false
    var isCantFindWord = false
    
    var targetWord: [String] = []
    
    //Загружаем наш словарь
    private static let dictionary: [String] = {
        guard let url = Bundle.main.url(forResource: "russian", withExtension: "txt") else {
            return []
        }
        
        do {
            let content = try String(contentsOf: url, encoding: .utf8).uppercased()
            
            return content.components(separatedBy: .newlines)
        } catch {
            print("ERROR")
            return []
        }
    }()
    
    init() {    
        self.restartGame()
    }
    
    func submitGuess() {
        let guess = grid[curRow].map { $0.letter }.joined()
        if guess.count < 5 {
            showAlerts(for: .minLetter)
            return
        }
        
        guard Self.dictionary.contains(guess) else {
            showAlerts(for: .cantFindInDictionary)
            return
        }
        
        for (index, letter) in guess.enumerated() {
            let char = String(letter)
            if targetWord[index] == char {
                grid[curRow][index].status = .correct
                keyColors[char] = .wordGreen
            } else if targetWord.contains(char) {
                grid[curRow][index].status = .missplaced
                if keyColors[char] != .wordGreen {
                    keyColors[char] = .wordBlue
                }
            } else {
                grid[curRow][index].status = .wrong
                keyColors[char] = .mainWordle
            }
        }
        
        if targetWord.map({String($0)}).joined() == guess {
            showAlerts(for: .win)
            return
        }
        
        if curRow == 5 {
            showAlerts(for: .maxAttempt)
            return
        }
        
        curRow += 1
        curCell = 0
    }
    
    
    func insertLetter(letter: String) {
        if curCell < 5 {
            if grid[curRow][curCell].letter.isEmpty {
                grid[curRow][curCell].letter = letter
                curCell += 1
            }
        }
    }
    
    func deleteLetter() {
        if curCell > 0 {
            if !grid[curRow][curCell-1].letter.isEmpty {
                grid[curRow][curCell-1].letter = ""
                curCell -= 1
            }
        }
    }
    
    func showAlerts(for status: WordleStatus) {
        switch status {
            
        case .maxAttempt:
            isShowAlertsAttempting = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isShowAlertsAttempting = false
                self.restartGame()
            }

        case .minLetter:
            isShowAlertsMinLetter = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isShowAlertsMinLetter = false
            }
        case .win:
            isWin = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isWin = false
                self.restartGame()
            }
            
        case .cantFindInDictionary:
            isCantFindWord = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isCantFindWord = false
                
            }
        }
    }
    
    func restartGame() {
        self.grid = Array(
            repeating: Array(repeating: LetterCell(), count: 5),
            count: 6)
        self.keyColors = [:]
        self.curRow = 0
        self.curCell = 0
        self.targetWord = generateRandomWords()
    }
    
    func showTargetWord() -> String {
        targetWord.map { $0 }.joined()
    }
    
    private func generateRandomWords() -> [String] {
        let word = Self.dictionary.randomElement()?.uppercased() ?? "АНИМЕ"
        return word.map { String($0) }
    }
    
}

struct LetterCell {
    var letter: String = ""
    var status: LetterStatus = .empty
}

enum LetterStatus {
    case empty, correct, missplaced, wrong
}
