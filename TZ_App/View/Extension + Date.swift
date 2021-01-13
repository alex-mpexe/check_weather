import Foundation

extension Date {
    func formateDate(with format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ru")
        let stringDate = formatter.string(from: self)
        return stringDate
    }
}
