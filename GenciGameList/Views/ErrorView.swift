//
//  ErrorView.swift
//  GenciGameList
//
//  Created by naswakhansa on 25/08/25.
//


import SwiftUI

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 45, height: 45)
                .foregroundColor(.red)
            
            Text("Error")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Button(action: retryAction) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Coba Lagi")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal, 32)
            }
            Spacer()
        }
        .padding()
    }
}
