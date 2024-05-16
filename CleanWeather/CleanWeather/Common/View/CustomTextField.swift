//
//  CustomTextField.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 16. 5. 2024..
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(LocalizedStringKey("Berlin"), text: $viewModel.cityName, onCommit: viewModel.fetchCoordinates)
                .frame(height: 55)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                .background(.white)
                .cornerRadius(10)
        }
    }
}
