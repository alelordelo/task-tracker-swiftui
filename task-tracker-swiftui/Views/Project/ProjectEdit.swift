//
//  ProjectEdit.swift
//  task-tracker-swiftui
//
//  Created by Alexandre Lordelo on 2021-01-11.
//

import SwiftUI
import RealmSwift

struct ProjectEdit: View {
    
  // let realm: Realm
    
    var project: Project

    @EnvironmentObject var state: AppState
    @Environment(\.presentationMode) var presentationMode


    @State var name = ""
    
    var body: some View {
        
        NavigationView {
        
        Form {
            
        TextField("Name", text: $name)

         }
        
        .toolbar {

            //update button
            ToolbarItem(placement: .confirmationAction) {
                Button(action: {
                    updateProject(updatedProject: project)
                }) {
                    Text("Done")
                    .foregroundColor(.blue)
                }

            }

            //cancel button
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                         self.presentationMode.wrappedValue.dismiss()
                      }) {
                        Text("Cancel")
                      }

            }
        }
            
        .navigationBarTitle(project.name ?? "Workplace name")

        }
        .navigationViewStyle(StackNavigationViewStyle())
        
 

        
        
    }
    
    
    
//    func updateWorkplace(updatedWorkplace: Workplace) {
//      state.error = nil
//      state.shouldIndicateActivity = true
//
//      do {
//        try state.realmObject!.write {
//            workplace.name = name
//        }
//        state.shouldIndicateActivity = false
//        self.presentationMode.wrappedValue.dismiss()
//
//      } catch {
//        state.error = "Unable to open Realm write transaction"
//      }
//    }
    


    
    //update edited workspace to Realm

    func updateProject(updatedProject: Project) {

        state.error = nil
       // state.shouldIndicateActivity = true

        let realmConfig = app.currentUser?.configuration(partitionValue: project.partition!)

        guard var config = realmConfig else {
            state.error = "Internal error - cannot get Realm config"
           // state.shouldIndicateActivity = false
            return
        }

        config.objectTypes = [Project.self]

        Realm.asyncOpen(configuration: config) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.state.error = "Couldn't open realm: \(error)"
                //    state.shouldIndicateActivity = false
                }
                return
            case .success(let realm):

                do {
                    try state.realmObject!.write {
                        
                        project.name = name

                    //   state.shouldIndicateActivity = false
                        self.presentationMode.wrappedValue.dismiss()
                    }
                } catch {
                    state.error = "Unable to open Realm write transaction"
                }
            }
        }
    }

}

//struct ProjectEdit_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectEdit()
//    }
//}
