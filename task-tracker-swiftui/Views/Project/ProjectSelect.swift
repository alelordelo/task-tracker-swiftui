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

    @State var image: Data = .init(count:0)


    var body: some View {

        NavigationView {

                //list with all project user is a mamber of
                List(state.user!.memberOf, id: \.self) { project in

                    //sets the current project
                    NavigationLink(destination: ProjectDetail(project: project)) {
                        
                        HStack {
                            
                      
                        Text(project.name ?? "No project name")
                        
                        Image(uiImage: UIImage(data: project.profileImage ?? self.image) ?? UIImage())
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                            
                        }

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


    
    
    



