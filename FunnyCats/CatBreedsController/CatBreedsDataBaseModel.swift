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
    let breeds: [Breed]
    let id: String
    let url: String
    let width, height: Int
}

// MARK: - Breed
struct Breed: Codable {
    let weight: Weight
    let id, name: String
    let cfaURL: String
    let vetstreetURL: String
    let vcahospitalsURL: String
    let temperament, origin, countryCodes, countryCode: String
    let breedDescription, lifeSpan: String
    let indoor, lap, adaptability, affectionLevel: Int
    let childFriendly, catFriendly, dogFriendly, energyLevel: Int
    let grooming, healthIssues, intelligence, sheddingLevel: Int
    let socialNeeds, strangerFriendly, vocalisation, bidability: Int
    let experimental, hairless, natural, rare: Int
    let rex, suppressedTail, shortLegs: Int
    let wikipediaURL: String
    let hypoallergenic: Int

    enum CodingKeys: String, CodingKey {
        case weight, id, name
        case cfaURL = "cfa_url"
        case vetstreetURL = "vetstreet_url"
        case vcahospitalsURL = "vcahospitals_url"
        case temperament, origin
        case countryCodes = "country_codes"
        case countryCode = "country_code"
        case breedDescription = "description"
        case lifeSpan = "life_span"
        case indoor, lap, adaptability
        case affectionLevel = "affection_level"
        case childFriendly = "child_friendly"
        case catFriendly = "cat_friendly"
        case dogFriendly = "dog_friendly"
        case energyLevel = "energy_level"
        case grooming
        case healthIssues = "health_issues"
        case intelligence
        case sheddingLevel = "shedding_level"
        case socialNeeds = "social_needs"
        case strangerFriendly = "stranger_friendly"
        case vocalisation, bidability, experimental, hairless, natural, rare, rex
        case suppressedTail = "suppressed_tail"
        case shortLegs = "short_legs"
        case wikipediaURL = "wikipedia_url"
        case hypoallergenic
    }
}

// MARK: - Weight
struct Weight: Codable {
    let imperial, metric: String
}

