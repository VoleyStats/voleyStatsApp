import SwiftUI
import FirebaseAuth

struct Login: View {
    @ObservedObject var viewModel: LoginModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack{
//            Text("player.new".trad()).font(.title)
            Image("logo").resizable().aspectRatio(contentMode: .fit).frame(width: 300)
            VStack{
                Text(viewModel.login ? "login".trad() : "sign.up".trad()).font(.largeTitle).padding()
                Section{
                    VStack{
                        VStack(alignment: .leading){
                            Text("email".trad()).font(.caption)
                            TextField("email".trad(), text: $viewModel.email).textFieldStyle(TextFieldDark()).textInputAutocapitalization(.never).border(viewModel.errorCode == .emailError ? .red : .clear)
                            if viewModel.errorCode == .emailError{
                                Text(viewModel.errorMsg!).font(.caption).foregroundStyle(.red)
                            }
                        }.padding(.bottom).padding(.horizontal)
                        if !viewModel.login{
                            VStack(alignment: .leading){
                                Text("username".trad()).font(.caption)
                                TextField("username".trad(), text: $viewModel.userName).textFieldStyle(TextFieldDark()).textInputAutocapitalization(.never)
                            }.padding(.bottom).padding(.horizontal)
                        }
                        VStack(alignment: .leading){
                            Text("password".trad()).font(.caption)
                            ZStack{
                                if viewModel.secured {
                                    SecureField("password".trad(), text: $viewModel.password).textFieldStyle(TextFieldDark()).textInputAutocapitalization(.never).border(viewModel.errorCode == .passwordError ? .red : .clear)
                                }else{
                                    TextField("password".trad(), text: $viewModel.password).textFieldStyle(TextFieldDark()).textInputAutocapitalization(.never).border(viewModel.errorCode == .passwordError ? .red : .clear)
                                }
                                Image(systemName: viewModel.secured ? "eye.slash" : "eye").padding().frame(maxWidth: .infinity, alignment: .trailing).onTapGesture{
                                    viewModel.secured.toggle()
                                }
                            }
                            if viewModel.errorCode == .passwordError{
                                Text(viewModel.errorMsg!).font(.caption).foregroundStyle(.red)
                            }
                        }.padding(.horizontal)
                        if !viewModel.login {
                            VStack(alignment: .leading){
                                Text("verify.password".trad()).font(.caption)
                                ZStack{
                                    if viewModel.securedRepeat {
                                        SecureField("verify.password".trad(), text: $viewModel.passwordRepeat).textFieldStyle(TextFieldDark()).textInputAutocapitalization(.never).border(viewModel.password != viewModel.passwordRepeat ? .red : .clear)
                                    }else{
                                        TextField("verify.password".trad(), text: $viewModel.passwordRepeat).textFieldStyle(TextFieldDark()).textInputAutocapitalization(.never).border(viewModel.password != viewModel.passwordRepeat ? .red : .clear)
                                    }
                                    Image(systemName: viewModel.securedRepeat ? "eye.slash" : "eye").padding().frame(maxWidth: .infinity, alignment: .trailing).onTapGesture{
                                        viewModel.securedRepeat.toggle()
                                    }
                                }
                                if viewModel.password != viewModel.passwordRepeat{
                                    Text("password.match".trad()).font(.caption).foregroundStyle(.red)
                                }
                            }.padding(.top).padding(.horizontal)
                        }
                        if viewModel.errorCode == .unknownError{
                            Text(viewModel.errorMsg!).font(.footnote).foregroundStyle(.red)
                        }
                        
                    }
//                    .padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                }.padding(.bottom)
                Button(action:{
                    viewModel.saving.toggle()
//                    viewModel.errorCode = nil
//                    viewModel.errorMsg = nil
                    if viewModel.login{
                        Auth.auth().signIn(withEmail: viewModel.email.lowercased(), password: viewModel.password){ res, err in
                            if let err = err as NSError? {
                                let errorCode = AuthErrorCode.Code(rawValue: err.code)!
                                viewModel.checkError(code: errorCode)
                                viewModel.saving.toggle()
                            }
                            if res != nil {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }else{
                        if viewModel.password == viewModel.passwordRepeat{
                            Auth.auth().createUser(withEmail: viewModel.email, password: viewModel.password){ res, err in
                                if let err = err as NSError? {
                                    let errorCode = AuthErrorCode.Code(rawValue: err.code)!
                                    viewModel.checkError(code: errorCode)
                                    viewModel.saving.toggle()
                                }
                                if res != nil {
                                    let changereq = Auth.auth().currentUser?.createProfileChangeRequest()
                                    changereq?.displayName = viewModel.userName
                                    changereq?.commitChanges{error in
                                        if let error = error as NSError?{
                                            let errCode = AuthErrorCode.Code(rawValue: error.code)!
                                            viewModel.checkError(code: errCode)
                                            viewModel.saving.toggle()
                                        }else {
                                            UserDefaults.standard.set(String(UnicodeScalar(Array(0x1F300...0x1F3F0).randomElement()!)!), forKey: "avatar")
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                    
                                }
                            }
                        }else{
                            viewModel.errorCode = .matchError
                            viewModel.errorMsg = "password.match".trad()
                        }
                    }
                }){
                    if viewModel.saving{
                        ProgressView().progressViewStyle(CircularProgressViewStyle()).tint(.white).frame(maxWidth: .infinity, alignment: .center)
                    }else{
                        Text(viewModel.login ? "login".trad() : "sign.up".trad()).frame(maxWidth: .infinity, alignment: .center)
                    }
                }.disabled(!viewModel.verify()).padding().background(viewModel.verify() ? .cyan : .cyan.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor(!viewModel.verify() ? .gray : .white).padding()
                
                
            }
            .padding()
            .background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
            .padding()
            .frame(maxWidth: 600)
//            .padding()
            HStack{
                Text(viewModel.login ? "no.account.yet".trad() : "account.yet".trad())
                Text(viewModel.login ? "sign.up".trad() : "login".trad()).font(.body.bold()).foregroundStyle(.cyan).onTapGesture {
                    viewModel.login.toggle()
                }
            }.padding()
        
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.swatch.dark.high)
//            .navigationTitle(viewModel.login ? "login".trad() : "sign.up".trad())
        .foregroundColor(.white)
    }
}

class LoginModel: ObservableObject{
    @Published var password: String = ""
    @Published var passwordRepeat: String = ""
    @Published var email: String = ""
    @Published var errorCode : UserForm?
    @Published var errorMsg : String?
    @Published var secured: Bool = true
    @Published var securedRepeat: Bool = true
    @Published var userName: String = ""
    @Published var saving: Bool = false
    @Published var login:Bool
    init(login:Bool){
        self.login = login
    }
    func verify() -> Bool {
        if login{
            return !password.isEmpty && !email.isEmpty
        }else{
            return !password.isEmpty && !email.isEmpty && password == passwordRepeat
        }
    }
    func checkError(code: AuthErrorCode.Code){
        switch code {
        case AuthErrorCode.emailAlreadyInUse:
            self.errorCode = .emailError
            self.errorMsg = "email.in.use".trad()
        case AuthErrorCode.wrongPassword:
            self.errorCode = .passwordError
            self.errorMsg = "wrong.password".trad()
        case AuthErrorCode.invalidEmail:
            self.errorCode = .emailError
            self.errorMsg = "email.format".trad()
        case AuthErrorCode.weakPassword:
            self.errorCode = .passwordError
            self.errorMsg = "password.weak".trad()
        default:
            self.errorCode = .unknownError
            self.errorMsg = "unknown.error".trad()
        }
    }
}

enum UserForm {
    case passwordError
    case emailError
    case matchError
    case unknownError
}

//#Preview {
//    Login(viewModel: LoginModel(login: true))
//}


