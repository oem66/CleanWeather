//
//  LocationDB.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 16. 6. 2024..
//

import Foundation
import CoreData

final class LocationDB: NSManagedObject {
    @NSManaged var city: String
    @NSManaged var country: String
    
    @discardableResult
    static func insert(into context: NSManagedObjectContext, data: LocationData) -> LocationDB {
        let location = findOrCreate(for: data.city, in: context)
        
        location.city = data.city
        location.country = data.country
        
        return location
    }
    
    static func findOrCreate(for conditionCode: String, in context: NSManagedObjectContext) -> LocationDB {
        let preference = findOrCreateObject(in: context, matching: predicate(for: conditionCode)) {
            $0.city = conditionCode
        }
        return preference
    }

    static func predicate(for conditionCode: String) -> NSPredicate {
        NSPredicate(format: "%K == %@", #keyPath(LocationDB.city), conditionCode)
    }
}

extension LocationDB: Managed {
    static var entityName: String {
        return String(describing: LocationDB.self)
    }
}

extension LocationDB: DataModel {
    typealias DomainModelType = WeatherData

    func toData() -> LocationData {
        return LocationData(city: city, 
                            country: country)
    }
}
