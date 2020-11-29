//
//  AttestationView.swift
//  Attestation
//
//  Created by Adrien Humiliere on 30/10/2020.
//

import SwiftUI

struct AttestationView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @Binding var isPresented: Bool

    let attestation: Attestation

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    VStack(alignment: .center, spacing: 8) {
                        Text("Attestation de déplacement dérogatoire")
                            .font(.title2)
                            .bold()
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                        Text("En application du décret n°2020-1310 du 29 octobre 2020 prescrivant les mesures générales nécessaires pour faire face à l'épidémie de Covid19 dans le cadre de l'état d'urgence sanitaire.")
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                    }

                    VStack(alignment: .leading) {
                        Text("Je soussigné·e,").font(.subheadline).foregroundColor(.secondary)
                        Text("\(attestation.firstName ?? "") \(attestation.lastName ?? "")")
                    }

                    VStack(alignment: .leading) {
                        Text("né·e le").font(.subheadline).foregroundColor(.secondary)
                        Text(birthDateFormatter.string(from: attestation.birthDate!))
                        Text("à \(attestation.birthPlace ?? "")")
                    }

                    VStack(alignment: .leading) {
                        Text("demeurant").font(.subheadline).foregroundColor(.secondary)
                        Text("\(attestation.address ?? "")\n\(attestation.postalCode ?? "") \(attestation.city ?? "")")
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("certifie que mon déplacement est lié au motif suivant autorisé par le décret n°2020-1310 du 29 octobre 2020 prescrivant les mesures générales nécessaires pour faire face à l'épidémie de Covid 19 dans le cadre de l'état d'urgence sanitaire :").font(.subheadline).foregroundColor(.secondary)
                        HStack {
                            Image(systemName: attestation.kind!.symbolName)
                                .foregroundColor(attestation.kind!.color)
                            Text(attestation.kind!.shortDescription).bold()
                        }
                        Text(attestation.kind?.longDescription ?? "").font(.subheadline)
                    }

                    VStack(alignment: .leading) {
                        Text("Fait à").font(.subheadline).foregroundColor(.secondary)
                        Text("\(attestation.city ?? "")")
                        Text("le").font(.subheadline).foregroundColor(.secondary)
                        Text(tripDateFormatter.string(from: attestation.tripDate!))
                    }

                    if let qrCode = attestation.qrCode {
                        HStack {
                            Spacer()
                            Image(uiImage: qrCode)
                                .interpolation(.none)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250.0, height: 250.0)
                                .background(Color.green)
                            Spacer()
                        }
                        .padding(.vertical, 80)
                    }
                }
                .padding(.horizontal, 16)

            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isPresented = false
                    }) {
                        Label("Fermer", systemImage: "xmark")
                    }
                }
            }
            .navigationBarHidden(!isPresented)
        }
    }

    private let birthDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter
    }()

    private let tripDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .full
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter
    }()
}

struct AttestationView_Previews: PreviewProvider {
    static var previews: some View {
        let managedObjectContext = PersistenceController.preview.container.viewContext
        let attestation = Attestation(context: managedObjectContext)
        
        AttestationView(isPresented: .constant(false), attestation: attestation)
            .environment(\.managedObjectContext, managedObjectContext)
    }
}
