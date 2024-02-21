//
//  ContentView.swift
//  CardScanThreads
//
//  Created by Sam King on 2/12/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var machineLearning = MachineLearning()
    @State var turboMode = true
    
    var body: some View {
        VStack {
            Image("sams_bofa")
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 375/2, alignment: .center)
                .clipped()
            Text("Apple OCR result")
                .bold()
            Text(machineLearning.appleOcrResult)
            Spacer().frame(height: 24)
            Text("DD OCR result")
                .bold()
            Text(machineLearning.ddOcrResult)
            Spacer().frame(height: 24)
            Text("Final result")
                .bold()
            Text(machineLearning.finalResult)
            Spacer()
            Toggle("Turbo mode", isOn: $turboMode)
            Button {
                Task {
                    await machineLearning.extractCreditCardNumber()
                }
            } label: {
                Text("Run OCR")
                    .frame(maxWidth: .infinity)
                    .bold()
            }
            .buttonStyle(.borderedProminent)
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
