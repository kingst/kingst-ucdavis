//
//  TimerView.swift
//  GrandmaGotHitBySomething
//
//  Created by Sam King on 1/19/24.
//

import SwiftUI

struct TimerView: View {
    @Binding var rootViewType: RootViewType
    
    var body: some View {
        VStack {
            VStack {
                Text("08:50:00")
            }
            .frame(maxHeight: .infinity)
            HStack {
                Button {
                    print("press lap")
                } label: {
                    Text("Lap")
                }
                .frame(width: 75, height: 75)
                .background(.gray)
                .foregroundColor(.white)
                .bold()
                .clipShape(Circle())
                Spacer()
                Button {
                    print("start/Stop press")
                } label: {
                    Text("Start")
                }
                .frame(width: 75, height: 75)
                .background(.green.opacity(0.75))
                .foregroundColor(.white)
                .bold()
                .clipShape(Circle())
            }
            List {
                Text("lap1")
                Text("lap1")
            }
            .listStyle(.inset)
            RootSelectionView(rootViewType: $rootViewType)
        }
        .padding()
    }
}

#Preview {
    TimerView(rootViewType: .constant(.timerView))
}
