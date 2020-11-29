//
//  KindPickerView.swift
//  Attestation
//
//  Created by Adrien Humiliere on 28/11/2020.
//

import SwiftUI

struct KindPickerView: View {
    @Binding var isPresented: Bool
    @Binding var selectedIndex: Int

    var onChange: (Int) -> Void

    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ScrollView {
            HStack {
                Text("Choisir un motif")
                    .font(.title2)
                    .bold()
                Spacer()
            }.padding()

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(0 ..< AttestationKind.allCases.count) { index in
                    HStack(alignment: .center) {
                        let attestationKind = AttestationKind.allCases[index]
                        Image(systemName: attestationKind.symbolName).foregroundColor(attestationKind.color)
                        Text(attestationKind.shortDescription).tag(index)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: .infinity)
                    .background(Color(red: 0.95, green: 0.95, blue: 0.97))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(red: 0.75, green: 0.75, blue: 0.77), lineWidth: selectedIndex == index ? 1 : 0)
                    )
                    .onTapGesture {
                        selectedIndex = index
                        onChange(index)
                        isPresented.toggle()
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.top, 30)
    }
}

struct KindPickerView_Previews: PreviewProvider {
    static var previews: some View {
        KindPickerView(isPresented: .constant(true), selectedIndex: .constant(2), onChange: { _ in })
    }
}
