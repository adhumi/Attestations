//
//  AttestationKind.swift
//  Attestation
//
//  Created by Adrien Humiliere on 30/10/2020.
//

import SwiftUI

enum AttestationKind: String, CaseIterable {
    case promenade = "sport_animaux"
    case travail
    case ecole = "enfants"
    case courses = "achats"
    case sante
    case famille
    case assistance = "handicap"
    case convocation
    case missions

    var color: Color {
        switch self {
            case .promenade:
                return Color(Color.RGBColorSpace.displayP3, red: 1, green: 0.56, blue: 0, opacity: 1)
            case .travail:
                return Color.blue
            case .ecole:
                return Color.green
            case .courses:
                return Color.purple
            case .sante:
                return Color.red
            case .famille:
                return Color(Color.RGBColorSpace.displayP3, red: 0.37, green: 0.32, blue: 0.87, opacity: 1)
            case .assistance:
                return Color.orange
            case .convocation:
                return Color.pink
            case .missions:
                return Color.yellow
        }
    }

    var symbolName: String {
        switch self {
            case .promenade:
                return "figure.walk"
            case .travail:
                return "briefcase.fill"
            case .ecole:
                return "book.fill"
            case .courses:
                return "cart.fill"
            case .sante:
                return "staroflife.circle.fill"
            case .famille:
                return "person.2.square.stack"
            case .assistance:
                return "heart.circle.fill"
            case .convocation:
                return "scroll.fill"
            case .missions:
                return "star.square.fill"
        }
    }

    var shortDescription: String {
        switch self {
            case .promenade:
                return "Promenade & sport"
            case .travail:
                return "Travail"
            case .ecole:
                return "École"
            case .courses:
                return "Courses"
            case .sante:
                return "Santé"
            case .famille:
                return "Famille"
            case .assistance:
                return "Assistance"
            case .convocation:
                return "Convocation"
            case .missions:
                return "Missions"
        }
    }

    var longDescription: String {
        switch self {
            case .promenade:
                return "Déplacements brefs, dans la limite d'une heure quotidienne et dans un rayon maximal d'un kilomètre autour du domicile, liés soit à l'activité physique individuelle des personnes, à l'exclusion de toute pratique sportive collective et de toute proximité avec d'autres personnes, soit à la promenade avec les seules personnes regroupées dans un même domicile, soit aux besoins des animaux de compagnie."
            case .travail:
                return "Déplacements entre le domicile et le lieu d’exercice de l’activité professionnelle ou un établissement d’enseignement ou de formation, déplacements professionnels ne pouvant être différés, déplacements pour un concours ou un examen."
            case .ecole:
                return "Déplacement pour chercher les enfants à l’école et à l’occasion de leurs activités périscolaires."
            case .courses:
                return "Déplacements pour effectuer des achats de fournitures nécessaires à l'activité professionnelle, des achats de première nécessité dans des établissements dont les activités demeurent autorisées, le retrait de commande et les livraisons à domicile."
            case .sante:
                return "Consultations, examens et soins ne pouvant être assurés à distance et l’achat de médicaments."
            case .famille:
                return "Déplacements pour motif familial impérieux, pour l'assistance aux personnes vulnérables et précaires ou la garde d'enfants."
            case .assistance:
                return "Déplacement des personnes en situation de handicap et leur accompagnant."
            case .convocation:
                return "Convocation judiciaire ou administrative et pour se rendre dans un service public."
            case .missions:
                return "Participation à des missions d'intérêt général sur demande de l'autorité administrative."
        }
    }
}

extension Attestation {
    var kind: AttestationKind? {
        guard let reasonIdentifier = reasonIdentifier else { return nil }
        return AttestationKind(rawValue: reasonIdentifier)
    }
}
