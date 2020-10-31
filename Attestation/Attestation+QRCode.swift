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
        let code = "Cree le: \(creationDate);\n Nom: \(String(describing: lastName));\n Prenom: \(String(describing: firstName));\n Naissance: \(String(describing: birthDate)) a \(birthPlace);\n Adresse: \(address)  \(postalCode) \(city); Sortie: \(tripDate); Motifs: \(reasonIdentifier)"
        return code
    }

    var qrCode: UIImage? {
        return generateQRCode(from: codeContent)
    }
}
