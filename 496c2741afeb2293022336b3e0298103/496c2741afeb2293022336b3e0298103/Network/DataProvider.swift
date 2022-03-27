//
//  DataProvider.swift
//  496c2741afeb2293022336b3e0298103
//
//  Created by yasintaskiran on 27.03.2022.
//

import Foundation
import Alamofire

private let stationURL: String = "https://run.mocky.io/v3/e7211664-cbb6-4357-9c9d-f12bf8bab2e2"

class DataProvider {
    func fetchStations(completion: @escaping (StationListResult) -> Void) {
        let request = AF.request(stationURL)
        request.responseDecodable(of: [Station].self) { response in
            switch response.result {
            case .success(let stations):
                completion(.success(stations))
            case .failure(let error):
                completion(.failed(error.localizedDescription))
            }
         }
    }
}
