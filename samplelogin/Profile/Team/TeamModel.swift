//
//  TeamModel.swift
//  teamstarks
//
//  Created by Vasisht Chinta on 7/23/23.
//

import FirebaseFirestore

class TeamData: ObservableObject {
    @Published var teamID: String = ""
    @Published var teamName: String = ""
}

struct Member {
    let firstName: String
    let lastName: String
    let email: String
    let owner: Bool = false
    // Add more properties if needed (e.g., role, contact information, etc.)
}

struct Team {
    let teamID: String // You can use this ID to uniquely identify teams
    let name: String
    let ownerID: String
    let members: [Member]
    // Add more properties for team members, match schedule, etc.
    func asDictionary() throws -> [String: Any] {
            // Define the keys for the dictionary (you can adjust these based on your team model)
            let keys: [String] = ["teamID", "name", "ownerID", "members"]

            // Convert the properties of the Team object to a dictionary
            var teamData: [String: Any] = [:]
            let mirror = Mirror(reflecting: self)

            for child in mirror.children {
                if let label = child.label, keys.contains(label) {
                    teamData[label] = child.value
                }
            }

            // Check if all required keys are present in the dictionary
            guard Set(keys) == Set(teamData.keys) else {
                throw NSError(domain: "TeamError", code: 100, userInfo: [NSLocalizedDescriptionKey: "Invalid Team object"])
            }
        
//         Convert the members array to an array of dictionaries
                let membersData = members.map { member -> [String: Any] in
                    return [
                        "firstName": member.firstName,
                        "lastName": member.lastName,
                        "email": member.email
                        // Add more properties as needed (e.g., "role", "contact", etc.)
                    ]
                }

                teamData["members"] = membersData

            return teamData
        }
}
