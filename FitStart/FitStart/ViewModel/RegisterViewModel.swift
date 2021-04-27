//
//  RegisterViewModel.swift
//  FitStart
//
//  Created by Minglan  on 11/30/20.
//

import SwiftUI
import Firebase

class RegisterViewModel : ObservableObject, Identifiable {
    @Published var name = ""
    @Published var bio = ""
    @Published var interest = ""
    @Published var level = 1
    @Published var xp = 0
    
    @Published var image_Data = Data(count: 0)
    @Published var picker = false
    
    let ref = Firestore.firestore()
    
    @Published var isLoading = false
    @AppStorage("current_status") var status = false
    
    // common init
    init() {
        
    }
    
    //initializer for leaderboard collection
    init(name: String, xp: Int) {
        self.name = name
        self.xp = xp
        self.level = xp2Level(xp: xp)
    }
    
    func register() {
        //sending user data to Firebase
        let uid = Auth.auth().currentUser!.uid
        
        isLoading = true
        UploadImage(imageData: image_Data, path: "profile_Photos") { (url) in
            self.ref.collection("Users").document(uid).setData([
                            "uid": uid,
                            "imageurl": url,
                            "username": self.name,
                            "bio": self.bio,
                            "interest" : self.interest,
                            "level" : self.level,
                            "xp" : self.xp,
                            "dateCreated": Date()
                            
                        ]) { (err) in
                         
                            if err != nil{
                                self.isLoading = false
                                return
                            }
                            self.isLoading = false
                            // success means settings status as true...
                            self.status = true
                        }
            
        }
    }
    
    func xp2Level(xp:Int) -> Int {
        if xp == 0 {
            return 1
        }
        else if xp < 9500 {
            return xp / 500
        }
        else if xp < 29500 {
            return (xp - 9500) / 1000
        }
        else {
            return (xp - 29500) / 2000
        }
    }
}
