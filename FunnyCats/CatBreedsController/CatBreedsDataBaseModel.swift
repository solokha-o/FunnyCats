//
//  CatBreedsDataBaseModel.swift
//  FunnyCats
//
//  Created by Oleksandr Solokha on 29.04.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import Foundation

// MARK: - CatBreedsDataBaseModel
struct CatBreedsDataBaseModel: Codable {
    let weight: Weight
    let id, name: String
    let cfaURL: String?
    let vetstreetURL: String?
    let vcahospitalsURL: String?
    let temperament, origin, countryCodes, countryCode: String
    let welcomeDescription, lifeSpan: String
    let indoor: Int
    let lap: Int?
    let altNames: String?
    let adaptability, affectionLevel, childFriendly, dogFriendly: Int
    let energyLevel, grooming, healthIssues, intelligence: Int
    let sheddingLevel, socialNeeds, strangerFriendly, vocalisation: Int
    let experimental, hairless, natural, rare: Int
    let rex, suppressedTail, shortLegs: Int
    let wikipediaURL: String?
    let hypoallergenic: Int
    let catFriendly, bidability: Int?

    enum CodingKeys: String, CodingKey {
        case weight, id, name
        case cfaURL = "cfa_url"
        case vetstreetURL = "vetstreet_url"
        case vcahospitalsURL = "vcahospitals_url"
        case temperament, origin
        case countryCodes = "country_codes"
        case countryCode = "country_code"
        case welcomeDescription = "description"
        case lifeSpan = "life_span"
        case indoor, lap
        case altNames = "alt_names"
        case adaptability
        case affectionLevel = "affection_level"
        case childFriendly = "child_friendly"
        case dogFriendly = "dog_friendly"
        case energyLevel = "energy_level"
        case grooming
        case healthIssues = "health_issues"
        case intelligence
        case sheddingLevel = "shedding_level"
        case socialNeeds = "social_needs"
        case strangerFriendly = "stranger_friendly"
        case vocalisation, experimental, hairless, natural, rare, rex
        case suppressedTail = "suppressed_tail"
        case shortLegs = "short_legs"
        case wikipediaURL = "wikipedia_url"
        case hypoallergenic
        case catFriendly = "cat_friendly"
        case bidability
    }
}

// MARK: - Weight
struct Weight: Codable {
    let imperial, metric: String
}

typealias CatBreeds = [CatBreedsDataBaseModel]
