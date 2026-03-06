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
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.white.opacity(0.72))

            TextField(LocalizedStringKey("Berlin"), text: $viewModel.cityName, onCommit: viewModel.fetchCoordinates)
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
                .textInputAutocapitalization(.words)
                .disableAutocorrection(true)
                .submitLabel(.search)
        }
        .padding(.horizontal, 18)
        .frame(height: 58)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
        )
    }
}
