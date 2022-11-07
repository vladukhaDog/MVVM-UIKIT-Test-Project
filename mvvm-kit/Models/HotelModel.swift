//
//  HotelModel.swift
//  TestTask
//
//  Created by Владислав Пермяков on 29.10.2022.
//

import Foundation

struct Hotel: Codable{
    
    let id: Int
    let name, address: String
    let stars: Double
    let distance: Double
    let image: String?
    let suitesAvailability: String
    let lat, lon: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, name, address, stars, distance, image
        case suitesAvailability = "suites_availability"
        case lat, lon
    }
}

extension Hotel{
    ///Метод возвращающий массив свободных номеров
    func availableSuites() -> [String]{
        return self.suitesAvailability.components(separatedBy: ":").filter({!$0.isEmpty})
    }
}
