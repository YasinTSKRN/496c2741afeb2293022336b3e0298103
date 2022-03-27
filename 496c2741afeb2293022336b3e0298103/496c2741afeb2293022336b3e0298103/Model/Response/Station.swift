//
//  Station.swift
//  496c2741afeb2293022336b3e0298103
//
//  Created by yasintaskiran on 27.03.2022.
//

import Foundation

struct Station: Decodable {
    let name: String
    let coordinateX: Double
    let coordinateY: Double
    let capacity: Int
    let stock: Int
    let need: Int
}

enum StationListResult {
    case success([Station])
    case failed(String)
}
