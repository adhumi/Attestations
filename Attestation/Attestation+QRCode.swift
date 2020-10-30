//
//  Attestation+QRCode.swift
//  Attestation
//
//  Created by Adrien Humiliere on 30/10/2020.
//

import UIKit

extension Attestation {
    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }

    private var codeContent: String {
        let code = "Cree le: \(creationDate);\n Nom: \(String(describing: lastName));\n Prenom: \(String(describing: firstName));\n Naissance: \(String(describing: birthDate)) a \(birthPlace);\n Adresse: \(address)  \(postalCode) \(city); Sortie: \(tripDate); Motifs: \(reasonIdentifier)"
        return code
    }

    var qrCode: UIImage? {
        return generateQRCode(from: codeContent)
    }
}
