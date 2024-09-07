import UIKit
import CoreLocation

final class CityApp: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    private lazy var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.text = "Текущий город"
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        titleLabel.textColor = .blackCl
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var cityLabel: UILabel = {
        var cityLabel = UILabel()
        cityLabel.textAlignment = .center
        cityLabel.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        cityLabel.textColor = .blackCl
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.numberOfLines = 2
        cityLabel.lineBreakMode = .byWordWrapping
        return cityLabel
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteCl
        setupUI()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(cityLabel)
        view.addSubview(exitButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            exitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            exitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            fetchCity(for: location)
            locationManager.stopUpdatingLocation()
        }
    }

    func fetchCity(for location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first, let city = placemark.locality {
                self.cityLabel.text = "Вы находитесь в \(city)"
            } else {
                self.cityLabel.text = "Не удалось определить город"
            }
        }
    }
    
    @objc
    private func exitButtonDidTapped(){
        dismiss(animated: true)
    }
}
