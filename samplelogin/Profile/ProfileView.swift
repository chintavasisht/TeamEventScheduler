//
//  ProfileView.swift
//  samplelogin
//
//  Created by Vasisht Chinta on 8/1/23.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @AppStorage("uid") var userID: String = ""
    @StateObject private var teamManager = TeamManager()
    @StateObject private var teamData = TeamData()
    @State private var isShowingForm = false
    @State private var newTeamName = ""
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Teams")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top)
                
                HStack{
                    if !teamManager.userTeams.isEmpty {
                        List(teamManager.userTeams, id: \.name) { team in
                            NavigationLink(destination: TeamDetailsView(team: team) ){
                                Text("\(team.name)")
                                    .font(.headline)
                            }
                        }
                    } else {
                        Text("No teams")
                    }
                }
                .onAppear{
                    teamManager.fetchAllTeams()
                }

                Spacer()

                Button(action: {isShowingForm.toggle()}, label: {
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
                        .padding(.horizontal)
                        .sheet(isPresented: $isShowingForm) {
                            // Present the Add Team form as a modal sheet
                            AddTeamForm(isPresented: $isShowingForm, teamName: $newTeamName)
                                .environmentObject(teamData)
                                .environmentObject(teamManager)
                        }
                })
            }
            .navigationBarItems(trailing: Button(action: {
                    do {
                        try Auth.auth().signOut()
                        userID = ""
                    } catch {
                        print("Error signing out: \(error.localizedDescription)")
                    }
                }, label: {
                    Text("Log Out")
                        .foregroundColor(.blue)
                }))
        }
        
    }
    
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView()
        }
    }
}
