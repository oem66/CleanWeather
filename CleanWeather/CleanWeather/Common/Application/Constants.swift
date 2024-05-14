//
//  Constants.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 6. 4. 2024..
//

import Foundation
import SwiftUI

final class Constants {
    // MARK: - Application colors
    static let defaultBackground = Color(red: 26/255, green: 28/255, blue: 30/255)
    static let cardItemBackground = Color(red: 32/255, green: 35/255, blue: 40/255)
    static let customGrayColor = Color(red: 122/255, green: 122/255, blue: 122/255)
    
    // MARK: - Air Quality colors
    static let aqiGood: Color = .green
    static let aqiModerate: Color = .yellow
    static let aqiUnhealthySensitiveGroups: Color = .orange
    static let aqiUnhealthy: Color = .red
    static let aqiVeryUnhealthy: Color = .purple
    static let aqiHazardous: Color = .black
    
}
