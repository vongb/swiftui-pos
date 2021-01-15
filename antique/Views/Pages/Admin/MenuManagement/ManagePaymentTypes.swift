//
//  AddPaymentType.swift
//  antique
//
//  Created by Vong Beng on 11/9/20.
//  Copyright © 2020 Vong Beng. All rights reserved.
//

import SwiftUI

struct ManagePaymentTypes: View {
    @State private var paymentTypes: [String] = UserDefKeys.getPaymentTypes() ?? []
    @State private var newPaymentName: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    func addPaymentType() {
        var unique = true
        for paymentType in paymentTypes {
            if paymentType == newPaymentName {
                unique = false
                break
            }
        }
        
        if unique {
            clearError()
            self.paymentTypes.append(newPaymentName)
            updateUserDefPaymentTypes()
            self.newPaymentName.removeAll()
        } else {
            showErrorMessage("Payment type already exists!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                clearError()
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        paymentTypes.remove(atOffsets: offsets)
        updateUserDefPaymentTypes()
    }
    
    func clearError() {
        showError = false
        errorMessage.removeAll()
    }
    
    func move(from source: IndexSet, to destination: Int) {
        paymentTypes.move(fromOffsets: source, toOffset: destination)
        updateUserDefPaymentTypes()
    }
    
    func showErrorMessage(_ message: String = "") {
        showError = true
        errorMessage = message
    }
    
    func updateUserDefPaymentTypes() {
        UserDefaults.standard.set(paymentTypes, forKey: UserDefKeys.paymentTypesKey)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack(spacing: 10) {
                TextField("New Payment Type", text: $newPaymentName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Create") {
                    addPaymentType()
                }
            }
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            Text("Current Payment Types")
                .font(.title)
                .bold()
            List {
                ForEach(paymentTypes, id: \.self) { paymentType in
                    Text(paymentType)
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
            }
            .navigationBarItems(trailing: EditButton())
            .navigationBarTitle("Manage Payment Types")
        }
        .padding()
    }
}

struct AddPaymentType_Previews: PreviewProvider {
    static var previews: some View {
        ManagePaymentTypes()
    }
}
