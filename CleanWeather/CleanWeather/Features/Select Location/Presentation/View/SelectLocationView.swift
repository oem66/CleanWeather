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
    @ObservedObject var viewModel: WeatherViewModel
    @Binding var showSheetView: Bool
    
    var body: some View {
        if #available(iOS 16.4, *) {
            VStack {
                VStack {
                    HStack {
                        Spacer()
                        Text("Select city")
                            .font(.custom("Avenir-Medium", size: 25))
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    VStack(alignment: .center) {
                        TextField("Enter city name",
                                  text: $viewModel.cityName,
                                  onCommit: viewModel.fetchCoordinates)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        if let coordinates = viewModel.coordinates {
                            Text("Location: \(viewModel.locationName), coordinates: \(coordinates.latitude) - \(coordinates.longitude)")
                                .font(.custom("Avenir-Medium", size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                                .lineLimit(4)
                                .padding()
                        }
                    }
                    .padding(.vertical, 20)
                    
                    HStack {
                        Spacer()
                        Button {
                            showSheetView.toggle()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Select")
                                    .font(.custom("Avenir-Medium", size: 20))
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                Spacer()
                            }
                            .background(.green)
                            .cornerRadius(15)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 30)
                }
                .background(.white)
                .cornerRadius(15)
                .padding(.horizontal, 15)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .presentationBackground(.clear.opacity(0.5))
            .edgesIgnoringSafeArea(.all)
        } else {
            // Fallback on earlier versions
        }
    }
}
