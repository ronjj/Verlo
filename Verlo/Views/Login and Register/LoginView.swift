//
//  LandingView.swift
//  Verlo
//
//  Created by Ronald Jabouin on 12/30/22.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import Firebase


class LoginViewModel: ObservableObject {
    
    @Published var showError = false
    @Published var errorMessage = ""
    @AppStorage("log_status") var logStatus: Bool = false
    
    func handleError(error: Error)async{
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
    
    func logGoogleUser(user: GIDGoogleUser) {
        Task{
            do {
                guard let idToken = user.authentication.idToken else {return}
                let accessToken = user.authentication.accessToken
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                
                try await Auth.auth().signIn(with: credential)
                
                print("Success")
                await MainActor.run(body: {
                    withAnimation(.easeInOut) {logStatus = true}
                })
            } catch {
                await handleError(error: error)
            }
        }
    }
}

extension UIApplication {
    func getRootViewController()->UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
    
}
struct LoginViewOld: View {
    
    @StateObject var loginModel: LoginViewModel = .init()
    
    var body: some View {
        ZStack {
            
            Color.verloGreen
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Image("verlo-text")
                    .resizable()
                    .scaledToFit()
                    
                
                googleLoginButton
                .overlay {
                    if let clientID = FirebaseApp.app()?.options.clientID {
                        GoogleSignInButton{
                            GIDSignIn.sharedInstance.signIn(with: .init(clientID: clientID), presenting: UIApplication.shared.getRootViewController()){user, error in
                                if let error = error {
                                    print(error.localizedDescription)
                                    return
                                    
                                }
                                
                                if let user {
                                            loginModel.logGoogleUser(user: user)

                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
            }
        }
    }
}

extension LoginViewOld {
    private var googleLoginButton: some View {
        HStack(spacing: 8) {
            HStack {
                Image(systemName: "google-icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .frame(height: 45)
                
                Text("Google Sign In")
                    .font(.callout)
                    .lineLimit(1)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 15)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.black)
            }
            .overlay {
                
            }
            .clipped()
        }

    }
}


