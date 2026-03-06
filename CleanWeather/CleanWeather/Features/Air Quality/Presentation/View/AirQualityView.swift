//
//  AirQualityView.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 7. 3. 2024..
//

import Foundation
import SwiftUI
import MapKit

struct ClimateMapView: View {
    @ObservedObject var viewModel: CityExplorerViewModel

    private var theme: WeatherSceneTheme {
        viewModel.selectedCity?.theme ?? WeatherSceneTheme(condition: "Clear", daylight: true)
    }

    private var regionBinding: Binding<MKCoordinateRegion> {
        Binding(
            get: { viewModel.mapRegion },
            set: { viewModel.mapRegion = $0 }
        )
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [theme.skyTop, theme.skyBottom, theme.horizon],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    header
                    mapCard
                    if let selectedCity = viewModel.selectedCity {
                        selectedCityDetails(for: selectedCity)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .padding(.bottom, 28)
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
        .task {
            await viewModel.loadIfNeeded()
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Climate Map")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                Text("Tap city markers to compare weather, wind, pressure, and live air quality.")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.72))
            }

            Spacer()

            Image(systemName: "globe.europe.africa.fill")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(theme.glow)
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.black.opacity(0.14))
                )
        }
    }

    private var mapCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color.white.opacity(0.10))
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(Color.white.opacity(0.10), lineWidth: 1)
                )

            if viewModel.isLoading && viewModel.citySnapshots.isEmpty {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
            } else {
                Map(coordinateRegion: regionBinding, annotationItems: viewModel.citySnapshots) { snapshot in
                    MapAnnotation(coordinate: snapshot.coordinate) {
                        Button {
                            viewModel.select(snapshot)
                        } label: {
                            MapCityBadge(
                                snapshot: snapshot,
                                isSelected: snapshot.id == viewModel.selectedCity?.id
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .padding(10)
            }
        }
        .frame(height: 360)
        .shadow(color: Color.black.opacity(0.18), radius: 20, x: 0, y: 16)
    }

    @ViewBuilder
    private func selectedCityDetails(for snapshot: CitySnapshot) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(snapshot.preset.name)
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundStyle(.white)

                    Text(snapshot.preset.country)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.64))

                    Text(snapshot.conditionCode)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.78))
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 8) {
                    Text(snapshot.formattedTemperature)
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .foregroundStyle(.white)

                    HStack(spacing: 8) {
                        Circle()
                            .fill(snapshot.aqiBand.color)
                            .frame(width: 10, height: 10)

                        Text("\(max(snapshot.aqiValue, 1)) AQI • \(snapshot.aqiBand.title)")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.8))
                    }
                }
            }

            AQISpectrumBar(currentBand: max(snapshot.aqiValue, 1))

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ClimateMetricTile(title: "Pressure", value: snapshot.formattedPressure, icon: "gauge.with.dots.needle.33percent", tint: snapshot.theme.secondaryAccent)
                ClimateMetricTile(title: "Wind", value: snapshot.formattedWind, icon: "wind", tint: snapshot.theme.accent)
                ClimateMetricTile(title: "Humidity", value: snapshot.formattedHumidity, icon: "humidity.fill", tint: snapshot.theme.glow)
                ClimateMetricTile(title: "Scale", value: snapshot.preset.scale.title, icon: "building.2.fill", tint: snapshot.theme.windowGlow)
            }

            if let components = snapshot.airComponents {
                HStack(spacing: 12) {
                    AirComponentPill(title: "PM2.5", value: String(format: "%.0f", components.pm2_5), tint: snapshot.theme.accent)
                    AirComponentPill(title: "PM10", value: String(format: "%.0f", components.pm10), tint: snapshot.theme.secondaryAccent)
                    AirComponentPill(title: "O3", value: String(format: "%.0f", components.o3), tint: snapshot.theme.windowGlow)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.12),
                            Color.white.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(Color.white.opacity(0.10), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.18), radius: 20, x: 0, y: 16)
    }
}

struct AirQualityView: View {
    @StateObject private var viewModel = CityExplorerViewModel()

    var body: some View {
        ClimateMapView(viewModel: viewModel)
    }
}

private struct MapCityBadge: View {
    let snapshot: CitySnapshot
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 6) {
            Text(snapshot.formattedTemperature)
                .font(.system(size: 15, weight: .black, design: .rounded))
                .foregroundStyle(.white)

            Text(snapshot.preset.name)
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.72))
                .lineLimit(1)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            snapshot.theme.buildingFront.opacity(isSelected ? 0.98 : 0.88),
                            snapshot.theme.buildingSide.opacity(isSelected ? 0.98 : 0.90)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(isSelected ? Color.white.opacity(0.26) : Color.white.opacity(0.10), lineWidth: 1)
                )
        )
        .scaleEffect(isSelected ? 1.06 : 1)
        .shadow(color: Color.black.opacity(0.18), radius: 14, x: 0, y: 10)
    }
}

private struct ClimateMetricTile: View {
    let title: String
    let value: String
    let icon: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(tint)

            Text(title)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.62))

            Text(value)
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.black.opacity(0.12))
        )
    }
}

private struct AQISpectrumBar: View {
    let currentBand: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(1...5, id: \.self) { band in
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(AQIBand(value: band).color.opacity(currentBand == band ? 1 : 0.42))
                    .frame(height: currentBand == band ? 18 : 12)
            }
        }
        .animation(.easeOut(duration: 0.25), value: currentBand)
    }
}

private struct AirComponentPill: View {
    let title: String
    let value: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.58))

            Text(value)
                .font(.system(size: 15, weight: .black, design: .rounded))
                .foregroundStyle(tint)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.black.opacity(0.12))
        )
    }
}

struct MultipleCitiesView: View {
    @ObservedObject var viewModel: CityExplorerViewModel

    private var theme: WeatherSceneTheme {
        viewModel.selectedCity?.theme ?? WeatherSceneTheme(condition: "Clear", daylight: true)
    }

    private let smallerColumns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [theme.skyTop, theme.skyBottom, theme.horizon],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    citiesHeader
                    majorCitiesSection
                    smallerCitiesSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .padding(.bottom, 28)
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
        .task {
            await viewModel.loadIfNeeded()
        }
    }

    private var citiesHeader: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text("City Atlas")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                Text("Large city cards and smaller-city snapshots, all refreshed from the same live weather feed.")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.72))
            }

            Spacer()

            Image(systemName: "building.2.crop.circle.fill")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(theme.windowGlow)
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.black.opacity(0.14))
                )
        }
    }

    private var majorCitiesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            citiesSectionTitle("Large Cities", subtitle: "Immersive cards for major weather systems.")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.majorCities) { snapshot in
                        LargeCityCard(snapshot: snapshot, isSelected: snapshot.id == viewModel.selectedCity?.id)
                            .onTapGesture {
                                viewModel.select(snapshot)
                            }
                    }
                }
                .padding(.horizontal, 1)
            }
        }
    }

    private var smallerCitiesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            citiesSectionTitle("Smaller Cities", subtitle: "Compact high-signal views for focused local climates.")

            LazyVGrid(columns: smallerColumns, spacing: 14) {
                ForEach(viewModel.smallerCities) { snapshot in
                    SmallerCityCard(snapshot: snapshot, isSelected: snapshot.id == viewModel.selectedCity?.id)
                        .onTapGesture {
                            viewModel.select(snapshot)
                        }
                }
            }
        }
    }

    private func citiesSectionTitle(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundStyle(.white)

            Text(subtitle)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.66))
        }
    }
}

private struct LargeCityCard: View {
    let snapshot: CitySnapshot
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(snapshot.preset.name)
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundStyle(.white)

                    Text(snapshot.preset.country)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.64))

                    Text(snapshot.conditionCode)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.78))
                        .lineLimit(2)
                }

                Spacer()

                Text(snapshot.formattedTemperature)
                    .font(.system(size: 56, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
            }

            HStack(spacing: 10) {
                CityCardPill(icon: "wind", value: snapshot.formattedWind, tint: snapshot.theme.accent)
                CityCardPill(icon: "gauge.with.dots.needle.33percent", value: snapshot.formattedPressure, tint: snapshot.theme.secondaryAccent)
                CityCardPill(icon: "leaf.fill", value: snapshot.aqiBand.title, tint: snapshot.aqiBand.color)
            }

            Spacer()

            Text(snapshot.updatedAt.formatted(.dateTime.hour().minute()))
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.5))
        }
        .padding(20)
        .frame(width: 290, height: 220, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            snapshot.theme.buildingFront.opacity(0.94),
                            snapshot.theme.buildingSide.opacity(0.92)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(isSelected ? Color.white.opacity(0.24) : Color.white.opacity(0.10), lineWidth: 1)
                )
        )
        .scaleEffect(isSelected ? 1.02 : 1)
        .shadow(color: Color.black.opacity(0.18), radius: 18, x: 0, y: 14)
    }
}

private struct SmallerCityCard: View {
    let snapshot: CitySnapshot
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(snapshot.preset.name)
                        .font(.system(size: 19, weight: .black, design: .rounded))
                        .foregroundStyle(.white)

                    Text(snapshot.preset.country)
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.white.opacity(0.6))
                        .lineLimit(2)
                }

                Spacer()

                Text(snapshot.formattedTemperature)
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
            }

            Text(snapshot.conditionCode)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.76))
                .lineLimit(2)

            HStack(spacing: 12) {
                Label(snapshot.formattedWind, systemImage: "wind")
                    .foregroundStyle(snapshot.theme.accent)

                Label("\(max(snapshot.aqiValue, 1))", systemImage: "leaf.fill")
                    .foregroundStyle(snapshot.aqiBand.color)
            }
            .font(.system(size: 11, weight: .bold, design: .rounded))
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.10))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(isSelected ? Color.white.opacity(0.22) : Color.white.opacity(0.08), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.14), radius: 16, x: 0, y: 12)
    }
}

private struct CityCardPill: View {
    let icon: String
    let value: String
    let tint: Color

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(tint)

            Text(value)
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(1)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.14))
        )
    }
}
