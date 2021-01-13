import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    
    // MARK: - Data Subjects
    let loadingStatus = BehaviorSubject<Bool>(value: true)
    
    func getForecastData() -> Observable<[ForecastPlainModel]> {
        // Check if internet is available
        if NetworkLoader.isConnectedToInternet {
            // Set activity indicator visible
            loadingStatus.onNext(false)
            let loadedData = NetworkLoader.shared.fetchForecastData(completion: { [unowned self] in
                // After the loading is complete, sets activity indicator hiden
                self.loadingStatus.onNext(true)
            })
            return loadedData
        } else {
            // Load data from cache, sorted by date
            let cachedForecast = CacheManager.shared.load().sorted(by: { $0.date < $1.date })
            return Observable.of(cachedForecast)
        }
    }
    
    
}
