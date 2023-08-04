//
//  ScheduleView.swift
//  samplelogin
//
//  Created by Vasisht Chinta on 8/2/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct Schedule {
    var id = UUID()
    var title: String
    var opponent: String
    var date: String
    var goingPlayers: [Member]
    var notGoingPlayers: [Member]
    var maybeGoingPlayers: [Member]
    var location: String
    // Add other properties as needed
}

enum RSVPStatus: String {
    case going = "Going"
    case notGoing = "Not Going"
    case maybeGoing = "Maybe Going"
}

struct ScheduleView: View {
    let team: Team // Assuming Team is the model for the team data
    @State private var isShowingAddScheduleDialog = false
    @State private var schedules: [Schedule] = []
    @State private var matchName = ""
    @State private var opponent = ""
    @State private var location = ""
    @State private var dateTime = Date()
    // Assuming you have an array of schedules for the team
    //    let schedules: [Schedule] = [
    //        Schedule(title: "Match 1", date: Date(), opponentName: "Opponent 1"),
    //        Schedule(title: "Match 2", date: Date().addingTimeInterval(86400), opponentName: "Opponent 2"), // Adding one day
    //        // Add more schedules here
    //    ]
    
    var body: some View {
        List {
            //            ForEach(schedules) { schedule in
            //                Spacer()
            //                ScheduleCard(schedule: schedule)
            //            }
        }
        .navigationTitle("Schedule")
        .navigationBarItems(trailing:
                                Button(action: {
            isShowingAddScheduleDialog.toggle()
        }, label: {
            Image(systemName: "plus")
                .sheet(isPresented: $isShowingAddScheduleDialog) {
                    Text("Add a schedule")
                        .font(.title2)
                        .foregroundColor(.white)
                    Divider()
                    VStack(alignment: .leading) {
                        TextField("Match Name", text: $matchName)
                            .padding()
                            .multilineTextAlignment(.leading)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.white)
                            )
                        TextField("Opponent", text: $opponent)
                            .padding()
                            .multilineTextAlignment(.leading)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.white)
                            )
                        TextField("Location", text: $location)
                            .padding()
                            .multilineTextAlignment(.leading)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.white)
                            )
                        DatePicker("Select date & time", selection: $dateTime, displayedComponents: [.date, .hourAndMinute])
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Divider()
                    
                    VStack {
                        Spacer()
                        Button("Cancel") {
                            isShowingAddScheduleDialog.toggle()
                        }
                        .padding()
                        Button("Add Schedule") {
                            addSchedule()
                        }
                        .padding()
                    }
                    .padding(.vertical)
                }
                .padding()
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()
        })
        )
    }
    
    private func addSchedule() {
        let db = Firestore.firestore()
        let teamRef = db.collection("teams").document(team.teamID)
        
        teamRef.getDocument { documentSnapshot, error in
            if let error = error {
                print("Error fetching team document: \(error.localizedDescription)")
                           return
            }
            guard let document = documentSnapshot, document.exists,
                let teamData = document.data(),
                let playersData = teamData["members"] as? [[String: Any]] else {
                   print("Invalid team document or no members data found.")
                   return
               }
            var notGoingPlayers: [Member] = []
                for playerData in playersData {
                    guard let firstName = playerData["firstName"] as? String,
                          let lastName = playerData["lastName"] as? String,
                          let email = playerData["email"] as? String else {
                        continue
                    }
                    notGoingPlayers.append(Member(firstName: firstName, lastName: lastName, email: email))
                }
            var goingPlayers: [Member] = []
            var maybeGoingPlayers: [Member] = []
            var newSchedule = Schedule(
                title: matchName,
                opponent: opponent,
                date: dateTime.description,
                goingPlayers: goingPlayers,
                notGoingPlayers: notGoingPlayers,
                maybeGoingPlayers: maybeGoingPlayers,
                location: location
            )
                // Convert the schedule to a dictionary
                let data: [String: Any] = [
                    "title": newSchedule.title,
                    "opponent": newSchedule.opponent,
                    "date": newSchedule.date,
                    "goingPlayers": newSchedule.goingPlayers,
                    "notGoingPlayers": notGoingPlayers,
                    "maybeGoingPlayers": newSchedule.maybeGoingPlayers,
                    "location": newSchedule.location
                ]
                
                // Add the schedule to the 'schedules' subcollection in the team document
                teamRef.collection("schedules").document(matchName).setData(data)
//                { error in
//                    if let error = error {
//                        print("Error adding schedule: \(error.localizedDescription)")
//                    } else {
//                        print("Schedule added successfully")
//                        isShowingAddScheduleDialog.toggle() // Close the dialog after adding the schedule
//                    }
//                }
            
        }
    }
    
    private func openMaps() {
            guard let url = URL(string: "http://maps.apple.com/?address=\(location)") else {
                print("Invalid URL")
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    
    struct ScheduleCard: View {
        let schedule: Schedule
        @State private var isShowingRSVPDialog = false
        @State private var rsvpSelection: RSVPStatus = .going
        
        var body: some View {
            VStack {
                Text(schedule.title)
                    .font(.headline)
                Text("vs \(schedule.opponent)")
                    .font(.headline)
                //            Text("\(schedule.date, formatter: dateFormatter)")
                //                .font(.subheadline)
            }
            .padding()
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal)
            .onTapGesture {
                isShowingRSVPDialog = true
            }
        }
        
        private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter
        }()
    }
}
