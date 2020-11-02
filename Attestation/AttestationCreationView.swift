//
//  AttestationCreationView.swift
//  Attestation
//
//  Created by Adrien Humiliere on 29/10/2020.
//

import SwiftUI

struct AttestationCreationView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var birthDate = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
    @State private var birthPlace: String = ""
    @State private var address: String = ""
    @State private var city: String = ""
    @State private var postalCode: String = ""
    @State private var tripDate: Date = Date()

    @State private var selectedReason: Int = 0
    @State private var shouldSavePersonalData: Bool = false

    @State private var errorMessage: String = ""

    var personalData: PersonalData? = nil
    @State private var showPersonalDataAbstract = false
    let onGenerate: (AttestationFormData) -> ()

    private let birthDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter
    }()

    init(personalData: PersonalData?, onGenerate: @escaping (AttestationFormData) -> ()) {
        self.onGenerate = onGenerate
        self.personalData = personalData
    }

    var body: some View {
        NavigationView {
            Form {
                personalDataSection
                dateTimeSection
                attestationKindSection
                confirmationSection
            }
            .onAppear {
                loadPersonalData()
            }
            .navigationBarTitle("Nouvelle attestation", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Label("Fermer", systemImage: "xmark")
                    }
                }
            }
        }
    }

    var personalDataAbstract: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(firstName) \(lastName)").font(.subheadline)
                Text("Né·e le \(birthDateFormatter.string(from: birthDate)) à \(birthPlace)").font(.subheadline)
                Text("\(address) \(postalCode) \(city)").font(.subheadline)
            }
            .padding(.vertical, 8)

            Spacer()

            Button(action: {
                showPersonalDataAbstract = false
            }) {
                Image(systemName: "info.circle").foregroundColor(.accentColor)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    var personalDataSection: some View {
        Section(header: Text("Informations personnelles"),
                footer: Text("Note : Tous les champs sont obligatoires")) {
            if showPersonalDataAbstract {
                personalDataAbstract
            } else {
                TextField("Prénom", text: $firstName)
                    .textContentType(.givenName)
                TextField("Nom", text: $lastName)
                    .textContentType(.familyName)
                DatePicker("Date de naissance", selection: $birthDate, displayedComponents: .date)
                TextField("Lieu de naissance", text: $birthPlace)
                TextField("Adresse", text: $address)
                    .textContentType(.fullStreetAddress)
                TextField("Ville", text: $city)
                    .textContentType(.addressCity)
                TextField("Code Postal", text: $postalCode)
                    .textContentType(.postalCode)
                    .keyboardType(.numberPad)
            }
        }
    }

    var dateTimeSection: some View {
        Section(header: Text("Date et heure de sortie")) {
            DatePicker("Date et heure de sortie", selection: $tripDate).labelsHidden()
        }
    }

    var attestationKindSection: some View {
        Section(header: Text("Choisissez un motif de déplacement")) {
            Picker(selection: $selectedReason,
                   label: Text(AttestationKind.allCases[selectedReason]
                                .shortDescription)) {
                ForEach(0 ..< AttestationKind.allCases.count) { index in
                    HStack {
                        let attestationKind = AttestationKind.allCases[index]
                        Image(systemName: attestationKind.symbolName)
                        Text(attestationKind.shortDescription).tag(index)
                    }
                }
            }.pickerStyle(MenuPickerStyle())
        }
    }

    var confirmationSection: some View {
        Section(footer: Text(errorMessage)
                    .foregroundColor(Color.red)) {
            if !showPersonalDataAbstract {
                Toggle(isOn: $shouldSavePersonalData) {
                    Text("Enregistrer mes informations")
                }
            }
            Button(action: generateAttestation) {
                HStack {
                    Spacer()
                    Text("Générer mon attestation").bold()
                    Spacer()
                }
            }
        }
    }
}

extension AttestationCreationView {
    func loadPersonalData() {
        guard let personalData = personalData else { return }

        self.firstName = personalData.firstName
        self.lastName = personalData.lastName
        self.birthDate = personalData.birthDate
        self.birthPlace = personalData.birthPlace
        self.address = personalData.address
        self.city = personalData.city
        self.postalCode = personalData.postalCode
        self.showPersonalDataAbstract = true
        self.shouldSavePersonalData = true
    }

    func savePersonalData() {
        let personalData = PersonalData(firstName: firstName, lastName: lastName, birthDate: birthDate, birthPlace: birthPlace, address: address, city: city, postalCode: postalCode)
        let encoder = PropertyListEncoder()
        let data = try? encoder.encode(personalData)
        UserDefaults.standard.set(data, forKey: PersonalData.key)
    }

    func clearPersonalData() {
        UserDefaults.standard.set(nil, forKey: PersonalData.key)
    }
}

extension AttestationCreationView {
    func generateAttestation() {
        if let formData = formData {
            presentationMode.wrappedValue.dismiss()

            onGenerate(formData)

            if shouldSavePersonalData {
                savePersonalData()
            } else {
                clearPersonalData()
            }
        } else {
            errorMessage = "Attention, tous les champs sont obligatoires. Veuillez vérifier vos informations."
        }
    }

    var formData: AttestationFormData? {
        guard checkForm() else { return nil }
        return AttestationFormData(firstName: firstName,
                                   lastName: lastName,
                                   birthDate: birthDate,
                                   birthPlace: birthPlace,
                                   address: address,
                                   city: city,
                                   postalCode: postalCode,
                                   tripDate: tripDate,
                                   reason: AttestationKind.allCases[selectedReason].rawValue)
    }

    func checkForm() -> Bool {
        return !firstName.isEmpty
            && !lastName.isEmpty
            && !birthPlace.isEmpty
            && !address.isEmpty
            && !city.isEmpty
            && !postalCode.isEmpty
    }
}

struct CreateAttestationView_Previews: PreviewProvider {
    static var previews: some View {
        AttestationCreationView(personalData: nil, onGenerate: { _ in })
    }
}
