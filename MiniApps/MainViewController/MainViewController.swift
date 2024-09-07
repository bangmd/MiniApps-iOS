import UIKit

final class MainViewController: UIViewController {
    private var isInteractiveMode = false{
        didSet {
            updateTitle()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MainViewControllerCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .whiteCl
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private let miniApps = ["Прогноз погоды", "Таймер", "Крестики-Нолики", "Текущий город"]
    private let miniAppsIcons = ["weather", "timer", "tictac", "city"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .whiteCl
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        navigationController?.navigationBar.backgroundColor = .whiteCl
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "См. режим", style: .plain, target: self, action: #selector(toggleMode))
        updateTitle()
    }
    
    private func updateTitle() {
        navigationItem.title = isInteractiveMode ? "Активный режим" : "Неактивный режим"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
    }
    
    @objc 
    private func toggleMode() {
        isInteractiveMode.toggle()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(10, miniApps.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MainViewControllerCell 
        else {
            return MainViewControllerCell()
        }
        let appIndex = indexPath.row % miniApps.count // Позволяет циклически использовать приложения
        cell.configure(with: miniApps[appIndex], image: UIImage(named: miniAppsIcons[appIndex]))
        
        if !isInteractiveMode {
            cell.isUserInteractionEnabled = false
            cell.contentView.alpha = 0.7
        } else {
            cell.isUserInteractionEnabled = true
            cell.contentView.alpha = 1.0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isInteractiveMode {
            return view.frame.height / 2
        } else {
            return view.frame.height / 8
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard isInteractiveMode else { return }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? MainViewControllerCell else { return }
        cell.backgroundColor = .lightGray
        tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            cell.backgroundColor = .clear
        }
        
        let selectedApp = miniApps[indexPath.row % miniApps.count]
        var viewController: UIViewController?

        switch selectedApp {
        case "Прогноз погоды":
            viewController = WeatherApp()
        case "Таймер":
            viewController = TimerViewController()
        case "Крестики-Нолики":
            viewController = TicTacToeViewController()
        case "Текущий город":
            viewController = CityApp()
        default:
            break
        }

        if let vc = viewController {
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard isInteractiveMode else { return }
        guard let cell = tableView.cellForRow(at: indexPath) as? MainViewControllerCell else { return }
        cell.backgroundColor = .clear
    }
}


