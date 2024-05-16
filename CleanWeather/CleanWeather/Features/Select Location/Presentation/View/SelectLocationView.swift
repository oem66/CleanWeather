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
        VStack {
            VStack {
                HStack {
                    Spacer()
                    Text("Select city")
                        .font(.custom("Avenir-Medium", size: 25))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.top, 20)
                
                VStack(alignment: .center) {
                    CustomTextField(viewModel: viewModel)
                    
                    if let coordinates = viewModel.coordinates {
                        withAnimation {
                            HStack {
                                Spacer()
                                Text("Location: \(viewModel.locationName), coordinates: \(coordinates.latitude) - \(coordinates.longitude)")
                                    .font(.custom("Avenir-Medium", size: 16))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(4)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 20)
                                Spacer()
                            }
                            .background(.black)
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal, 10)
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
                        .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding(.bottom, 30)
            }
            .background(Constants.cardItemBackground)
            .cornerRadius(15)
            .padding(.horizontal, 15)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .presentationBackground(.clear.opacity(0.5))
        .edgesIgnoringSafeArea(.all)
    }
}
