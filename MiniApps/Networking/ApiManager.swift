import Foundation

final class ApiManager{
    private static let apiKey = "400b8e9fd4ef1f6ed9c2918f547c3f72"
    private static let baseUrl = "https://api.openweathermap.org"
    private static let path = "/data/2.5/forecast"
    
    // Create url and make request
    static func getWeather(forLatitude latitude: Double, longitude: Double, completion: @escaping (Result<WeatherResponceObject, Error>) -> ()){
        let stringUrl =  baseUrl + path + "?lat=\(latitude)" + "&lon=\(longitude)" + "&appid=\(apiKey)" + "&lang=en&units=metric"
        
        guard let url = URL(string: stringUrl) else { return }
        
        let session = URLSession.shared.dataTask(with: url) { data, responce, error in
            handleResponce(data: data,
                           error: error,
                           completion: completion)
        }
        
        session.resume()
    }
    
    // Handle responce
    private static func handleResponce(data: Data?,
                                       error: Error?,
                                       completion: @escaping (Result<WeatherResponceObject, Error>) -> ()){
        
        if let error = error{
            completion(.failure(error))
        } else if let data = data{
            do {
                let model = try JSONDecoder().decode(WeatherResponceObject.self, from: data)
                completion(.success(model))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
}
