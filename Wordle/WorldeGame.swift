//
//  WorldeGame.swift
//  Wordle
//
//  Created by Даниил Иваньков on 07.02.2025.
//

import Foundation
import SwiftUI

@Observable
class WorldeGame {
    var grid: [[LetterCell]] = Array(
        repeating: Array(repeating: LetterCell(), count: 5),
        count: 6)
    var keyColors: [String: Color] = [:]
    var curRow = 0
    var curCell = 0
    
    private let targetWord: [String]
    init(targetWord: [String]) {
        self.targetWord = targetWord
    }
    
    func submitGuess() {
        let guess = grid[curRow].map { $0.letter }.joined()
        if guess.count < 5 {
            print("Слово должно состоять из 5 букв")
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
    
}

struct LetterCell {
    var letter: String = ""
    var status: LetterStatus = .empty
}

enum LetterStatus {
    case empty, correct, missplaced, wrong
}
