//
//  ProspectsView.swift
//  HotProspects
//
//  Created by austin townsend on 7/8/25.
//

import SwiftData
import SwiftUI
import CodeScanner
import AVFoundation
import UserNotifications


struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            "Everyone"
        case .contacted:
            "Contacted people"
        case .uncontacted:
            "Uncontacted people"
        }
    }
    
    @Query(sort: \Prospect.name) var prospects: [Prospect]
    @Environment(\.modelContext) var modelContext
    
    init(filter: FilterType) {
        self.filter = filter
        
        if filter != .none {
            let showContactedOnly = filter == .contacted
            
            _prospects = Query(
                filter: #Predicate {
                    $0.isContacted == showContactedOnly
                },
                sort: [SortDescriptor(\Prospect.name)]
            )
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect(name: details[0], emailAddress: details[1], isContacted: false)
            
            modelContext.insert(person)
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    @State private var isShowingScanner = false
    @State private var selectedProspects = Set<Prospect>()
    
    func delete() {
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    
                    if success {
                        addRequest()
                    } else if let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                List(prospects, selection: $selectedProspects) { prospect in
                    VStack(alignment: .leading) {
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.emailAddress)
                            .foregroundStyle(.secondary)
                    }
                    .swipeActions {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            modelContext.delete(prospect)
                        }
                        
                        if prospect.isContacted {
                            Button("Mark Uncotacted", systemImage: "person.crop.circle.badge.xmark") {
                                prospect.isContacted.toggle()
                            }
                            .tint(.blue)
                        } else {
                            Button("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark") {
                                prospect.isContacted.toggle()
                            }
                            .tint(.green)
                        }
                        
                        Button("Remind Me", systemImage: "bell") {
                            addNotification(for: prospect)
                        }
                        .tint(.orange)
                    }
                    .tag(prospect)
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                if selectedProspects.isEmpty == false {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Delete Selected", action: delete)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Scan", systemImage: "qrcode.viewfinder") {
                        isShowingScanner = true
                    }
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
            }
        }
    }
}

#Preview {
    ProspectsView(filter: .none)
        .modelContainer(for: Prospect.self, inMemory: true)
}
