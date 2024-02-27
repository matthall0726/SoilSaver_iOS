//
//  CreateAccount.swift
//  SoilSaver
//
//  Created by Matt Hall on 2/13/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore


func createFirebaseAccount(email: String, password: String, completion: @escaping (Int) -> Void) {
    var boolean = -1
    print("Creating firebase account")
    Auth.auth().createUser(withEmail: email, password: password) {
        authResult, error in
    
        if error != nil {
            boolean = 0
            print(error!.localizedDescription)
        } else {
            completion(boolean)
        }
    }
    
}
func createUserDocumentTest () {
    let db = Firestore.firestore()
    db.collection("users").document("matt.hall0726@gmail.com").setData([
        "firstName": "MattPOOPY"
    ]) {
        error in
        if let error = error {
            print("error biatch")
        } else {
            print("Success")
        }
    }
}
func createUserObjectInFireBase(email: String, completion: @escaping (Int) -> Void) {
    var boolean = -1
    print("Creating user object in firebase store")
    print("email: " + email)
    let initialDevicesArray: [Any] = []
    let randomNumber = String(format: "%04d", arc4random_uniform(10000))
    let userData: [String: Any] = [
        "username": "JohnDoe",
        "email": email,
        "devices": [
                "plantName": "basil",
                "pathToTopic": "soilsaver/\(email)/basil/\(randomNumber)",
                "connectionStatus": "online",
                "moistureLevel": "1",
            
        ]
    ]
    
    let ref = Database.database().reference()
    
    print(ref)
    
    ref.child("users").childByAutoId().setValue(userData) { (error, ref) in
        if let error = error {
            boolean = 0
            print("Error: \(error.localizedDescription)")
        } else {
            print("Array data sent successfully!")
        }
        completion(boolean)
    }
}


struct CreateAccount: View {
    @State private var firstName: String = "";
    @State private var lastName: String = "";
    @State private var username: String = "";
    @State private var password: String = "";
    @State private var verifypassword: String = "";
    @State private var accountExistsBool: Bool = false;
    @State private var accountCreationError: Int = -1;
    @State private var accountCreated: Bool = false;
    @State private var loginError: Int = 0
    
    
    func accountExists() {
        
    }
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(red: 25/255, green: 25/255, blue: 25/255)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                Text("Soil Saver")
                    .font(.headline.bold())
                    .foregroundStyle(Color.white)
                    .padding(.bottom, 25)
                    .padding(.top, 25)
                    
                Text("Create a Soil Saver account")
                    .font(.title.bold())
                    .foregroundStyle(Color.white)
                    .padding(.bottom, 50)
                HStack {
                    CustomTextField(placeholder: "first name", text: $firstName)
                        .padding(.top, 10)
                        .padding(.leading, 10)
                        .padding(.bottom, 10)
                        
                    //Image(systemName: "envelope").padding(.trailing, 10)
                }.frame(height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 40/255, green: 40/255, blue: 40/255))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10) // Add border here
                                .stroke(Color(red: 70/255, green: 70/255, blue: 70/255), lineWidth: 2) // Specify border color and thickness
                        )
                )
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
                .foregroundColor(Color.white).bold()
                
                HStack {
                    CustomTextField(placeholder: "last name", text: $lastName)
                        .padding(.top, 10)
                        .padding(.leading, 10)
                        .padding(.bottom, 10)
                        
                    //Image(systemName: "envelope").padding(.trailing, 10)
                }.frame(height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 40/255, green: 40/255, blue: 40/255))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10) // Add border here
                                .stroke(Color(red: 70/255, green: 70/255, blue: 70/255), lineWidth: 2) // Specify border color and thickness
                        )
                )
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
                .foregroundColor(Color.white).bold()
                
                HStack {
                    CustomTextField(placeholder: "email", text: $username)
                        .padding(.top, 10)
                        .padding(.leading, 10)
                        .padding(.bottom, 10)
                        
                    //Image(systemName: "envelope").padding(.trailing, 10)
                }.frame(height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 40/255, green: 40/255, blue: 40/255))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10) // Add border here
                                .stroke(Color(red: 70/255, green: 70/255, blue: 70/255), lineWidth: 2) // Specify border color and thickness
                        )
                )
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
                .foregroundColor(Color.white).bold()
                
                HStack {
                    CustomTextField(placeholder: "password", text: $password)
                        .padding(.top, 10)
                        .padding(.leading, 10)
                        .padding(.bottom, 10)
                        
                    //Image(systemName: "envelope").padding(.trailing, 10)
                }.frame(height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 40/255, green: 40/255, blue: 40/255))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10) // Add border here
                                .stroke(Color(red: 70/255, green: 70/255, blue: 70/255), lineWidth: 2) // Specify border color and thickness
                        )
                )
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
                .foregroundColor(Color.white).bold()
                
                HStack {
                    CustomTextField(placeholder: "verify password", text: $verifypassword)
                        .padding(.top, 10)
                        .padding(.leading, 10)
                        .padding(.bottom, 10)
                        
                    //Image(systemName: "envelope").padding(.trailing, 10)
                }.frame(height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 40/255, green: 40/255, blue: 40/255))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10) // Add border here
                                .stroke(Color(red: 70/255, green: 70/255, blue: 70/255), lineWidth: 2) // Specify border color and thickness
                        )
                )
                .padding(.horizontal, 40)
                .padding(.bottom, 10)
                .foregroundColor(Color.white).bold()
                
                if accountExistsBool == true {
                    if accountCreationError == 1 {
                        Text("Passwords do not match.")
                            .padding(.top, 25)
                            .foregroundColor(.red)
                    } else if accountCreationError == 2 {
                        Text("Password must be atleast six characters.")
                            .padding(.top, 25)
                            .foregroundColor(.red)
                    } else if accountCreationError == 3 {
                        Text("Firebase Object creation was not successful, please contact support")
                            .padding(.top, 25)
                            .foregroundColor(.red)
                    }
                    
                }
                
                VStack {
                    Button(action: {
//                        if password != verifypassword {
//                            accountCreationError = 1
//                            accountExistsBool.toggle()
//                            
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                                accountExistsBool = false
//                            }
//                            
//                        } else if password.count < 6 {
//                            accountCreationError = 2
//                            accountExistsBool.toggle()
//                            
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                                accountExistsBool = false
//                            }
                        //} else {
                            
//                            createFirebaseAccount(email: username, password: password) {
//                                result in
//                                if result == -1 {
//                                    accountCreated = true
//                                    
//                                }
//                            }
//                            
//                            createUserObjectInFireBase(email: username) {
//                                result in
//                                loginError = result
//                                
//                                if (loginError == 0) {
//                                    accountCreationError = 2
//                                    accountExistsBool.toggle()
//                                    
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                                        accountExistsBool = false
//                                    }
//                                }
//                            }
                            createUserDocumentTest()
                            
                        //}
                    }, label: {
                        Text("Create Account")
                    }).padding(.bottom, 150)
                        .padding(.top, 25)
                    if accountCreated == true {
                        Text("Email or password are incorrect.")
                            .padding(.bottom, 10)
                            .foregroundColor(.red)
                    }
                    
                    NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true), isActive: $accountCreated) {
                                                EmptyView() // This is necessary to make NavigationLink work programmatically
                                            }
                    
                }
                Spacer()
                Text("By continuing, you agree to Soil Saver's Terms of Service and Privacy Policy")
                    .foregroundStyle(Color.white).font(.footnote.bold()).padding(.bottom, 40).frame(width: 350)
            }
            
        }
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        CreateAccount()
//    }
//}
