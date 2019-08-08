//
//  ViewController.swift
//  Concentration
//
//  Created by Madalina Sinca on 01/07/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1 ) / 2)
    
    //var flipCount = 0 { didSet { flipCountLabel.text = "Flips: \(flipCount)" } }
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var newGameButton: UIButton!
    
    private var emojiChoices = [String]()
    
    private var emoji = [Card:String]()

    private let gameTheme = ["flags":       ["🇧🇷", "🇧🇪", "🇯🇵", "🇨🇦", "🇺🇸", "🇵🇪", "🇮🇪", "🇦🇷"],
                     "faces":       ["😀", "🙄", "😡", "🤢", "🤡", "😱", "😍", "🤠"],
                     "sports":      ["🏌️", "🤼‍♂️", "🥋", "🏹", "🥊", "🏊", "🤾🏿‍♂️", "🏇🏿"],
                     "animals":     ["🦊", "🐼", "🦁", "🐘", "🐓", "🦀", "🐷", "🦉"],
                     "fruits":      ["🥑", "🍍", "🍆", "🍠", "🍉", "🍇", "🥝", "🍒"],
                     "appliances":  ["💻", "🖥", "⌚️", "☎️", "🖨", "🖱", "📱", "⌨️"]]
    
    private let gameBackgroundColor = ["flags":       #colorLiteral(red: 0.9029450762, green: 0.9984180331, blue: 0.9052613646, alpha: 1),
                               "faces":       #colorLiteral(red: 0.9764705896, green: 0.9112239829, blue: 0.7712850951, alpha: 1),
                               "sports":      #colorLiteral(red: 0.6874793981, green: 0.8951661441, blue: 0.9764705896, alpha: 1),
                               "animals":     #colorLiteral(red: 0.9568627477, green: 0.8139937659, blue: 0.7588721059, alpha: 1),
                               "fruits":      #colorLiteral(red: 0.7586845559, green: 0.8862745166, blue: 0.7254639859, alpha: 1),
                               "appliances":  #colorLiteral(red: 0.6413674627, green: 0.7296561239, blue: 0.7568627596, alpha: 1)]
    
    private let gameCardColor = ["flags":      #colorLiteral(red: 0.3455402499, green: 0.9984180331, blue: 0.7153486602, alpha: 1),
                        "faces":       #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),
                        "sports":      #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),
                        "animals":     #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),
                        "fruits":      #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1),
                        "appliances":  #colorLiteral(red: 0.3752103863, green: 0.5510096898, blue: 0.7568627596, alpha: 1)]
    
    private var choseThemeAlready = false
    
    private var buttonsColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    private var backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chooseRandomTheme()
    }
    @IBAction private func touchCard(_ sender: UIButton) {
        if !choseThemeAlready {
            chooseRandomTheme()
        }
        
        //viewDidLoad()
        
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            
            // only increase flip count if the card is unmatched
            if !game.cards[cardNumber].isMatched {
                game.increaseFlipCount()
            }
        }
        
        scoreLabel.text = "Score: \(game.score)"
        flipCountLabel.text = "Flips: \(game.flipsCount)"
    }
    
    private func updateViewFromModel() {
        
        newGameButton.backgroundColor = buttonsColor
        newGameButton.setTitleColor(backgroundColor, for: UIControlState.normal)
        
        flipCountLabel.textColor = buttonsColor
        scoreLabel.textColor = buttonsColor
        
        self.view.backgroundColor = backgroundColor
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : buttonsColor
            }
        }
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            // let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        return emoji[card] ?? "?"
    }
    
    @IBAction private func newGame(_ sender: Any) {
        game.resetFlipCount()
        emojiChoices.removeAll()
        game.score = 0
        scoreLabel.text = "Score: 0"
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            
            button.setTitle("", for: UIControlState.normal)
            button.backgroundColor = #colorLiteral(red: 0.4612599015, green: 0.7726664543, blue: 1, alpha: 1)
        }
        
        emoji.removeAll()
        
        game.resetGame()
        chooseRandomTheme()
        game.shuffleCards()
        updateViewFromModel()
    }
    
    private func chooseRandomTheme() {
        emojiChoices.removeAll()
        
        let gameThemeKeys  = Array(gameTheme.keys)
        let gameThemeIndex = Int(arc4random_uniform(UInt32(gameThemeKeys.count)))
        emojiChoices = Array(gameTheme.values)[gameThemeIndex]
        
        backgroundColor = Array(gameBackgroundColor.values)[gameThemeIndex]
        buttonsColor = Array(gameCardColor.values)[gameThemeIndex]
        
        for index in 0..<emojiChoices.count {
            print("\(emojiChoices[index])")
        }
        
        choseThemeAlready = true
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

