//
//  Screenshots.swift
//  Screenshots
//
//  Created by Adrien Humiliere on 17/01/2021.
//

import XCTest

class Screenshots: XCTestCase {

    override func setUpWithError() throws {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launchArguments += ["-AppleLanguages", "(fr)"]
        app.launchArguments += ["-AppleLocale", "fr_FR"]
        app.launch()

        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        let app = XCUIApplication()
        while app.buttons.element(matching: NSPredicate(format: "identifier BEGINSWITH 'Attestation'")).exists {
            app.cells.element(boundBy: 1).swipeLeft()
            app.buttons["Delete"].tap()
        }
    }

    func testLaunchPerformance() throws {
        let app = XCUIApplication()
        
        // Populate
        createAttestation(app: app,
                          at: Date().addingTimeInterval(-20 * 60),
                          kind: "Travail et formation")
        createAttestation(app: app,
                          at: Date().addingTimeInterval(-1 * (24 * 3500)),
                          kind: "Famille")
        createAttestation(app: app,
                          at: Date().addingTimeInterval(-1 * (24 * 3600)),
                          kind: "Travail et formation")
        createAttestation(app: app,
                          at: Date().addingTimeInterval(-3 * (24 * 3754)),
                          kind: "Missions")
        createAttestation(app: app,
                          at: Date().addingTimeInterval(-7 * (24 * 3457)),
                          kind: "Travail et formation")
        createAttestation(app: app,
                          at: Date().addingTimeInterval(-20 * (24 * 3320)),
                          kind: "Voyages longue distance")
             
        // Screenshot: Home
        snapshot("1_home")

        // Screenshot: Creation form
        showCreationForm(app: app)
        snapshot("2_creation-form")
        app.buttons["Close"].tap()

        // Screenshot: Attestation 1
        app.cells.element(boundBy: 1).tap()
        snapshot("3_attestation-1")

        // Screenshot: Attestation 2
        app.scrollViews.otherElements.staticTexts["Attestation de déplacement dérogatoire"].swipeUp()
        snapshot("4_attestation-2")
        app.buttons["Attestations"].tap()
    }
    
    func createAttestation(app: XCUIApplication, at date: Date, kind: String) {
        showCreationForm(app: app)
        fillCreationFormIfNeeded(app: app)
        
        app.tables.datePickers["AttestationDatePicker"].tap()
        
        applyDateToPicker(app: app, date: date)
        app.tapCoordinate(at: CGPoint(x: 30, y: 100))
        app.tables.firstMatch.swipeUp()
        
        app.tables.cells["Travail et formation"].buttons["Travail et formation"].tap()
        app.scrollViews.otherElements.staticTexts[kind].tap()
        
        app.tables.firstMatch.swipeUp()
        app.tables.buttons["Générer mon attestation"].tap()
    }
    
    func showCreationForm(app: XCUIApplication) {
        if app.tables.cells["doc.badge.plus, Travail et formation, Docteur, pharmacie, doc.badge.plus"].otherElements.containing(.button, identifier:"doc.badge.plus").children(matching: .button).matching(identifier: "doc.badge.plus").element(boundBy: 1).exists {
            app.tables.cells["doc.badge.plus, Travail et formation, Docteur, pharmacie, doc.badge.plus"].otherElements.containing(.button, identifier:"doc.badge.plus").children(matching: .button).matching(identifier: "doc.badge.plus").element(boundBy: 1).tap()
        } else {
            app.tables.buttons["doc.badge.plus"].tap()
        }
    }
    
    func fillCreationFormIfNeeded(app: XCUIApplication) {
        if app.tables.textFields["Prénom"].exists {
            fillCreationForm(app: app)
        }
    }
    
    func fillCreationForm(app: XCUIApplication) {
        let birthDate: Date = {
            let components = DateComponents(calendar: .current, year: 1991, month: 07, day: 29)
            return components.date!
        }()
        
        app.tables.textFields["Prénom"].tap()
        app.tables.textFields["Prénom"].typeText("Valérie")
        
        app.tables.textFields["Nom"].tap()
        app.tables.textFields["Nom"].typeText("Diaz")
        
        app.tables.datePickers["BirthDatePicker"].tap()
        applyDateToPicker(app: app, date: birthDate)
        app.tapCoordinate(at: CGPoint(x: 1, y: 100))
        
        app.tables.textFields["Lieu de naissance"].tap()
        app.tables.textFields["Lieu de naissance"].typeText("Delahaye")
        
        app.tables.textFields["Adresse"].tap()
        app.tables.textFields["Adresse"].typeText("90 avenue Michel Pons")
        
        app.tables.textFields["Ville"].tap()
        app.tables.textFields["Ville"].typeText("Delahaye")
        
        app.tables.textFields["Code Postal"].tap()
        app.tables.textFields["Code Postal"].typeText("77141")
        
        app.tables.element(boundBy: 0).swipeUp()
        app.tables.switches["Enregistrer mes informations"].tap()
    }
    
    func applyDateToPicker(app: XCUIApplication, date: Date) {
        func fullDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE dd MMMM"
            return formatter.string(from: date)
        }
        
        func day(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd"
            return formatter.string(from: date)
        }
        
        func month(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM"
            return formatter.string(from: date)
        }
        
        func year(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            return formatter.string(from: date)
        }
        
        func time(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "HHmm"
            return formatter.string(from: date)
        }
        
        print(fullDate(date))
        print(day(date))
        print(month(date))
        print(year(date))
        
        app.buttons["Show year picker"].tap()
        XCTAssert(adjustDatePicker(wheel: app.pickerWheels.element(boundBy: 0), to: month(date)))
        XCTAssert(adjustDatePicker(wheel: app.pickerWheels.element(boundBy: 1), to: year(date)))
        app.buttons["Hide year picker"].tap()
        app.collectionViews.otherElements.containing(.staticText, identifier:day(date)).element.doubleTap()
        
        if app.datePickers.otherElements["Minutes"].exists {
            app.datePickers.otherElements["Minutes"].tap()
            
            for digit in Array(time(date)) {
                app.keys[String(digit)].tap()
            }
        }
    }
    
    func adjustDatePicker(wheel: XCUIElement, to newValue: String) -> Bool {
        let x = wheel.frame.width / 2.0
        let y = wheel.frame.height / 2.0
        // each wheel notch is about 30px high, so tapping y - 30 rotates up. y + 30 rotates down.
        var offset: CGFloat = -30.0
        var reversed = false
        let previousValue = wheel.value as? String
        while wheel.value as? String != newValue {
            wheel.coordinate(withNormalizedOffset: .zero).withOffset(CGVector(dx: x, dy: y + offset)).tap()
            let briefWait = expectation(description: "Wait for wheel to rotate")
            briefWait.isInverted = true
            wait(for: [briefWait], timeout: 0.25)
            if previousValue == wheel.value as? String {
                if reversed {
                    // we already tried reversing, can't find the desired value
                    break
                }
                // we didn't move the wheel. try reversing direction
                offset = 30.0
                reversed = true
            }
        }
        
        return wheel.value as? String == newValue
    }
}

extension XCUIApplication {
    func tapCoordinate(at point: CGPoint) {
        let normalized = coordinate(withNormalizedOffset: .zero)
        let offset = CGVector(dx: point.x, dy: point.y)
        let coordinate = normalized.withOffset(offset)
        coordinate.tap()
    }
}
