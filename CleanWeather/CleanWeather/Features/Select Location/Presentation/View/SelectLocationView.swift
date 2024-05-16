//
//  SelectLocationView.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 14. 5. 2024..
//

import Foundation
import SwiftUI
import MapKit

struct SelectLocationView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WeatherViewModel
    
    var backButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            ZStack {
                Color(.white)
                Image(systemName: "chevron.left")
                    .foregroundColor(Constants.defaultBackground)
                    .padding(10)
            }
            .clipShape(Circle())
        }
    }
    
    var body: some View {
        VStack {
            TextField("Enter city name", text: $viewModel.cityName, onCommit: viewModel.fetchCoordinates)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            if let coordinates = viewModel.coordinates {
                Text("Location: \(viewModel.locationName), coordinates: \(coordinates.latitude) - \(coordinates.longitude)")
                    .font(.custom("Avenir-Medium", size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .lineLimit(4)
                    .padding()
            }
            Spacer()
        }
        .background(Constants.defaultBackground)
        .navigationTitle("Select Location")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
}
