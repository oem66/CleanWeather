//
//  WeatherLocalRepository.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 14. 6. 2024..
//

import Foundation
import CoreData

final class WeatherLocalRepository {
    let coreDataManager = CoreDataManager.shared
    
    func saveWeather(data: WeatherData) {
        let writeMOC = self.coreDataManager.writeMOC
        writeMOC.perform { [weak self] in
            guard let self = self else { return }
            let lastWeather = self.fetchWeather(context: writeMOC)
            if let lastWeather {
                writeMOC.delete(lastWeather)
            }
            
            WeatherDB.insert(into: writeMOC, data: data)
            
            let status = writeMOC.saveOrRollback()
            status ? debugPrint("Successfull Core Data Operation!") : debugPrint(CleanWeatherError.failedDatabaseUpdate)
        }
    }
    
    func getOfflineWeather(completion: @escaping (WeatherData) -> Void) {
        let writeMOC = coreDataManager.writeMOC
        writeMOC.perform { [weak self] in
            guard let self = self else { return }
            let weather = self.fetchWeather(context: writeMOC)
            let weatherData = WeatherData(currentWeather: CurrentWeather(asOf: weather?.asOf ?? Date(),
                                                                         cloudCover: weather?.cloudCover ?? 0.0,
                                                                         conditionCode: weather?.conditionCode ?? "",
                                                                         daylight: weather?.daylight ?? false,
                                                                         humidity: weather?.humidity ?? 0.0,
                                                                         precipitationIntensity: weather?.precipitationIntensity ?? 0.0,
                                                                         pressure: weather?.pressure ?? 0.0,
                                                                         temperature: weather?.temperature ?? 0.0,
                                                                         temperatureApparent: weather?.temperatureApparent ?? 0.0,
                                                                         uvIndex: weather?.uvIndex ?? 0,
                                                                         visibility: weather?.visibility ?? 0.0,
                                                                         windDirection: weather?.windDirection ?? 0,
                                                                         windGust: weather?.windGust ?? 0.0,
                                                                         windSpeed: weather?.windSpeed ?? 0.0))
            completion(weatherData)
        }
    }
}

// MARK: - Private methods
private extension WeatherLocalRepository {
    func fetchWeather(context: NSManagedObjectContext) -> WeatherDB? {
        let request: NSFetchRequest<WeatherDB> = WeatherDB.fetchRequest() as! NSFetchRequest<WeatherDB>
        do {
            let results = try context.fetch(request)
            return results.first // Return the first WeatherDB object or nil if empty
        } catch {
            print("Failed to fetch weather data: \(error)")
            return nil
        }
    }
}
