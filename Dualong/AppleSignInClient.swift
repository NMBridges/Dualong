//
//  AppleSignIn.swift
//  Dualong
//
//  Created by Nolan Bridges on 8/26/20.
//  Copyright © 2020 NiMBLe Interactive. All rights reserved.
//

import AuthenticationServices

class AppleSignInClient: NSObject
{
    var completionHandler: (_ fullname: String?, _ email: String?, _ token: String?) -> Void = { _, _, _ in }

    @objc func handleAppleIdRequest(block: @escaping (_ fullname: String?, _ email: String?, _ token: String?) -> Void)
    {
        completionHandler = block
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }

    func getCredentialState(userID: String)
    {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userID) { credentialState, _ in
            switch credentialState {
            case .authorized:
                // The Apple ID credential is valid.
                break
            case .revoked:
                // The Apple ID credential is revoked.
                break
            case .notFound:
                // No credential was found, so show the sign-in UI.
                break
            default:
                break
            }
        }
    }
}

extension AppleSignInClient: ASAuthorizationControllerDelegate
{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization)
    {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential
        {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            //print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
            print(String(data: appleIDCredential.identityToken!, encoding: .utf8)!)
            if let identityTokenData = appleIDCredential.identityToken,
                let identityTokenString = String(data: identityTokenData, encoding: .utf8)
            {
                //print("Identity Token \(userIdentifier)")
                completionHandler(fullName?.givenName, email, userIdentifier)
                if(fullName != nil)
                {
                    name = fullName!.givenName ?? ""
                }
            } else
            {
                completionHandler(fullName?.givenName, email, nil)
                if(fullName != nil)
                {
                    name = fullName!.givenName ?? ""
                }
            }

            getCredentialState(userID: userIdentifier)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error)
    {
        // Handle error.
        print("error in sign in with apple: \(error.localizedDescription)")
    }
}
