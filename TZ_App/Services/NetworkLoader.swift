import Foundation
import Alamofire
import RxCocoa
import RxSwift

class NetworkLoader {
    
    static let shared = NetworkLoader()
    
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    private var baseURL = "https://api.openweathermap.org/data/2.5/onecall?"
    private var requestParams: Parameters = [
        "lat": "55.751244",
        "lon": "37.618423",
        "exclude": "minutely,hourly",
        "appid": "5c6d5fcb81a6947c1287c884184862e0",
        "lang": "ru",
        "units": "metric"
    ]
    
    
    func fetchForecastData(complition: @escaping () -> Void) -> Observable<[ForecastPlainModel]> {

        return Observable.create { [unowned self] observer in

            let request = AF.request(self.baseURL, parameters: self.requestParams).response { response in
                guard let data = response.data else { return }
                do {
                    let forecast = try JSONDecoder().decode(WeeklyForecastData.self, from: data)
                    let plainForecast = forecast.toPlainModel()
                    observer.onNext(plainForecast)
                    CacheManager.shared.save(plainForecasts: plainForecast)
                } catch {
                    observer.onNext([])
                }
                complition()
            }
            return Disposables.create {
                request.cancel()
            }
        }
        
    }
}
