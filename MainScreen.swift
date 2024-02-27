//
//  MainScreen.swift
//  SoilSaver
//
//  Created by Matt Hall on 2/13/24.
//

import Foundation
import SwiftUI
import MQTTNIO
import NIO
import NIOTransportServices


struct MainScreen: View {
    @State private var roomManagement: Bool = false;
    @State private var addDevice: Bool = false;
    @StateObject private var roomData = RoomData()
    @State private var showRoomAdjustmentSheet = false
    @State private var selectedRoomIndex: Int? = nil
    static let eventLoopGroup = NIOTSEventLoopGroup()
    
    
    func createClient() {
        let client = MQTTClient(host: "j99e97d3.us-east-1.emqx.cloud", port: 15251, identifier: "POOPYBUTTSEX", eventLoopGroupProvider: .shared(Self.eventLoopGroup), configuration: MQTTClient.Configuration.init(userName:"wokahontas", password:"1234"))
        client.connect()
    }
   
    
    
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.0, green: 0.39, blue: 0.0), Color.brown]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack{
                GroupBox{
                    VStack {
                        HStack {
                            ScrollView(.horizontal, showsIndicators: true) {
                                HStack {
                                    
                                    ForEach(roomData.rooms, id: \.self) { room in
                                        
                                        Button(action: {}, label: {
                                            Text(room).foregroundColor(.white).padding(.leading, 7).padding(.trailing, 7).font(.caption)
                                        }).background(.gray).cornerRadius(12)
                                        
                                    }
                                }.padding(.bottom, 10)
                            }.padding(.trailing, 5)
                            HStack{
                                Button(action: {
                                    roomManagement = true
                                }, label: {
                                    Image(systemName: "gearshape.fill").foregroundColor(.white)
                                })
                                
                                .sheet(isPresented: $roomManagement) {
                                    RoomAdjustmentView(selectedRoomIndex: $selectedRoomIndex, roomData: roomData)
                                            }
                                
                            }.padding(.bottom, 10).padding(.trailing, 10)
                            HStack{
                                Button(action: {
                                    addDevice = true
                                    createClient()
                                }, label: {
                                    Image(systemName: "plus").foregroundColor(.white)
                                })
                                .sheet(isPresented: $addDevice) {
                                    AddDeviceView()
                                    
                                }
                                
                            }.padding(.bottom, 10).padding(.trailing, 10)
                        }
                        Rectangle().frame(height: 2)
                    }
                    
                    ScrollView(.vertical, showsIndicators: true) {
            
                        
                        

                        Button(action: {}, label: {
                            HStack {
                                Text("Basil Plant").padding(.top, 10).padding(.bottom, 10).font(.caption).bold()
                                Rectangle()
                                            .frame(width: 2, height: 100)
                                            .foregroundColor(Color.black)
                                            .padding(.leading, 10).padding(.trailing, 10)
                                Text("Connection").padding(.top, 10).padding(.bottom, 10).font(.caption).bold()
                                Image(.status).resizable().frame(width: 10, height: 10)
                                Rectangle()
                                            .frame(width: 2, height: 100)
                                            .foregroundColor(Color.black)
                                            .padding(.leading, 10).padding(.trailing, 10)
                                Text("Moisture").padding(.top, 10).padding(.bottom, 10).font(.caption).bold()
                                Image(.status).resizable().frame(width: 10, height: 10)
                            }
                            
                        }).frame(width: 350, height: 40)
                            .background(Color(red: 210 / 255, green: 180 / 255, blue: 140 / 255))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .padding(.bottom, 10)
                            .padding(.top, 10)
                        
                        
                        Button(action: {}, label: {
                            HStack {
                                Text("Basil Plant").padding(.top, 10).padding(.bottom, 10).font(.caption).bold()
                                Rectangle()
                                            .frame(width: 2, height: 100)
                                            .foregroundColor(Color.black)
                                            .padding(.leading, 10).padding(.trailing, 10)
                                Text("Connection").padding(.top, 10).padding(.bottom, 10).font(.caption).bold()
                                Image(.status).resizable().frame(width: 10, height: 10)
                                Rectangle()
                                            .frame(width: 2, height: 100)
                                            .foregroundColor(Color.black)
                                            .padding(.leading, 10).padding(.trailing, 10)
                                Text("Moisture").padding(.top, 10).padding(.bottom, 10).font(.caption).bold()
                                Image(.status).resizable().frame(width: 10, height: 10)
                            }
                            
                        }).frame(width: 350, height: 40)
                            .background(Color(red: 210 / 255, green: 180 / 255, blue: 140 / 255))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .padding(.bottom, 10)
                            .padding(.top, 10)
                        
                    }
                    
                }.frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.85)
                    .backgroundStyle(.gray)
                
            }.opacity(0.70)
            .cornerRadius(12)
            
        }
    }
}


struct RoomAdjustmentView: View {
    @Binding var selectedRoomIndex: Int?
    @State private var addRoom: String = "";
    @ObservedObject var roomData: RoomData
    @Environment(\.presentationMode) var presentationMode

    func removeRoom(at offsets: IndexSet) {
        roomData.rooms.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Room Management")) {
                    TextField("Enter Room Name", text: $addRoom)
                }
                Button("Create Room") {
                    roomData.addRoom(addRoom)
                    addRoom = ""
                    roomData.objectWillChange.send()
                    presentationMode.wrappedValue.dismiss()
                }
                Section(header: Text("Current Rooms")) {
                    List {
                        ForEach(roomData.rooms, id: \.self) { room in
                            Text(room)
                        }.onDelete(perform: removeRoom)
                    }
                }
            }
            .navigationTitle("Room Management")
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }.preferredColorScheme(.dark)
    }
}


struct AddDeviceView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var ssid: String = "";
    @State private var password: String = "";
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Add New Device")) {
                    TextField("SSID", text: $ssid)
                    SecureField("Password", text: $password)
                }
                Button("Add Device") {
                    sendPostRequest(ssid: ssid, password: ssid)
//                    ssid.addRoom(addRoom)
//                    addRoom = ""
//                    roomData.objectWillChange.send()
                    
                    presentationMode.wrappedValue.dismiss()
                }
                
            }
            .navigationTitle("New Device Setup")
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }.preferredColorScheme(.dark)
    }
}

class RoomData: ObservableObject {
    @Published var rooms: [String] = UserDefaults.standard.stringArray(forKey: "rooms") ?? []
    
    func addRoom(_ newRoom: String) {
            rooms.append(newRoom)
            // Update UserDefaults to persist the changes
            UserDefaults.standard.set(rooms, forKey: "rooms")
        }
}




func sendPostRequest(ssid: String, password: String) {
    // Replace this URL with your server endpoint
    let urlString = "http://192.168.4.1:8030/update_wifi"
    
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Replace these values with your Wi-Fi credentials
    let ssid = ssid
    let password = password
    
    let wifiCredentials: [String: Any] = ["ssid": ssid, "password": password]
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: wifiCredentials)
        request.httpBody = jsonData
    } catch {
        print("Error encoding JSON: \(error)")
        return
    }
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid response")
            return
        }
        
        print("Response status code: \(httpResponse.statusCode)")
        
        if let data = data, let responseString = String(data: data, encoding: .utf8) {
            print("Response data: \(responseString)")
        }
    }
    
    task.resume()
}

// Call the function to send the POST request
