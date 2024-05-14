//
//  SelectLocationView.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 14. 5. 2024..
//

import Foundation
import SwiftUI

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
            Spacer()
            HStack {
                Spacer()
                Text("Select Location")
                Spacer()
            }
            Spacer()
        }
        .background(Constants.defaultBackground)
        .navigationTitle("Select Location")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
}
