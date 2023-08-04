import SwiftUI
import FirebaseAuth
import FirebaseFirestore

enum AuthError: Error {
    case notAuthenticated
}

class TeamManager: ObservableObject {
    @Published var userTeams: [Team] = []

    func fetchAllTeams() {
        userTeams.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("teams")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let authenticatedUserEmail = Auth.auth().currentUser?.email else {
                    return // Exit if the user is not authenticated
                }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    if  let teamdata = document.data() as? [String: Any] {
                        if let membersData = teamdata["members"] as? [[String: Any]],
                           let ownerID = teamdata["ownerID"] as? String,
                           let teamName = teamdata["name"] as? String,
                           let teamID = teamdata["teamID"] as? String {
                            
                            var members: [Member] = []
                            for memberData in membersData {
                                if let firstName = memberData["firstName"] as? String,
                                   let lastName = memberData["lastName"] as? String,
                                   let email = memberData["email"] as? String {
                                    let member = Member(firstName: firstName, lastName: lastName, email: email)
                                    members.append(member)
                                }
                            }
                            if members.contains(where: { $0.email == authenticatedUserEmail }) {
                                let team = Team(teamID: teamID, name: teamName, ownerID: ownerID, members: members)
                                DispatchQueue.main.async {
                                    self.userTeams.append(team)
                                    self.userTeams.sort { $0.name < $1.name }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func addNewTeam(teamName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
            guard let authenticatedUserID = Auth.auth().currentUser?.uid else {
                completion(.failure(AuthError.notAuthenticated))
                return
            }
        
            var teamData: [String: Any] = [
                "name": teamName,
               "ownerID": authenticatedUserID, // Set the ownerID to the authenticated user's ID
               "members": [[
                   "firstName": Auth.auth().currentUser?.displayName ?? "",
                   "lastName": "",
                   "email": Auth.auth().currentUser?.email ?? "",
                   "isOwner": true
               ] as [String : Any]]
            ]

            // Create a new team document in Firestore
            let db = Firestore.firestore()
            
            db.collection("teams").document(teamName).setData(teamData)
            let teamRef = db.collection("teams").document(teamName)
            
//            // Create a new team document with the owner as the first member
//            teamData = [
//                "name": teamName,
//                "ownerID": authenticatedUserID, // Set the ownerID to the authenticated user's ID
//                "teamID": db.document(teamName).documentID,
//                "members": [[
//                    "firstName": Auth.auth().currentUser?.displayName ?? "",
//                    "lastName": "",
//                    "email": Auth.auth().currentUser?.email ?? "",
//                    "isOwner": true
//                ] as [String : Any]]
//            ]
            
            // Add the new team document to Firestore
        db.collection("teams").document(teamName).setData(["teamID" : teamRef.documentID],merge: true) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    
    func saveTeamToFirestore(team: Team) {
        let db = Firestore.firestore()
        let teamsCollection = db.collection("teams")

        do {
            // Convert the team object to a dictionary
            let teamData = try team.asDictionary()
            
            // Save the team data to Firestore with the teamID as the document ID
            teamsCollection.document(team.teamID).setData(teamData) { error in
                if let error = error {
                    print("Error saving team data: \(error.localizedDescription)")
                } else {
                    print("Team data saved successfully!")
                }
            }
        } catch {
            print("Error converting team to dictionary: \(error.localizedDescription)")
        }
    }
}
