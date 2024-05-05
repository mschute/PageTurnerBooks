//
//  BookTrackerViewModel.swift
//  PageTurnerBooks
//
//  Created by Staff on 04/05/2024.
//

import Foundation


class BookTrackerViewModel: ObservableObject {
    @Published var tracker: BookTrackerModel
    
    init(tracker: BookTrackerModel){
        self.tracker = tracker
    }
    
    func saveProgress(){
        //Need to add logic to save the data in the model
    }
    
    func stopTracking(){
        //Need to add logic to delete the tracker
    }
    
    //function for calculating book progress?
    
    
}
