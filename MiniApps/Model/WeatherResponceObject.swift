import Foundation

struct WeatherResponceObject: Codable{
    let list: [WeatherData]
    
    enum CodingKeys: CodingKey{
        case list
    }
}

struct WeatherData: Codable{
    let main: MainWeather
    let weather: [WeatherDescription]
}

struct MainWeather: Codable {
    let temp: Double
    let feels_like: Double
}

struct WeatherDescription: Codable {
    let main: String
    let description: String
    let icon: String
}
