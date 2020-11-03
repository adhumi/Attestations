//
//  AttestationApp.swift
//  Attestation
//
//  Created by Adrien Humiliere on 29/10/2020.
//

import SwiftUI

@main
struct AttestationApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ListView(service: AttestationService(persistenceController: persistenceController))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
