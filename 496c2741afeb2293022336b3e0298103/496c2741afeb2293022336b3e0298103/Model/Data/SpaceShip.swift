//
//  SpaceShip.swift
//  496c2741afeb2293022336b3e0298103
//
//  Created by yasintaskiran on 27.03.2022.
//

import Foundation

struct SpaceShip {
    var integrity: Int = 100
    var speed: Int
    var capacity: Int
    var endurance: Int
    var name: String

    init(name: String, speed: Int, capacity: Int, endurance: Int) {
        self.name = name
        self.speed = speed
        self.capacity = capacity
        self.endurance = endurance
    }
}
