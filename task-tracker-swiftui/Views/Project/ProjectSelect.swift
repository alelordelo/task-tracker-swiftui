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


    var body: some View {
        
        NavigationView {
        
                //list with all project user is a mamber of
                List(state.user!.memberOf, id: \.self) { project in
                    
                    //sets the current project
                    Button(action: selectProject) {
                        Text(project.name ?? "No project name")
                    }
                    
                   
                }
                .navigationBarTitle("Projects")

          
            
            

                }
               
 
      

            
      }
    }

func selectProject() {
    
    //what should I do to select project???

}

    
    
    



