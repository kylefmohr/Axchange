//
//  SidebarView.swift
//  Axchange
//
//  Created by Lakr Aream on 2022/7/26.
//

import SwiftUI

#if DEBUG
    private let stubNavigationTarget: some View = Text("Hello World")
        .usePreferredContentSize()
#endif

struct SidebarView: View {
    @ObservedObject var appStatus = AppStatus.shared

    var progressIndicator: some View {
        HStack(spacing: 4) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 18, height: 18)
                .overlay(
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(0.4)
                )
                .frame(width: 18, height: 18)
            Text("Scanning...")
                .font(.system(.headline, design: .rounded))
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }

    var body: some View {
        List {
            NavigationLink {
                WelcomeView()
            } label: {
                Label("Welcome", systemImage: "sun.min.fill")
            }

            Section("Devices") {
                if appStatus.devices.isEmpty {
                    Button {} label: {
                        HStack {
                            Label("No Device", systemImage: "app.dashed")
                            Spacer()
                        }
                        .background(Color.accentColor.opacity(0.0001))
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    ForEach(appStatus.devices) { device in
                        NavigationLink {
                            DeviceFileView(device: device)
                        } label: {
                            Label(device.interfaceName, systemImage: "flipphone")
                        }
                    }
                }
            }
            Section("Misc") {
                Button {
                    Executor.shared.scanForDevices()
                } label: {
                    HStack {
                        Label("Scan", systemImage: "cable.connector.horizontal")
                        Spacer()
                    }
                    .background(Color.accentColor.opacity(0.0001))
                }
                .buttonStyle(PlainButtonStyle())
                Button {
                    Executor.resetADB()
                    AppStatus.shared.devices = []
                } label: {
                    HStack {
                        Label("Reset", systemImage: "drop.triangle")
                        Spacer()
                    }
                    .background(Color.accentColor.opacity(0.0001))
                }
                .buttonStyle(PlainButtonStyle())
            }
            .disabled(appStatus.isScanningDevices)
        }
        .listStyle(SidebarListStyle())
        .overlay(
            progressIndicator
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .bottomLeading
                )
                .padding()
                .opacity(appStatus.isScanningDevices ? 1 : 0)
                .animation(.interactiveSpring(), value: appStatus.isScanningDevices)
        )
    }
}
