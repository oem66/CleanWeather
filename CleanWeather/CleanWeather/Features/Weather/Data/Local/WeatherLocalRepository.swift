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
            
            let newWeather = WeatherDB.insert(into: writeMOC, data: data)
            
            let status = writeMOC.saveOrRollback()
            status ? debugPrint("Successfull Core Data Operation!") : debugPrint(CleanWeatherError.failedDatabaseUpdate)
        }
    }
    
    func getOfflineWeather() -> WeatherData {
        return WeatherData()
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
