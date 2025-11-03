//
//  ContentView.swift
//  demoapp_ios
//
//  Created by victor.chen on 2025/10/28.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedItem: SidebarItem?
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn //all
    @State private var refreshID = UUID()
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarView(selectedItem: $selectedItem)
                .id(refreshID)
        } detail: {
            DetailView(selectedItem: selectedItem)
        }
        //floating effect
         .navigationSplitViewStyle(.prominentDetail)
        //fixed sidebar on ios18 regular width screen , but enable will caused tvOS only display sidebar or detail one page on the scren
         .navigationSplitViewStyle(.balanced)
        .task {
            // 使用 task 來確保在視圖完全載入後再設置狀態
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
            refreshID = UUID()
        }
        .onAppear {
            // 啟動時確保先顯示sidebar
            if selectedItem == nil {
                columnVisibility = .doubleColumn
            }
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
    @State private var isToolbarReady = false
    @State private var showingActionSheet = false
    
    var body: some View {
        List(SidebarItem.allCases, selection: $selectedItem) { item in
            NavigationLink(value: item) {
                Label(item.rawValue, systemImage: item.icon)
            }
            .tag(item)
        }
        #if !os(tvOS)
        .navigationTitle("Demo App")
        .navigationBarTitleDisplayMode(.large)
        .listStyle(.sidebar)
        #else
        .navigationTitle("Demo App")
        #endif
        .toolbar {
            if isToolbarReady {
                ToolbarItem(placement: .navigationBarTrailing) {
                    #if os(tvOS)
                    Button {
                        showingActionSheet = true
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    .confirmationDialog("Options", isPresented: $showingActionSheet) {
                        Button("Settings") {
                            print("Settings tapped")
                        }
                        Button("Help") {
                            print("Help tapped")
                        }
                        Button("About") {
                            print("About tapped")
                        }
                        Button("Cancel", role: .cancel) { }
                    }
                    #else
                    Menu {
                        Button("Settings") {
                            print("Settings tapped")
                        }
                        Button("Help") {
                            print("Help tapped")
                        }
                        Button("About") {
                            print("About tapped")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    #endif
                }
                
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button("Action 1") {
                            print("Toolbar Action 1 tapped")
                        }
                        Spacer()
                        Button("Action 2") {
                            print("Toolbar Action 2 tapped")
                        }
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isToolbarReady = true
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
        #if !os(tvOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct DetailContentView: View {
    let item: SidebarItem
    @State private var showingDetailActionSheet = false
    
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
            ToolbarItem(placement: .primaryAction) {
                #if os(tvOS)
                Button {
                    showingDetailActionSheet = true
                } label: {
                    Image(systemName: "ellipsis")
                }
                .confirmationDialog("Actions", isPresented: $showingDetailActionSheet) {
                    Button("Edit") {
                        print("Edit tapped")
                    }
                    Button("Share") {
                        print("Share tapped")
                    }
                    Button("Delete") {
                        print("Delete tapped")
                    }
                    Button("Cancel", role: .cancel) { }
                }
                #else
                Menu {              //limited tvOS Menu support, only can be opended when sidbar is floating
                    Button("Edit") {
                        print("Edit tapped")
                    }
                    Button("Share") {
                        print("Share tapped")
                    }
                    Button("Delete") {
                        print("Delete tapped")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
                .menuStyle(.borderlessButton)
                #endif
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
        #if !os(tvOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") {
                    print("Edit button tapped")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
