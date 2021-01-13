import Foundation
import Alamofire
import RxCocoa
import RxSwift

class NetworkLoader {
    
    // MARK: - Singleton
    static let shared = NetworkLoader()
    
    // MARK: - Variable that store Internet accessablity state
    static var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    // MARK: - Request URL data
    private let baseURL = "https://api.openweathermap.org/data/2.5/onecall?"
    private let requestParams: Parameters = [
        "lat": "55.751244",
        "lon": "37.618423",
        "exclude": "minutely,hourly",
        "appid": "5c6d5fcb81a6947c1287c884184862e0",
        "lang": "ru",
        "units": "metric"
    ]
    
    // MARK: - API request
    func fetchForecastData(completion: @escaping () -> Void) -> Observable<[ForecastPlainModel]> {
        // Create an Observable
        return Observable.create { [unowned self] observer in
            // API request
            let request = AF.request(self.baseURL, parameters: self.requestParams).response { response in
                guard let data = response.data else { return }
                do {
                    // Parse data to our model
                    let forecast = try JSONDecoder().decode(WeeklyForecastData.self, from: data)
                    // Convert data for plain model and set next value for observable
                    let plainForecast = forecast.toPlainModel()
                    observer.onNext(plainForecast)
                    // Save data to cache
                    CacheManager.shared.save(plainForecasts: plainForecast)
                } catch {
                    // Handle wrong behavior
                    observer.onNext([])
                }
                // Callback for controll activity loader
                completion()
            }
            return Disposables.create {
                request.cancel()
            }
        }
        
    }
}
