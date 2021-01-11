//
//  ProjectSelect.swift
//  task-tracker-swiftui
//
//  Created by Alexandre Lordelo on 2021-01-06.
//

import SwiftUI
import RealmSwift

struct ProjectSelect: View {

    @EnvironmentObject var state: AppState
    
    @State var showingSheet = false


    var body: some View {

        NavigationView {

                //list with all project user is a mamber of
                List(state.user!.memberOf, id: \.self) { project in

                    //sets the current project
                    NavigationLink(destination: ProjectDetail()) {
                        Text(project.name ?? "No project name")

                    }
                    
                    }

                }
                .navigationBarTitle("Projects")
            
                //Manage team button
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button(action: { self.showingSheet = true }) {
                            ManageTeamButton()
                        }
                    }
                }
                //show team modal
                .sheet(isPresented: $showingSheet) {
                    TeamsView()
                }


                }

      }
    


func selectProject(project: Project, state: AppState) {
   state.updateRealmInstance(project)
 }


    
    
    



