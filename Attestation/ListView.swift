//
//  ContentView.swift
//  Attestation
//
//  Created by Adrien Humiliere on 29/10/2020.
//

import SwiftUI
import CoreData

struct ListView: View {
    let service: AttestationService

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Attestation.tripDate, ascending: false)],
                  animation: .default)
    var attestations: FetchedResults<Attestation>

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Attestation.tripDate, ascending: false)],
                  animation: .default)
    var recentAttestations: FetchedResults<Attestation>

    @State var showingCreationForm = false
    @State var showingFirstPicker = false
    @State var showingSecondPicker = false
    @State var showingAttestation = false

    @State private var firstSelectedReason: Int = {
        var value = UserDefaults.standard.value(forKey: "firstSelectedReason") as? Int ?? 0
        guard value < AttestationKind.actives.count else { return 0 }
        return value
    }()
    @State private var secondSelectedReason: Int = {
        var value = UserDefaults.standard.value(forKey: "secondSelectedReason") as? Int ?? 1
        guard value < AttestationKind.actives.count else { return 1 }
        return value
    }()

    var body: some View {
        NavigationView {
            List {
                VStack(alignment: .center, spacing: 16) {
                    if let latestAttestation = latestAttestation {
                        currentAttestationButton(latestAttestation)
                    } else {
                        newAttestationLargeButton
                    }

                    HStack(spacing: 16) {
                        newAttestationButton(kind: AttestationKind.actives[firstSelectedReason], showPicker: { showingFirstPicker.toggle() })
                            .sheet(isPresented: $showingFirstPicker) {
                                KindPickerView(isPresented: $showingFirstPicker, selectedIndex: $firstSelectedReason) { newValue in
                                    UserDefaults.standard.set(newValue, forKey: "firstSelectedReason")
                                }
                            }

                        newAttestationButton(kind: AttestationKind.actives[secondSelectedReason], showPicker: { showingSecondPicker.toggle() })
                            .sheet(isPresented: $showingSecondPicker) {
                                KindPickerView(isPresented: $showingSecondPicker, selectedIndex: $secondSelectedReason) { newValue in
                                    UserDefaults.standard.set(newValue, forKey: "secondSelectedReason")
                                }
                            }

                        newAttestationButton()
                    }
                }
                .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 90, trailing: 16))


                ForEach(attestations) { attestation in
                    NavigationLink(destination: AttestationView(isPresented: .constant(false), attestation: attestation)) {
                        HStack {
                            Image(systemName: attestation.kind!.symbolName)
                                .font(.system(size: 20))
                                .frame(width: 40, height: 40, alignment: .center)
                                .foregroundColor(attestation.kind!.color)
                                .aspectRatio(1, contentMode: .fit)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(itemFormatter.string(from: attestation.tripDate!))
                                Text(attestation.kind!.shortDescription)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .accessibility(identifier: "Attestation\(attestation.creationDate!.timeIntervalSince1970)")
                }
                .onDelete(perform: deleteItems)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Comment mes données sont-elles utilisées ?")
                        .font(.headline)
                    Text("Les données que vous entrez ne sont utilisées que par vous, pour générer des attestations plus rapidement. Elles ne sont envoyées à aucun serveur et nous ne faisons aucune analyse de vos données de navigation.")
                }.padding(.vertical, 40)
            }
            .navigationTitle("Attestations")
        }.sheet(isPresented: $showingCreationForm) {
            AttestationCreationView(isPresented: $showingCreationForm, personalData: personalData)
        }
    }

    private var newAttestationLargeButton: some View {
        Button(action: {
                self.showingCreationForm.toggle()
        }) {
            HStack {
                Spacer()
                Image(systemName: "doc.badge.plus")
                    .font(.system(size: 34))
                    .foregroundColor(.accentColor)
                Spacer()
            }

        }
        .buttonStyle(PlainButtonStyle())
        .frame(height: 250)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }

    private func currentAttestationButton(_ attestation: Attestation) -> some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Image(systemName: attestation.kind!.symbolName)
                    .font(.system(size: 34))
                    .foregroundColor(attestation.kind!.color)
                Text(attestation.kind!.shortDescription)
                    .font(.title3)
                    .bold()
                    .padding(.top, 12)

                if let duration = attestation.kind?.duration {
                    if attestation.tripDate! < Date() {
                        let elapsedTime = Date().timeIntervalSince(attestation.tripDate!)
                        let remainingTime = duration - elapsedTime
                        Text(String(format: "%.f minutes restantes", remainingTime / 60))
                            .font(.body)
                            .foregroundColor(.secondary)
                    } else {
                        let timeToStart = attestation.tripDate!.timeIntervalSince(Date())
                        Text(String(format: "dans %.f minutes", timeToStart / 60))
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer(minLength: 36)
                Button(action: {
                    showingAttestation.toggle()
                }) {
                    Text("Afficher")
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
                .sheet(isPresented: $showingAttestation) {
                    AttestationView(isPresented: $showingAttestation, attestation: attestation)
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
            }
            Spacer()
        }
        .frame(height: 250)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }

    private func newAttestationButton(kind: AttestationKind? = nil, showPicker: (() -> Void)? = nil) -> some View {
        Button(action: {}) {
            HStack {
                Spacer()
                if let kind = kind {
                    VStack(spacing: 8) {
                        Image(systemName: kind.symbolName)
                            .font(.system(size: 20))
                            .foregroundColor(kind.color)
                        Text(kind.superShortDescription)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                    }
                } else {
                    Image(systemName: "doc.badge.plus")
                        .font(.system(size: 20))
                        .foregroundColor(.accentColor)
                }
                Spacer()
            }
            .onTapGesture {
                if let kind = kind, let _ = personalData {
                    try? newAttestationShortcut(kind: kind)
                } else {
                    self.showingCreationForm.toggle()
                }
            }
            .onLongPressGesture {
                guard kind != nil else { return }
                showPicker?()
            }
        }
        .frame(height: 100)
        .buttonStyle(PlainButtonStyle())
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            let attestationsToDelete = offsets.map { attestations[$0] }
            try? service.delete(attestations: attestationsToDelete)
        }
    }

    private var personalData: PersonalData? {
        guard let data = UserDefaults.standard.data(forKey: PersonalData.key) else { return nil }
        let decoder = PropertyListDecoder()
        return try? decoder.decode(PersonalData.self, from: data)
    }

    private var latestAttestation: Attestation? {
        guard let latestAttestation = attestations.first else { return nil }

        let duration = latestAttestation.kind!.duration ?? 60 * 60

        if latestAttestation.tripDate! < Date()
            && latestAttestation.tripDate!.addingTimeInterval(duration) > Date() {
            return latestAttestation
        }

        if latestAttestation.tripDate! > Date() {
            return latestAttestation
        }

        return nil
    }

    private func newAttestationShortcut(kind: AttestationKind) throws {
        guard let personalData = personalData else {
            return
        }

        try withAnimation {
            let newAttestation = Attestation(context: service.context)
            newAttestation.creationDate = Date()
            newAttestation.firstName = personalData.firstName
            newAttestation.lastName = personalData.lastName
            newAttestation.birthDate = personalData.birthDate
            newAttestation.birthPlace = personalData.birthPlace
            newAttestation.address = personalData.address
            newAttestation.city = personalData.city
            newAttestation.postalCode = personalData.postalCode
            newAttestation.tripDate = Date()
            newAttestation.reasonIdentifier = kind.rawValue

            try service.context.save()
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    formatter.dateStyle = .medium
    formatter.doesRelativeDateFormatting = true
    formatter.locale = Locale(identifier: "fr_FR")
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(service: AttestationService(persistenceController: PersistenceController.preview))
    }
}
