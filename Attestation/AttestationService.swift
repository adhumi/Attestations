//
//  AttestationService.swift
//  Attestation
//
//  Created by Adrien Humiliere on 03/11/2020.
//

import SwiftUI
import CoreData

class AttestationService {
    private let persistenceController: PersistenceController

    private var context: NSManagedObjectContext {
        persistenceController.container.viewContext
    }

    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
    }
}

extension AttestationService {
    func delete(attestation: Attestation) throws {
        context.delete(attestation)
        try context.save()
    }

    func delete(attestations: [Attestation]) throws {
        attestations.forEach(context.delete)
        try context.save()
    }
}
