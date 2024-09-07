import UIKit

final class TimerViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.text = "Таймер"
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        titleLabel.textColor = .blackCl
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var timerLabel: UILabel = {
        var timerLabel = UILabel()
        timerLabel.text = "00:00:00"
        timerLabel.font = UIFont.systemFont(ofSize: 50)
        timerLabel.textColor = .blackCl
        timerLabel.textAlignment = .center
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        return timerLabel
    }()
    
    private lazy var startButton: UIButton = {
        startButton = UIButton(type: .system)
        startButton.setTitle("Старт", for: .normal)
        startButton.setTitleColor(.whiteCl, for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        startButton.backgroundColor = .blackCl
        startButton.layer.cornerRadius = 16
        startButton.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        return startButton
    }()
    
    private lazy var resetButton: UIButton = {
        resetButton = UIButton(type: .system)
        resetButton.setTitle("Сброс", for: .normal)
        resetButton.setTitleColor(.blackCl, for: .normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        resetButton.backgroundColor = .clear
        resetButton.layer.borderWidth = 2
        resetButton.layer.borderColor = UIColor.lightGray.cgColor
        resetButton.layer.cornerRadius = 16
        resetButton.addTarget(self, action: #selector(resetTimer), for: .touchUpInside)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        return resetButton
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
    
    var timer: Timer?
    var seconds: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteCl
        configure()
    }

    func configure() {
        view.addSubview(titleLabel)
        view.addSubview(timerLabel)
        view.addSubview(startButton)
        view.addSubview(resetButton)
        view.addSubview(exitButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 20),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 60),
            
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20),
            resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resetButton.heightAnchor.constraint(equalToConstant: 60),
            
            exitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exitButton.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 150),
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
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.seconds += 1
            self?.updateTimerLabel()
        }
    }

    @objc 
    func resetTimer() {
        timer?.invalidate()
        seconds = 0
        updateTimerLabel()
    }

    func updateTimerLabel() {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secondsRemaining = seconds % 60
        timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, secondsRemaining)
    }
}
