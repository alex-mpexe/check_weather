import Foundation
import RealmSwift

// Realm forecast model
class ForecastManagedModel: Object {
    @objc dynamic var city: String? = nil
    @objc dynamic var date = String()
    @objc dynamic var temperature = String()
    @objc dynamic var pressure = String()
    @objc dynamic var humidity = String()
    @objc dynamic var weatherDescription = String()
    @objc dynamic var weatherIconData = Data()
    
    override static func primaryKey() -> String? {
        return "date"
    }
    
    func toPlainModel() -> ForecastPlainModel {
        let plainModel = ForecastPlainModel()
        plainModel.date = self.date
        plainModel.humidity = self.humidity
        plainModel.pressure = self.pressure
        plainModel.temperature = self.temperature
        plainModel.weatherDescription = self.weatherDescription
        plainModel.weatherIconData = self.weatherIconData
        
        return plainModel
    }
}

class ForecastPlainModel {
    var city: String?
    var date = String()
    var temperature = String()
    var pressure = String()
    var humidity = String()
    var weatherDescription = String()
    var weatherIconData = Data()
    
    func toManagedModel() -> ForecastManagedModel {
        let managedModel = ForecastManagedModel()
        managedModel.date = self.date
        managedModel.humidity = self.humidity
        managedModel.pressure = self.pressure
        managedModel.temperature = self.temperature
        managedModel.weatherDescription = self.weatherDescription
        managedModel.weatherIconData = self.weatherIconData
        
        return managedModel
    }
}

// Model for "weather" key in openweathermap API
class Weather: Decodable {
    var description: String?
    var icon: String?
    enum CodingKeys: String, CodingKey {
        case description
        case icon
    }
}

// Model for temp data
class Temperature: Decodable {
    var day: Double?
    enum CodingKeys: String, CodingKey {
        case day
    }
}

// Model for daily data
class Daily: Decodable {
    var date: Double?
    var pressure: Double?
    var humidity: Double?
    var temp: Temperature
    var weather: [Weather]?
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case temp
        case weather
        case pressure
        case humidity
    }
    
}

// Model for weekly forecast
class WeeklyForecastData: Decodable {
    var daily: [Daily]?
    enum CodingKeys: String, CodingKey {
        case daily
    }
    
    func toPlainModel() -> [ForecastPlainModel] {
        var forecastPlainData: [ForecastPlainModel] = []
        guard let daily = self.daily else { return [] }
        for day in daily {
            let plainModel = ForecastPlainModel()
            plainModel.date = Date(timeIntervalSince1970: day.date ?? 0).formateDate(with: "dd MMMM yyyy г.")
            plainModel.humidity = "\(day.humidity ?? 0) %"
            plainModel.pressure =  "\((day.pressure ?? 0) / 133) мм. рт. ст."
            plainModel.temperature = "\(Int((day.temp.day ?? 0).rounded())) \u{2103}"
            plainModel.weatherDescription = day.weather?.first?.description ?? ""
            if let url = URL(string: "http://openweathermap.org/img/wn/\(day.weather?.first?.icon ?? "")@4x.png") {
                if let data = try? Data(contentsOf: url) {
                    plainModel.weatherIconData = data
                }
            }
            forecastPlainData.append(plainModel)
        }
        return forecastPlainData
    }
}
