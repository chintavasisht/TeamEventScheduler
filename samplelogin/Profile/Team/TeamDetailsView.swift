//
//  TeamMembers.swift
//  teamify
//
//  Created by Vasisht Chinta on 7/28/23.
//

import SwiftUI
import FirebaseAuth

struct TeamDetailsView: View {
    let team: Team
    @State public var isShowingInviteForm = false // To show the form to invite new users
    @State private var isOwner = false
    @State private var isShowingSchedule = false
    
    var body: some View {
        VStack {
            List {
                ForEach(team.members, id: \.email) { member in
                    HStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text("\(member.firstName) \(member.lastName)")
                                .font(.headline)
                            Text(member.email)
                                .font(.subheadline)
                        }
                        Spacer()
                    }
                }
            }
            if team.ownerID == Auth.auth().currentUser?.uid {
                Button("Add New player") {
                    isShowingInviteForm.toggle()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                .sheet(isPresented: $isShowingInviteForm) {
                    // Present the Invite Form as a modal sheet
                    // Implement the Invite Form View here
                    // Pass the team data to the Invite Form if needed
                }
            }
            Spacer()
        }
        .navigationTitle("Team Members")
        .navigationBarItems(trailing:
            Button(action: {
                isShowingSchedule = true
            }) {
                Image(systemName: "calendar")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
            }
            .background(
                NavigationLink(destination: ScheduleView(team: team), isActive: $isShowingSchedule) {
                    EmptyView()
                }
            )
        )
    }
}

