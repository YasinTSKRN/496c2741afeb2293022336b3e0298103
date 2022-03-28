//
//  StationsViewModel.swift
//  496c2741afeb2293022336b3e0298103
//
//  Created by yasintaskiran on 27.03.2022.
//

import Foundation

class StationsViewModel {

    private lazy var dataProvider: DataProvider = DataProvider()
    var availableStations: [Station] = []
    var stationStates: [String: Bool] = [:]

    var currentStationIndex: Int = 0
    var leftCapacity: Int = 0
    var leftFuel: Int = 0
    var shipEndurance: Int = 0
    var leftIntegrity: Double = 0

    var filteredStations: [Station] = []

    func fetchStations(completion: (() -> ())?) {
        dataProvider.fetchStations { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let list):
                strongSelf.availableStations.append(contentsOf: list)
                for station in list {
                    strongSelf.stationStates[station.name] = false
                }
                completion?()
            case .failed(let error):
                print("##### - error fetching: \(error)")
                completion?()
            }
        }
    }

    func setInitialValues(ship: SpaceShip) {
        leftCapacity = ship.capacity * 10000
        leftFuel = ship.speed * 20
        shipEndurance = ship.endurance
        leftIntegrity = Double(ship.integrity)
    }

    func calculateDistance(destination: Station) -> Int {
        guard self.currentStationIndex < self.availableStations.count else { return 0 }
        let currentStation = self.availableStations[self.currentStationIndex]
        let difX = abs(currentStation.coordinateX - destination.coordinateX)
        let difY = abs(currentStation.coordinateY - destination.coordinateY)
        return Int(sqrt(pow(difX, 2) + pow(difY, 2)).rounded())
    }

    func canTravel(to stationIndex: Int) -> Bool {
        guard stationIndex < self.availableStations.count else { return false }
        let station = self.availableStations[stationIndex]
        return canTravel(to: station)
    }

    private func canTravel(to station: Station) -> Bool {
        if station.capacity == station.stock {
            return false
        }
        if (station.capacity - station.stock) > leftCapacity {
            return false
        }
        let distance = calculateDistance(destination: station)
        if Int(distance) > leftFuel {
            return false
        }
        if calculateDamage(distance: distance) > leftIntegrity {
            return false
        }
        return true
    }

    func calculateDamage(distance: Int) -> Double {
        return (Double(distance) * 100 / Double(shipEndurance)).rounded() / 100
    }

    func travel(to stationIndex: Int) {
        guard stationIndex < self.availableStations.count else { return }
        var station = self.availableStations[stationIndex]
        leftCapacity -= station.capacity - station.stock
        station.stock = station.capacity
        let distance = calculateDistance(destination: station)
        leftFuel -= distance
        leftIntegrity -= calculateDamage(distance: distance)
        self.availableStations[stationIndex] = station
        self.currentStationIndex = stationIndex
    }

    func isFinished() -> Bool {
        for station in availableStations {
            if canTravel(to: station) {
                return false
            }
        }
        return true
    }

    func filterList(text: String) {
        filteredStations.removeAll()
        filteredStations.append(contentsOf: availableStations.filter { $0.name.uppercased() != "Dünya".uppercased() })
        if text != "" {
            filteredStations = filteredStations.filter { $0.name.uppercased().contains(text.uppercased()) }
        }
    }

    func getIndex(of station: Station) -> Int {
        return availableStations.firstIndex{ $0.name == station.name } ?? 0
    }
}
