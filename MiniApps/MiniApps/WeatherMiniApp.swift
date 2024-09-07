import UIKit
import CoreLocation
import Kingfisher

final class WeatherApp: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    private lazy var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.text = "Прогноз погоды"
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        titleLabel.textColor = .whiteCl
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var temperatureLabel: UILabel = {
        var temperatureLabel = UILabel()
        temperatureLabel.text = "--"
        temperatureLabel.textAlignment = .center
        temperatureLabel.textColor = .white
        temperatureLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        return temperatureLabel
    }()
    
    private lazy var desc: UILabel = {
        var desc = UILabel()
        desc.textAlignment = .center
        desc.textColor = .white
        desc.font = UIFont.systemFont(ofSize: 20)
        desc.translatesAutoresizingMaskIntoConstraints = false
        return desc
    }()
    
    private lazy var weatherIconImageView: UIImageView = {
        var weatherIconImageView = UIImageView()
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        return weatherIconImageView
    }()
    
    private lazy var city: UILabel = {
        var city = UILabel()
        city.textAlignment = .center
        city.textColor = .white
        city.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        city.translatesAutoresizingMaskIntoConstraints = false
        return city
    }()
    
    private lazy var exitButton: UIButton = {
        var exitButton = UIButton(type: .system)
        exitButton.setTitle("Вернуться назад", for: .normal)
        exitButton.setTitleColor(.black, for: .normal)
        exitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        exitButton.backgroundColor = .white
        exitButton.layer.cornerRadius = 16
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: #selector(exitButtonDidTapped), for: .touchUpInside)
        return exitButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray.withAlphaComponent(0.1)
        configure()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func configure() {
        view.addSubview(titleLabel)
        view.addSubview(city)
        view.addSubview(temperatureLabel)
        view.addSubview(desc)
        view.addSubview(weatherIconImageView)
        view.addSubview(exitButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            weatherIconImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 270),
            weatherIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 100),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 100),
            
            temperatureLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 350),
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            city.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            city.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            desc.topAnchor.constraint(equalTo: city.bottomAnchor, constant: 12),
            desc.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            exitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            exitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc
    private func exitButtonDidTapped(){
        dismiss(animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            fetchWeather(for: location.coordinate)
            fetchCity(for: location)
            locationManager.stopUpdatingLocation()
        }
    }

    func fetchWeather(for coordinate: CLLocationCoordinate2D) {
        ApiManager.getWeather(forLatitude: coordinate.latitude, longitude: coordinate.longitude) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    if let lastWeatherData = weather.list.first, let descriptionWeather = lastWeatherData.weather.first {
                        let temperature = Int(lastWeatherData.main.temp)
                        self.temperatureLabel.text = "\(temperature)°C"
                        self.desc.text = "\(descriptionWeather.main)"
                        
                        let iconCode = descriptionWeather.icon
                        let iconUrlString = "https://openweathermap.org/img/wn/\(iconCode)@2x.png"
                        self.weatherIconImageView.kf.setImage(with: URL(string: iconUrlString))
                    } else {
                        self.temperatureLabel.text = "Нет данных о погоде"
                    }
                case.failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func fetchCity(for location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first, let city = placemark.locality {
                self.city.text = city
            } else {
                self.city.text = "Не удалось определить город"
            }
        }
    }
}
