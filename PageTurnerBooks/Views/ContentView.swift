//
//  ContentView.swift
//  BarCodeScanner
//
//  Created by Hogg Benjamin on 03/05/2024.
//

//
//  ContentView.swift
//  BarCodeScanner
//
//  Created by Hogg Benjamin on 03/05/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        
        if authViewModel.isSignedIn {
            NavBar()
        } else {
            LandingPageView()
        }
    }
}
