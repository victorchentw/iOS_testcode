//
//  ContentView.swift
//  demoapp_ios
//
//  Created by victor.chen on 2025/10/28.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedItem: SidebarItem? = .itemA
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarView(selectedItem: $selectedItem)
        } detail: {
            DetailView(selectedItem: selectedItem)
        }
    }
}

enum SidebarItem: String, CaseIterable, Identifiable {
    case itemA = "ItemA"
    case itemB = "ItemB"
    case itemC = "ItemC"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .itemA: return "a.circle"
        case .itemB: return "b.circle"
        case .itemC: return "c.circle"
        }
    }
}

struct SidebarView: View {
    @Binding var selectedItem: SidebarItem?
    @State private var showingMenu = false
    
    var body: some View {
        List(SidebarItem.allCases, selection: $selectedItem) { item in
            NavigationLink(value: item) {
                Label(item.rawValue, systemImage: item.icon)
            }
            .tag(item)
        }
        .navigationTitle("Demo App")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Settings") {
                        // Settings action
                    }
                    Button("Help") {
                        // Help action
                    }
                    Button("About") {
                        // About action
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Button("Action 1") {
                        // Toolbar action 1
                    }
                    Spacer()
                    Button("Action 2") {
                        // Toolbar action 2
                    }
                }
            }
        }
    }
}

struct DetailView: View {
    let selectedItem: SidebarItem?
    
    var body: some View {
        NavigationStack {
            Group {
                if let selectedItem = selectedItem {
                    DetailContentView(item: selectedItem)
                } else {
                    Text("Select an item from the sidebar")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailContentView: View {
    let item: SidebarItem
    
    var detailItems: [String] {
        switch item {
        case .itemA:
            return ["Detail item A1", "Detail item A2", "Detail item A3", "Detail item A4"]
        case .itemB:
            return ["Detail item B1", "Detail item B2", "Detail item B3", "Detail item B4"]
        case .itemC:
            return ["Detail item C1", "Detail item C2", "Detail item C3", "Detail item C4"]
        }
    }
    
    var body: some View {
        List(detailItems, id: \.self) { detailItem in
            NavigationLink(destination: DetailItemView(item: detailItem)) {
                Text(detailItem)
            }
        }
        .navigationTitle("Detail Page\(item.rawValue.last!)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Edit") {
                        // Edit action
                    }
                    Button("Share") {
                        // Share action
                    }
                    Button("Delete") {
                        // Delete action
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
    }
}

struct DetailItemView: View {
    let item: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text")
                .font(.system(size: 60))
                .foregroundStyle(.blue)
            
            Text(item)
                .font(.title)
                .fontWeight(.semibold)
            
            Text("This is the detail view for \(item)")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
        }
        .navigationTitle(item)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    // Edit action
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
