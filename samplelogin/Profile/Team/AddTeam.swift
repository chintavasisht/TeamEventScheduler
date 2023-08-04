//
//  AddTeamForm.swift
//  teamstarks
//
//  Created by Vasisht Chinta on 7/24/23.
//

import SwiftUI

struct AddTeamForm: View {
    @Binding var isPresented: Bool
    @Binding var teamName: String
    
    @EnvironmentObject private var teamData: TeamData
    @EnvironmentObject private var teamManager: TeamManager

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Team Details")) {
                    TextField("Team Name", text: $teamName)
                }
                
            Button(action: {
                addNewTeam()
                }) {
                Text("Add Team")
                    .foregroundColor(.black)
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                    )
                }
            }
            .navigationBarTitle("Add Team", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                // Close the form sheet without adding a team
                isPresented = false
            }) {
                Text("Back")
            })
        }
    }

    private func addNewTeam() {
        guard !teamName.isEmpty else { return }
        
        // Call the function to add a new team to Firestore
        TeamManager().addNewTeam(teamName: teamName) { result in
            switch result {
            case .success:
                // Team added successfully, you can handle success here
                print("New team added successfully!")
                // Clear the team name after successful addition
                teamName = ""
            case .failure(let error):
                // Handle the error if adding the team fails
                print("Error adding new team: \(error.localizedDescription)")
            }
            teamManager.fetchAllTeams()
            // Close the Add Team form regardless of success or failure
            isPresented = false
        }
    }
}

