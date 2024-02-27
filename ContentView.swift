//
//  ContentView.swift
//  Plant watering detector
//
//  Created by Matt Hall on 1/7/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Firebase
import Foundation
import MQTTNIO
import NIO
import NIOTransportServices
import GoogleSignInSwift



//GoogleSignInButtonViewModel

struct CustomButtonStyle: ButtonStyle {
    
    var textColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(textColor)
            
    }
}

//func handleSignInButton() {
//  GIDSignIn.sharedInstance.signIn(
//    withPresenting: rootViewController) { signInResult, error in
//      guard let result = signInResult else {
//        // Inspect error
//        return
//      }
//      // If sign in succeeded, display the app's main content View.
//    }
//  )
//}

func loginFirebase(email: String, password: String, completion: @escaping (Int) -> Void) {
    var boolean = -1
    Auth.auth().signIn(withEmail: email, password: password) {
        authResult, error in
        if let error = error {
            if  error.localizedDescription.contains("The supplied auth credential is malformed or has expired.") {
                print("username or password is wrong")
                boolean = 1
                print(error.localizedDescription)
            } else if error.localizedDescription.contains("The email address is badly formatted.") {
                print("email address poorly formatted")
                print(error.localizedDescription)
                boolean = 2
            } else {
                print("unknown error")
                print(error.localizedDescription)
                boolean = 3
            }
            
        
            completion(boolean)
        } else {
            completion(boolean)
        }
        
        
        
    }
    
}



struct ContentView: View {
    @State private var username: String = "";
    @State private var password: String = "";
    @State private var emailText: String = "Email";
    @State private var isCreateAccountActive: Bool = false
    @State private var loginSuccessful: Bool = false
    @State private var loginError: Int = 0
    @State private var loginErrorText: Bool = false
    

    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(red: 25/255, green: 25/255, blue: 25/255)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                VStack{
                    
                    
                    GeometryReader { geometry in
                        Image(.plantLogo)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height * 1.0) // Set both width and height
                            .clipped() // Ensure the image is clipped to the frame
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.45).padding(.top, 60)
                    
                    Text("Welcome to Soil Saver")
                        .font(.title).bold()
                        .foregroundStyle(Color.white)
                        .padding(.top, 10)
                    Text("Keep your plants nourished.")
                        .font(.headline)
                        .foregroundStyle(Color.white)
                        .padding(.top, 5)
                        .padding(.bottom, 15)
                    VStack {
                        HStack {
                            CustomTextField(placeholder: "Email", text: $username)
                                .padding(.top, 10)
                                .padding(.leading, 10)
                                .padding(.bottom, 10)
                                
                            Image(systemName: "envelope").padding(.trailing, 10)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 40/255, green: 40/255, blue: 40/255))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10) // Add border here
                                        .stroke(Color(red: 70/255, green: 70/255, blue: 70/255), lineWidth: 2) // Specify border color and thickness
                                )
                        )
                        .padding(.horizontal, 25)
                        .padding(.bottom, 10)
                        .foregroundColor(Color.white).bold()
                        
                        
                        HStack {
                            CustomSecureField(placeholder: "Password", text: $password)
                                .padding(.top, 10)
                                .padding(.leading, 10)
                                .padding(.bottom, 10)
                                
                                
                            Image(systemName: "key")
                                .padding(.trailing, 15)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 40/255, green: 40/255, blue: 40/255))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10) // Add border here
                                        .stroke(Color(red: 70/255, green: 70/255, blue: 70/255), lineWidth: 2) // Specify border color and thickness
                                )
                        )
                        .padding(.horizontal, 25) // Apply horizontal padding outside the background
                        .padding(.bottom, 10) // Apply bottom padding outside the background
                        .foregroundColor(Color.white)
                        .bold()
                            
                            
                        
                        
                        if loginErrorText == true {
                            if (loginError == 1) {
                                Text("Email or password are incorrect.")
                                    .padding(.bottom, 10)
                                    .foregroundColor(.red)
                            } else if loginError == 2 {
                                Text("Email is not properly formatted.")
                                    .padding(.bottom, 10)
                                    .foregroundColor(.red)
                            } else if loginError == 3 {
                                Text("Unknown error occured during login.")
                                    .padding(.bottom, 10)
                                    .foregroundColor(.red)
                            }
                            
                        }
                        
                        Button(action: {}, label: {
                            Text("Forgot your password? Click here.")
                                .foregroundColor(Color.white)
                                .padding(.top, 15)
                                .padding(.bottom, 15)
                        })
                        
                    }
                    VStack {
                        HStack {
                            Button(action: {
                                loginFirebase(email: username, password: password) {
                                    result in
                                    loginError = result
                                    
                                    if loginError == 1 || loginError == 2 || loginError == 3 {
                                        loginErrorText.toggle()
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                            loginErrorText = false
                                        }
                                        
                                    } else {
                                        loginSuccessful = true
                                    }
                                }
                                
                                
                                
                            }, label: {
                                Text("Login")
                                    .foregroundColor(.white)
                                    .frame(width: 250, height: 10)
                                    .bold()
                                    .padding()
                                    .background(Color(red: 34/255.0, green: 139/255.0, blue: 34/255.0))
                                    .cornerRadius(10)
                                            
                            })
                        }.padding(.top, 10)
                        
                        //GoogleSignInButton(action: handleSignInButton)
                        
                        NavigationLink(destination: CreateAccount(), isActive: $isCreateAccountActive) {
                            EmptyView() // This is necessary to make NavigationLink work programmatically
                        }
                        
                        NavigationLink(destination: MainScreen().navigationBarBackButtonHidden(true), isActive: $loginSuccessful) {
                            EmptyView() // This is necessary to make NavigationLink work programmatically
                        }
                        HStack {
                            Button(action: {
                                isCreateAccountActive = true
                            }, label: {
                                Text("Create Account")
                                    .foregroundColor(.white)
                                    .bold()
                                    .frame(width: 250, height: 10)
                                    .padding()
                                    .background(Color(red: 34/255.0, green: 139/255.0, blue: 34/255.0))
                                    .cornerRadius(10)
                            })
                        }.padding(.top, 100).padding(.bottom, 125)
                    }
                    
                    
                    
                    
                }
            }
            
        }
    }
}

struct CustomSecureField: UIViewRepresentable {
    var placeholder: String
    @Binding var text: String
    var placeholderColor: UIColor = .white
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: placeholderColor]
        )
        textField.textColor = .white
        textField.autocapitalizationType = .none
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}

struct CustomTextField: UIViewRepresentable {
    var placeholder: String
    @Binding var text: String
    var placeholderColor: UIColor = .white
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: placeholderColor]
        )
        textField.textColor = .white
        textField.autocapitalizationType = .none
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}


struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
