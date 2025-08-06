//
//  SettingsViewModel.swift
//  NewsWorldwide
//

import SwiftUI


class SettingsViewModel: ObservableObject {
    @AppStorage("isDarkMode") private var isDarkModeStorage: Bool = false
    
    @Published var isDarkMode: Bool
        
        init() {
            let storedValue = UserDefaults.standard.bool(forKey: "isDarkMode")
            self.isDarkMode = storedValue
        }
        
        /// Update appearance in app based on light/dark mode
        func updateAppearance() {
            isDarkModeStorage = isDarkMode
            
            let newStyle: UIUserInterfaceStyle = isDarkMode ? .dark : .light
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                for window in windowScene.windows {
                    window.overrideUserInterfaceStyle = newStyle
                }
            }
        }
    }
