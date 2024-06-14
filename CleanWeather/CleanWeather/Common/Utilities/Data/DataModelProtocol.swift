//
//  DataModelProtocol.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 24. 2. 2024..
//

import Foundation

public protocol DataModel {

    associatedtype DataModelType

    func toData() -> DataModelType
}
