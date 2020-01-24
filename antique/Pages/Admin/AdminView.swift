//
//  ReportsView.swift
//  antique
//
//  Created by Vong Beng on 30/12/19.
//  Copyright © 2019 Vong Beng. All rights reserved.
//
import LocalAuthentication
import SwiftUI

struct AdminView: View {
    @State var isUnlocked = false
    
    var body: some View {
        VStack(alignment: .center) {
            if self.isUnlocked {
                NavigationView {
                    List {
                        NavigationLink(destination: ReportDay()) {
                            Text("Reports")
                        }
//                        NavigationLink(destination: ReportMonth()) {
//                            Text("Month")
//                        }
                        NavigationLink(destination: AddItem()) {
                            Text("Add Item")
                        }
                        NavigationLink(destination: ViewItems()){
                            Text("Edit/Delete Item")
                        }
                    }
                    .navigationBarTitle("Admin Controls")
                    .navigationViewStyle(DoubleColumnNavigationViewStyle())
                }
            } else {
                Text("Locked")
            }
        }
        .onAppear(perform: authenticate)
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "Accessing Confidential Information"

            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        self.isUnlocked = false
                    }
                }
            }
        } else {
            self.isUnlocked = false
        }
    }
}

struct AdminView_Previews: PreviewProvider {
    static let orders = Orders()
    static var previews: some View {
        AdminView()
    }
}
