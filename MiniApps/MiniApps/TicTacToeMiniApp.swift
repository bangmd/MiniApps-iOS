import UIKit

class TicTacToeViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.text = "Крестики-Нолики"
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        titleLabel.textColor = .blackCl
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var scoreLabel: UILabel = {
        var scoreLabel = UILabel()
        scoreLabel.text = "Счет: X - 0 | O - 0"
        scoreLabel.textAlignment = .center
        scoreLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        return scoreLabel
    }()
    
    private lazy var statusLabel: UILabel = {
        var statusLabel = UILabel()
        statusLabel.text = "Ходит игрок: X"
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.systemFont(ofSize: 24)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        return statusLabel
    }()
    
    private lazy var resetButton: UIButton = {
        var resetButton = UIButton(type: .system)
        resetButton.setTitle("Сыграть еще", for: .normal)
        resetButton.setTitleColor(.whiteCl, for: .normal)
        resetButton.layer.cornerRadius = 16
        resetButton.backgroundColor = .blackCl
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        resetButton.addTarget(self, action: #selector(resetGame), for: .touchUpInside)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.isHidden = true
        return resetButton
    }()
    
    private lazy var gridStackView: UIStackView = {
        var gridStackView = UIStackView()
        gridStackView.axis = .vertical
        gridStackView.distribution = .fillEqually
        gridStackView.translatesAutoresizingMaskIntoConstraints = false
        gridStackView.layer.borderWidth = 5
        gridStackView.layer.borderColor = UIColor.lightGray.cgColor
        gridStackView.layer.cornerRadius = 10
        return gridStackView
    }()
    
    private lazy var exitButton: UIButton = {
        var exitButton = UIButton(type: .system)
        exitButton.setTitle("Вернуться назад", for: .normal)
        exitButton.setTitleColor(.black, for: .normal)
        exitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        exitButton.backgroundColor = .clear
        exitButton.layer.borderWidth = 2
        exitButton.layer.borderColor = UIColor.lightGray.cgColor
        exitButton.layer.cornerRadius = 16
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: #selector(exitButtonDidTapped), for: .touchUpInside)
        return exitButton
    }()
    
    
    private var gameState = [Int](repeating: 0, count: 9)
    private var currentPlayer = 1
    private var scoreX = 0
    private var scoreO = 0
    var buttons: [UIButton] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteCl
        configure()
    }
    
    private func configure() {
        view.addSubview(gridStackView)
        
        for row in 0..<3 {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.distribution = .fillEqually
            rowStackView.translatesAutoresizingMaskIntoConstraints = false
            gridStackView.addArrangedSubview(rowStackView)
            
            for col in 0..<3 {
                let button = UIButton(type: .system)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
                button.setTitle("", for: .normal)
                button.tag = row * 3 + col
                button.addTarget(self, action: #selector(tileTapped(_:)), for: .touchUpInside)
                
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.lightGray.cgColor
                button.layer.cornerRadius = 10
                
                buttons.append(button)
                rowStackView.addArrangedSubview(button)
            }
        }
        
        view.addSubview(titleLabel)
        view.addSubview(scoreLabel)
        view.addSubview(statusLabel)
        view.addSubview(resetButton)
        view.addSubview(exitButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            gridStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gridStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gridStackView.heightAnchor.constraint(equalTo: gridStackView.widthAnchor),
            gridStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            gridStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            scoreLabel.bottomAnchor.constraint(equalTo: gridStackView.topAnchor, constant: -10),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            statusLabel.bottomAnchor.constraint(equalTo: scoreLabel.topAnchor, constant: -10),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            resetButton.topAnchor.constraint(equalTo: gridStackView.bottomAnchor, constant: 20),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.heightAnchor.constraint(equalToConstant: 60),
            resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            exitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exitButton.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 45),
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            exitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    private func exitButtonDidTapped(){
        dismiss(animated: true)
    }
    
    @objc 
    private func tileTapped(_ sender: UIButton) {
        let position = sender.tag
        
        if gameState[position] == 0 {
            gameState[position] = currentPlayer
            
            if currentPlayer == 1 {
                sender.setTitle("X", for: .normal)
                currentPlayer = 2
                statusLabel.text = "Ходит игрок: O"
            } else {
                sender.setTitle("O", for: .normal)
                currentPlayer = 1
                statusLabel.text = "Ходит игрок: X"
            }
            
            if let winner = checkForWinner() {
                if winner == 1 {
                    statusLabel.text = "Игрок X победил!"
                    scoreX += 1
                } else {
                    statusLabel.text = "Игрок O победил!"
                    scoreO += 1
                }
                updateScore()
                disableButtons()
                resetButton.isHidden = false
            } else if !gameState.contains(0) {
                statusLabel.text = "Ничья!"
                resetButton.isHidden = false
            }
        }
    }
    
    private func checkForWinner() -> Int? {
        let winningCombinations = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]
        ]
        
        for combination in winningCombinations {
            if gameState[combination[0]] != 0 &&
                gameState[combination[0]] == gameState[combination[1]] &&
                gameState[combination[1]] == gameState[combination[2]] {
                return gameState[combination[0]]
            }
        }
        return nil
    }
    
    private func disableButtons() {
        for button in buttons {
            button.isEnabled = false
        }
    }
    
    @objc
    private func resetGame() {
        gameState = [Int](repeating: 0, count: 9)
        currentPlayer = 1
        statusLabel.text = "Ходит игрок: X"
        resetButton.isHidden = true
        
        for button in buttons {
            button.setTitle("", for: .normal)
            button.isEnabled = true
        }
    }
    
    private func updateScore() {
        scoreLabel.text = "Счет: X - \(scoreX) | O - \(scoreO)"
    }
}
