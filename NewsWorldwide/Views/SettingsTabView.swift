//
//  SettingsTabView.swift
//  NewsWorldwide
//

import SwiftUI

struct SettingsTabView: View {
    @StateObject private var settingsViewModel = SettingsViewModel()
    @State private var apiKey: String = ""
    @State private var isKeyVisible: Bool = false
    @State private var isSavedKeyVisible: Bool = false
    @State private var savedApiKey: String? = nil

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("API Key")) {
                    HStack {
                        if isKeyVisible {
                            TextField("Enter your API key", text: $apiKey, onCommit: saveAPIKey)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            SecureField("Enter your API key", text: $apiKey, onCommit: saveAPIKey)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        Button(action: {
                            isKeyVisible.toggle()
                        }) {
                            Image(systemName: isKeyVisible ? "eye.slash" : "eye")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.top, 4)
                    
                    HStack {
                        Button("Save") {
                            saveAPIKey()
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Spacer()
                        
                        Button("Delete") {
                            deleteAPIKey()
                        }
                        .foregroundColor(.red)
                    }
                    .padding(.bottom, 4)
                    
                    if let savedApiKey = savedApiKey {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Saved API Key:")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Button(action: {
                                    isSavedKeyVisible.toggle()
                                }) {
                                    Image(systemName: isSavedKeyVisible ? "eye.slash" : "eye")
                                        .foregroundColor(.blue)
                                }
                            }
                            
                            if isSavedKeyVisible {
                                Text(savedApiKey)
                                    .font(.body)
                            } else {
                                Text("••••••••••••••••••")
                                    .font(.body)
                            }
                        }
                        .padding(.top, 4)
                    }
                }
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $settingsViewModel.isDarkMode) {
                        Label("Dark Mode", systemImage: "moon.fill")
                    }
                    .onChange(of: settingsViewModel.isDarkMode) {
                        settingsViewModel.updateAppearance()
                    }
                }
            }
            .onAppear {
                loadAPIKey()
            }
            .navigationTitle("Settings")
        }
    }
    
    /// Keychain Handlers
    private func saveAPIKey() {
        guard !apiKey.isEmpty else { return }
        KeychainHelper.shared.save(key: "APIKey", value: apiKey)
        savedApiKey = apiKey
        apiKey = ""
    }
    
    private func loadAPIKey() {
        savedApiKey = KeychainHelper.shared.retrieve(key: "APIKey")
    }
    
    private func deleteAPIKey() {
        KeychainHelper.shared.delete(key: "APIKey")
        savedApiKey = nil
    }
}

