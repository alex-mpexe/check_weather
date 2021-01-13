import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    
    let loadingStatus = BehaviorSubject<Bool>(value: true)
    
    func getForecastData() -> Observable<[ForecastPlainModel]> {
        
        if NetworkLoader.isConnectedToInternet {
            loadingStatus.onNext(false)
            let loadedData = NetworkLoader.shared.fetchForecastData(complition: { [unowned self] in
                self.loadingStatus.onNext(true)
            })
            return loadedData
        } else {
            loadingStatus.onNext(false)
            let cachedForecast = CacheManager.shared.load().sorted(by: { $0.date < $1.date })
            loadingStatus.onNext(true)
            return Observable.of(cachedForecast)
        }
    }
    
    
}
