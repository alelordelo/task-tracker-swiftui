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
        

                List(state.user!.memberOf, id: \.self) { project in
                    Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                        Text(project.name ?? "No project name")
                    }
                    
                   
                }
                .navigationBarTitle("Projects")

          
            
            

                }
               
 
      

            
      }
    }
    
    
    



