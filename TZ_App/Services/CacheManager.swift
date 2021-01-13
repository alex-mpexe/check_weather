import Foundation
import RealmSwift


class CacheManager {
    
    static let shared = CacheManager()
    
    private let realm = try! Realm()
    
    func save(plainForecasts: [ForecastPlainModel]) {
        try! realm.write {
            for forecast in plainForecasts {
                let managedForecast = forecast.toManagedModel()
                if realm.object(ofType: ForecastManagedModel.self, forPrimaryKey: managedForecast.date) == nil {
                    realm.add(managedForecast)
                }
                else {
                    realm.add(managedForecast, update: .modified)
                }
            }
        }
    }
    
    func load() -> [ForecastPlainModel] {
        let cachedForecast: [ForecastPlainModel] = realm.objects(ForecastManagedModel.self).map {$0.toPlainModel()}
        return cachedForecast
    }
    
}
