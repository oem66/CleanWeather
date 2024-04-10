//
//  TemperatureChartView.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 8. 4. 2024..
//

import Foundation
import SwiftUI
import Charts

struct ChartData: Identifiable {
    let id = UUID()
    var time: String
    var valueMax: Double
    var valueMin: Double
}

struct TemperatureChartView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    @State private var chartData = [
        ChartData(time: "09.04", valueMax: 21.5, valueMin: 8.2),
        ChartData(time: "10.04", valueMax: 18.3, valueMin: 2.2),
        ChartData(time: "11.04", valueMax: 24.6, valueMin: 6.2),
        ChartData(time: "12.04", valueMax: 23.2, valueMin: 3.2),
        ChartData(time: "13.04", valueMax: 16.3, valueMin: 9.2),
        ChartData(time: "14.04", valueMax: 12.8, valueMin: 10.2),
        ChartData(time: "15.04", valueMax: 22.4, valueMin: 14.2)
    ]
    
    var body: some View {
        VStack(alignment: .center) {
            Chart(chartData) { item in
                LineMark(x: .value("Date", item.time),
                         y: .value("Temperature", item.valueMax),
                         series: .value("Max temperature", "Max")
                )
                .foregroundStyle(Color.red.gradient)
                .interpolationMethod(.catmullRom)
                .lineStyle(.init(lineWidth: 2))
                .symbol {
                    Circle()
                        .fill(.red)
                        .frame(width: 12, height: 12)
                }
                
                LineMark(x: .value("Date", item.time),
                         y: .value("Temperature", item.valueMin),
                         series: .value("Min temperature", "Min")
                )
                .foregroundStyle(Color.blue.gradient)
                .interpolationMethod(.catmullRom)
                .lineStyle(.init(lineWidth: 2))
                .symbol {
                    Circle()
                        .fill(.blue)
                        .frame(width: 12, height: 12)
                }
            }
            .frame(height: 180)
            .padding()
        }
    }
}
