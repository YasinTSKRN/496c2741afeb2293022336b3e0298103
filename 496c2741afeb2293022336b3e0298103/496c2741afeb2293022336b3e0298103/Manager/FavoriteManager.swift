//
//  FavoriteManager.swift
//  496c2741afeb2293022336b3e0298103
//
//  Created by yasintaskiran on 28.03.2022.
//

import Foundation

class FavoriteManager {
    public static let shared: FavoriteManager = FavoriteManager()
    private var favorites: [Station] = []
    private init () { }

    func addFavorite(station: Station) {
        favorites.append(station)
    }

    func removeFavorite(station: Station) {
        favorites = favorites.filter { $0.name != station.name }
    }

    func isFavorited(station: Station) -> Bool {
        return favorites.contains { $0.name == station.name }
    }

    func getFavorites() -> [Station] {
        return favorites
    }
}
