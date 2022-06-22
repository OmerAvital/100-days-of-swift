//
//  ActivityRow.swift
//  Habbit Tracking (Challange 4)
//
//  Created by Omer Avital on 6/5/22.
//

import SwiftUI

struct ActivityRow: View {
    @ObservedObject var activities: Activities
    let activity: Activity
    
    var totalCompleteStr: String { "\(activity.totalCompleted)" }
    let circleRadius = 12.0
    let digitWidth = 6.5
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(activity.name)
                        .font(.headline)
                    
                    ZStack {
                        Capsule()
                            .strokeBorder(activity.totalCompleted > 0 ? .themeSecondary : .clear)
                            .frame(
                                width: circleRadius * 2 + Double(max(totalCompleteStr.count - 2, 0)) * digitWidth,
                                height: circleRadius * 2
                            )
                            .foregroundColor(.clear)
                        Text(totalCompleteStr)
                            .font(.system(size: 10))
                            .monospacedDigit()
                            .foregroundColor(activity.totalCompleted > 0 ? .themeSecondary : .clear)
                    }
                }
                
                Group {
                    if let lastCompletedOn = activity.lastCompletedOn {
                        Text(lastCompletedOn.formatted(date: .long, time: .shortened))
                    } else {
                        Text("Complete it for the first time!")
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            NavigationLink {
                ActivityDetailsView(activities: activities, activity: activity)
            } label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.themeSecondary)
            }
            .padding(.trailing, 5)
            
            Button {
                activities.complete(activity)
            } label: {
                Image(systemName: "checkmark")
                    .foregroundColor(.themePrimary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.background)
        .cornerRadius(15)
        .shadow(color: .themePrimary.opacity(0.125), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}
	
struct ActivityRow_Previews: PreviewProvider {
    static var activity: Activity {
        var act = Activity.example
        act.totalCompleted = 0
        act.lastCompletedOn = nil
        return act
    }
    
    static var previews: some View {
        ActivityRow(
            activities: Activities(),
            activity: activity
        )
    }
}
