//
//  RegisterView.swift
//  TwitterClone
//
//  Created by Ronald Jabouin on 1/2/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

struct RegisterView: View {
    @State var emailID: String = ""
    @State var password: String = ""
    @State var username: String = ""
    @State var userBio: String = ""
    @State var userBioLink: String = ""
    @State var userProfilePicData: Data?
    @State var isLoading: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    @State var showImagePicker: Bool = false
    @State var photoItem: PhotosPickerItem?
    
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    
    
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Lets Register\nAccount")
                .font(.largeTitle)
                .fontWeight(.bold)
                .hAlign(.leading)
            
            Text("Hello user, have a wonderful journey")
                .font(.title3)
                .hAlign(.leading)
            
            ViewThatFits {
                ScrollView(.vertical, showsIndicators: false) {
                    HelperView()
                }
                
                HelperView()
            }
            
            HStack{
                Text("Already have an account?")
                    .foregroundColor(.gray)
                
                Button("login now") {
                    dismiss()
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
            }
            .font(.callout)
            .vAlign(.bottom)
            
        }
        .vAlign(.top)
        .padding(15)
        .overlay {
            LoadingView(show: $isLoading)
        }
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem) { newValue in
            if let newValue {
                Task {
                    do {
                        guard let imageData = try await newValue.loadTransferable(type: Data.self) else {return}
                        
                        await MainActor.run(body: {
                            userProfilePicData = imageData
                        })
                    }
                }
            }
        }
        .alert(errorMessage, isPresented: $showError, actions: {})
    }
    
    @ViewBuilder
    func HelperView()-> some View{
        VStack(spacing: 12) {
            ZStack{
                if let userProfilePicData, let image = UIImage(data: userProfilePicData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image("NullProfile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .frame(width: 85, height: 85)
            .clipShape(Circle())
            .contentShape(Circle())
            .onTapGesture {
                showImagePicker.toggle()
            }
            .padding(.top, 25)
            
            
            TextField("Username", text: $username)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
                .padding(.top, 25)
            
            //SA Course on validating a valid email here
            TextField("Email", text: $emailID)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            
            SecureField("Password", text: $password)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            
            TextField("About You", text: $userBio, axis: .vertical)
                .frame(minHeight: 100, alignment: .top)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            
            TextField("Bio Link (optional)", text: $userBioLink)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            
            
            Button {
                registerUser()
            } label: {
                Text("Sign up")
                    .foregroundColor(.white)
                    .hAlign(.center)
                    .fillView(.black)
            }
            .disabledWithOpacity(username == "" || userBio == "" || emailID == "" || password == "" || userProfilePicData == nil)
            .padding(.top,10)
        }
        
    }
    
    func registerUser() {
        isLoading = true
        closeKeyboard()
        Task {
            do {
                //create firebase account
                try await Auth.auth().createUser(withEmail: emailID, password: password)
                
                //upload profile photo into firebase storage
                guard let userUID = Auth.auth().currentUser?.uid else {return}
                guard let imageData = userProfilePicData else {return}
                let storageRef = Storage.storage().reference().child("Profile_Images").child(userUID)
                let _ = try await storageRef.putDataAsync(imageData)
                
                //Downloading photo url
                let downloadURL = try await storageRef.downloadURL()
                
                //creating a user firestore object
                let user = User(username: username, userBio: userBio, userBioLink: userBioLink, userUID: userUID, userEmail: emailID, userProfileURL: downloadURL)
                
                //saving user doc into firestore database
                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: user, completion: { error in
                    if error == nil {
                        print("Saved Successfully")
                        
                        userNameStored = username
                        self.userUID = userUID
                        profileURL = downloadURL
                        logStatus = true
                    }
                    
                })
                
            } catch {
                //Delete created account in case of failure
                await setError(error)
            }
        }
    }
        
        func setError(_ error: Error)async {
            await MainActor.run(body: {
                errorMessage = error.localizedDescription
                showError.toggle()
                isLoading = false
            })
        }
    }
