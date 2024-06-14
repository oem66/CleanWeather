//
//  WeatherDB.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 14. 6. 2024..
//

import Foundation
import CoreData

final class WeatherDB: NSManagedObject {
    @NSManaged var asOf: Date
    @NSManaged var cloudCover: Double
    @NSManaged var conditionCode: String
    @NSManaged var daylight: Bool
    @NSManaged var humidity: Double
    @NSManaged var precipitationIntensity: Double
    @NSManaged var pressure: Double
    @NSManaged var temperature: Double
    @NSManaged var temperatureApparent: Double
    @NSManaged var uvIndex: Int
    @NSManaged var visibility: Double
    @NSManaged var windDirection: Int
    @NSManaged var windGust: Double
    @NSManaged var windSpeed: Double
    
    @discardableResult
    static func insert(into context: NSManagedObjectContext, data: WeatherData) -> WeatherDB {
        let weather = findOrCreate(for: data.currentWeather?.conditionCode ?? "", in: context)
        
        weather.asOf = data.currentWeather?.asOf ?? Date()
        weather.cloudCover = data.currentWeather?.cloudCover ?? 0.0
        weather.conditionCode = data.currentWeather?.conditionCode ?? ""
        weather.daylight = data.currentWeather?.daylight ?? false
        weather.humidity = data.currentWeather?.humidity ?? 0.0
        weather.precipitationIntensity = data.currentWeather?.precipitationIntensity ?? 0.0
        weather.pressure = data.currentWeather?.pressure ?? 0.0
        weather.temperature = data.currentWeather?.temperature ?? 0.0
        weather.temperatureApparent = data.currentWeather?.temperatureApparent ?? 0.0
        weather.uvIndex = data.currentWeather?.uvIndex ?? 0
        weather.visibility = data.currentWeather?.visibility ?? 0.0
        weather.windDirection = data.currentWeather?.windDirection ?? 0
        weather.windGust = data.currentWeather?.windGust ?? 0.0
        weather.windSpeed = data.currentWeather?.windSpeed ?? 0.0
        
        return weather
    }
    
    static func findOrCreate(for conditionCode: String, in context: NSManagedObjectContext) -> WeatherDB {
        let preference = findOrCreateObject(in: context, matching: predicate(for: conditionCode)) {
            $0.conditionCode = conditionCode
        }
        return preference
    }

    static func predicate(for conditionCode: String) -> NSPredicate {
        NSPredicate(format: "%K == %@", #keyPath(WeatherDB.conditionCode), conditionCode)
    }
}

extension WeatherDB: Managed {
    static var entityName: String {
        return String(describing: WeatherDB.self)
    }
}

extension WeatherDB: DataModel {
    typealias DomainModelType = WeatherData

    func toData() -> WeatherData {
        let currentWeather = CurrentWeather(asOf: asOf,
                                            cloudCover: cloudCover,
                                            conditionCode: conditionCode,
                                            daylight: daylight,
                                            humidity: humidity,
                                            precipitationIntensity: precipitationIntensity,
                                            pressure: pressure,
                                            temperature: temperature,
                                            temperatureApparent: temperatureApparent,
                                            uvIndex: uvIndex,
                                            visibility: visibility,
                                            windDirection: windDirection,
                                            windGust: windGust,
                                            windSpeed: windSpeed)
        return WeatherData(currentWeather: currentWeather)
    }
}
