//
//  AttestationView.swift
//  Attestation
//
//  Created by Adrien Humiliere on 30/10/2020.
//

import SwiftUI

struct AttestationView: View {
    @Environment(\.managedObjectContext) private var viewContext

    let attestation: Attestation

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 8) {
                Text("Attestation de déplacement dérogatoire")
                    .font(.title)
                    .multilineTextAlignment(.center)
                Text("En application des mesures générales nécessaires pour faire face à l’épidémie de covid-19 dans le cadre de l’état d’urgence sanitaire.")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 16)

            VStack(alignment: .leading, spacing: 8) {
                Text("Je soussigné·e,")
                Text("\(attestation.firstName ?? "") \(attestation.lastName ?? "")")
                Text("Né·e le \(attestation.birthDate ?? Date()) à \(attestation.birthPlace ?? "")")
                Text("Demeurant \(attestation.address ?? "") \(attestation.postalCode ?? "") \(attestation.city ?? "")")
                Text("certifie que mon déplacement est lié au motif suivant autorisé en application des mesures générales nécessaires pour faire face à l'épidémie de Covid 19 dans le cadre de l'état d'urgence sanitaire :")
                Text(attestation.reasonDescription ?? "")
                Text("Fait à \(attestation.city ?? "")")
                Text("Le \(attestation.tripDate ?? Date())")
            }
            .padding(.horizontal, 16)

            if let qrCode = attestation.qrCode {
                Image(uiImage: qrCode)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250.0, height: 250.0)
            }
        }
    }
}

struct AttestationView_Previews: PreviewProvider {
    static var previews: some View {
        let attestation = Attestation(context: PersistenceController.preview.container.viewContext)

        AttestationView(attestation: attestation)
    }
}
