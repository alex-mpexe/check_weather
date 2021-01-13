import Foundation
import RealmSwift


class CacheManager {
    
    // MARK: - Singleton
    static let shared = CacheManager()
    
    private let realm = try! Realm()
    
    // MARK: - Save data to cache
    func save(plainForecasts: [ForecastPlainModel]) {
        try! realm.write {
            for forecast in plainForecasts {
                // Converting our plain model to managed model
                let managedForecast = forecast.toManagedModel()
                // Check if this item already in cache
                if realm.object(ofType: ForecastManagedModel.self, forPrimaryKey: managedForecast.date) == nil {
                    realm.add(managedForecast)
                }
                else {
                    realm.add(managedForecast, update: .modified)
                }
            }
        }
    }
    
    // MARK: - Load data from cache
    func load() -> [ForecastPlainModel] {
        let cachedForecast: [ForecastPlainModel] = realm.objects(ForecastManagedModel.self).map {$0.toPlainModel()}
        return cachedForecast
    }
    
}
