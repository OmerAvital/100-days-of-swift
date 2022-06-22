//
//  MissionView.swift
//  Moonshot
//
//  Created by Omer Avital on 6/4/22.
//

import SwiftUI

struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    var crew = [CrewMember]()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Image(decorative: mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.6)
                        .padding(.top)
                    
                    if let formattedLaunchDate = mission.formattedLaunchDate {
                        VStack {
                            Text("Launch date:")
                                .font(.headline)
                            Text(formattedLaunchDate)
                                .font(.subheadline)
                        }
                        .accessibilityElement()
                        .accessibilityLabel("Launch date: \(formattedLaunchDate)")
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Mission Highlights")
                            .font(.title.bold())
                            .padding(.bottom, 5)
                        
                        Text(mission.description)
                        
                        Text("Crew")
                            .font(.title.bold())
                            .padding(.top)
                            .padding(.bottom, 5)
                    }
                    .padding([.horizontal, .top])
                    
                    AstronautsList(crew: crew)
                }
                .padding(.bottom)
            }
            .navigationTitle(mission.diplayName)
            .navigationBarTitleDisplayMode(.inline)
            .background(.darkBackground)
        }
    }
    
    init(mission: Mission, astronauts: [String: Astronaut]) {
        self.mission = mission
        
        self.crew = mission.crew.map { member in
            if let astronaut = astronauts[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(member.name)")
            }
        }
    }
}

struct AstronautsList: View {
    let crew: [MissionView.CrewMember]
    
    var body: some View {
        ScrollView(.horizontal,  showsIndicators: false) {
            HStack {
                ForEach(crew, id: \.role) { crewMember in
                    NavigationLink {
                        AstronautView(astronaut: crewMember.astronaut)
                    } label: {
                        ZStack {
                            if crewMember.role == "Commander" {
                                Rectangle()
                                    .foregroundColor(.lightBackground)
                                    .cornerRadius(10)
                            }
                            
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 104, height: 72)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .strokeBorder(.white, lineWidth: 1)
                                    )
                                
                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .foregroundColor(.white)
                                        .font(.headline)
                                    Text(crewMember.role)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }

    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        MissionView(mission: missions[1], astronauts: astronauts)
            .preferredColorScheme(.dark)
    }
}
