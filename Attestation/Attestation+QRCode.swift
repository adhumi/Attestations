//
//  Attestation+QRCode.swift
//  Attestation
//
//  Created by Adrien Humiliere on 30/10/2020.
//

import UIKit
import CoreImage.CIFilterBuiltins

extension Attestation {
    private func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage =  filter.outputImage {
            if let cgImg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImg)
            }
        }

        return nil
    }

    private var codeContent: String {
        let dateHourFormatter = DateFormatter()
        dateHourFormatter.timeStyle = .short
        dateHourFormatter.dateStyle = .short
        dateHourFormatter.locale = Locale(identifier: "fr_FR")

        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        dateFormatter.locale = Locale(identifier: "fr_FR")

        let code = "Cree le: \(dateHourFormatter.string(from: creationDate!));\n Nom: \(lastName!);\n Prenom: \(firstName!);\n Naissance: \(dateFormatter.string(from: birthDate!)) a \(birthPlace!);\n Adresse: \(address!) \(postalCode!) \(city!);\n Sortie: \(dateHourFormatter.string(from: tripDate!));\n Motifs: \(reasonIdentifier!)"
        print(code)
        return code
    }

    var qrCode: UIImage? {
        return generateQRCode(from: codeContent)
    }
}
