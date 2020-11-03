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

    var body: some View {
        NavigationView {
            List {
                ForEach(attestations) { attestation in
                    NavigationLink(destination: AttestationView(attestation: attestation)) {
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
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Attestations")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.showingCreationForm.toggle()
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }.sheet(isPresented: $showingCreationForm) {
            AttestationCreationView(isPresented: $showingCreationForm, personalData: personalData)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            let attestationsToDelete = offsets.map { attestations[$0] }
            try? service.delete(attestations: attestationsToDelete)
        }
    }

    var personalData: PersonalData? {
        guard let data = UserDefaults.standard.data(forKey: PersonalData.key) else { return nil }
        let decoder = PropertyListDecoder()
        return try? decoder.decode(PersonalData.self, from: data)
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
