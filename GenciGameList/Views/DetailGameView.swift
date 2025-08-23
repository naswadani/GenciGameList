//
//  DetailGameView.swift
//  GenciGameList
//
//  Created by naswakhansa on 24/08/25.
//

import SwiftUI

struct DetailGameView: View {
    var body: some View {
        List {
            LazyVStack(spacing: 10) {
                Image("game")
                    .resizable()
                    .frame(maxWidth: 350, maxHeight: 250)
                    .cornerRadius(10)
                    .scaledToFit()
                    .overlay(alignment: .bottomTrailing, content: {
                        Text("84")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .foregroundStyle(.primary)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.green)
                            )
                            .offset(x: -20, y: -20)
                    })
                
                LazyVStack(spacing: 5) {
                    Text("GTA 5")
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .fontDesign(.default)
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                    LazyHStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.footnote)
                            .foregroundStyle(.yellow)
                        Text("4.5/5")
                            .font(.footnote)
                            .fontDesign(.default)
                            .foregroundStyle(.secondary)
                    }
                    Text("Rockstar Games")
                        .lineLimit(1)
                        .font(.footnote)
                        .fontDesign(.default)
                        .foregroundStyle(.secondary)
                }
            }
            .listRowSeparator(.hidden)
            
            Section("Genre") {
                Text("Action, Adventure, Criminal, Adult")
                    .font(.caption)
                    .foregroundStyle(.primary)
            }
            
            Section("Description") {
                Text("Grand Theft Auto V (GTA V) adalah game aksi-petualangan dunia terbuka yang dikembangkan oleh Rockstar Games. Berlatar di kota fiksi Los Santos dan sekitarnya, pemain mengikuti kisah Michael De Santa, Franklin Clinton, dan Trevor Philips, tiga karakter dengan latar belakang berbeda yang terjerat dalam dunia kejahatan, pencurian besar, dan konflik pribadi.Game ini menghadirkan dunia terbuka yang sangat luas dan detail, memungkinkan pemain untuk menjelajahi kota, pedesaan, hingga lautan, baik dengan berjalan kaki maupun berbagai kendaraan.")
                    .font(.caption)
                    .foregroundStyle(.primary)
            }
            
            Section("Platfrom") {
                Text("PS 5, PS 4, Nintendo Switch, PC")
                    .font(.caption)
                    .foregroundStyle(.primary)
            }
        }
        .listSectionSpacing(0)
    }
}

#Preview {
    DetailGameView()
}
