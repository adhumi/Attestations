//
//  PersonalData.swift
//  Attestation
//
//  Created by Adrien Humiliere on 31/10/2020.
//

import Foundation

struct PersonalData: Codable {
    let firstName: String
    let lastName: String
    let birthDate: Date
    let birthPlace: String
    let address: String
    let city: String
    let postalCode: String
}
