//
//  CreateAttestationView.swift
//  Attestation
//
//  Created by Adrien Humiliere on 29/10/2020.
//

import SwiftUI

struct CreateAttestationView: View {
    @Binding var isPresented: Bool

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var birthDate = Date()
    @State private var birthPlace: String = ""
    @State private var address: String = ""
    @State private var city: String = ""
    @State private var postalCode: String = ""
    @State private var tripDate: Date = Date()

    @State private var selectedReason: Int = 0
    @State private var reasons = ["travail", "achats", "sante", "famille", "handicap", "sport_animaux", "convocation", "missions", "enfants"]

    @State private var errorMessage: String = ""

    let onGenerate: (AttestationFormData) -> ()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informations personnelles"),
                        footer: Text("Note : Tous les champs sont obligatoires")) {
                    TextField("Prénom", text: $firstName)
                    TextField("Nom", text: $lastName)
                    DatePicker("Date de naissance", selection: $birthDate, displayedComponents: .date)
                    TextField("Lieu de naissance", text: $birthPlace)
                    TextField("Adresse", text: $address)
                    TextField("Ville", text: $city)
                    TextField("Code Postal", text: $postalCode).keyboardType(.numberPad)
                }

                Section(header: Text("Date et heure de sortie")) {
                    DatePicker("Date et heure de sortie", selection: $tripDate).labelsHidden()
                }

                Section(header: Text("Choisissez un motif de déplacement")) {
                    Picker(selection: $selectedReason,
                           label: Text(reasons[selectedReason]
                                        .localizedCapitalized)) {
                        ForEach(0 ..< reasons.count) {
                            Text(self.reasons[$0].localizedCapitalized).tag($0)
                        }
                    }.pickerStyle(MenuPickerStyle())
                }

                Section(footer: Text(errorMessage)
                            .foregroundColor(Color.red)) {
                    Button(action: {
                        if checkForm() {
                            isPresented = false

                            let formData = AttestationFormData(firstName: firstName,
                                                               lastName: lastName,
                                                               birthDate: birthDate,
                                                               birthPlace: birthPlace,
                                                               address: address,
                                                               city: city,
                                                               postalCode: postalCode,
                                                               tripDate: tripDate,
                                                               reason: reasons[selectedReason])
                            onGenerate(formData)
                        } else {
                            errorMessage = "Attention, tous les champs sont obligatoires. Veuillez vérifier vos informations."
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text("Générer").bold()
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarTitle("Nouvelle attestation", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isPresented = false
                    }) {
                        Label("Fermer", systemImage: "xmark")
                    }
                }

            }
        }
    }

    func checkForm() -> Bool {
        return !firstName.isEmpty && !lastName.isEmpty && !birthPlace.isEmpty && !address.isEmpty && !city.isEmpty && !postalCode.isEmpty
    }
}

struct CreateAttestationView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAttestationView(isPresented: .constant(false), onGenerate: { _ in })
    }
}
