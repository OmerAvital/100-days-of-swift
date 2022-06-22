//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Omer Avital on 6/14/22.
//

import CodeScanner
import SwiftUI
import UserNotifications

struct ProspectsView: View {
    enum FilterType: Codable {
        case none, contacted, uncontacted
    }
    enum SortingOptions: String, Codable, CaseIterable {
        case mostRecent, oldest, nameAscending, nameDescending
    }
    
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    @AppStorage("sortBy-none") private var sortByNone = SortingOptions.mostRecent
    @AppStorage("sortBy-contacted") private var sortByContacted = SortingOptions.mostRecent
    @AppStorage("sortBy-uncontacted") private var sortByUncontacted = SortingOptions.mostRecent
    let filter: FilterType
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(prospect.name)
                            
                            if filter == .none {
                                if prospect.isContacted {
                                    Image(systemName: "checkmark.circle")
                                        .foregroundColor(.green)
                                } else {
                                    Image(systemName: "questionmark.diamond")
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                        .font(.headline)
                        
                        Text(prospect.emailAddress)
                            .foregroundColor(.secondary)
                    }
                    .swipeActions {
                        if prospect.isContacted {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.blue)
                        } else {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                            Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)
                            
                            Button {
                                addNotification(for: prospect)
                            } label: {
                                Label("Remind me", systemImage: "bell")
                            }
                            .tint(.orange)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Text("Sort by: ")

                        Picker("Sort by", selection: sortingSelection) {
                            ForEach(SortingOptions.allCases, id: \.self) { option in
                                Text(option.rawValue.titleCased())
                                    .tag(option)
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingScanner = true
                    } label: {
                        Label("Scan", systemImage: "qrcode.viewfinder")
                    }
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
            }
        }
    }
    
    var sortingSelection: Binding<SortingOptions> {
        switch filter {
        case .none:
            return $sortByNone
        case .contacted:
            return $sortByContacted
        case .uncontacted:
            return $sortByUncontacted
        }
    }
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted People"
        case .uncontacted:
            return "Uncontacted People"
        }
    }
    
    var filteredProspects: [Prospect] {
        var people = [Prospect]()
        
        switch filter {
        case .none:
            people = prospects.people
        case .contacted:
            people = prospects.people.filter { $0.isContacted }
        case .uncontacted:
            people = prospects.people.filter { !$0.isContacted }
        }
        
        switch sortingSelection.wrappedValue {
        case .mostRecent:
            people.reverse()
        case .oldest:
            break
        case .nameAscending:
            people.sort { $0.name > $1.name }
        case .nameDescending:
            people.sort { $0.name < $1.name }
        }
        
        return people
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            prospects.add(person)
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.body = prospect.emailAddress
            content.sound = .default
            
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
                    } else {
                        print("D'oh!")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}
