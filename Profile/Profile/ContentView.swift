//
//  ContentView.swift
//  Profile
//
//  Created by Ashish Tripathi on 9/9/21.
//

import SwiftUI
import WebKit
import MessageUI


struct ContentView: View {
    @ObservedObject var viewModel = ProfileViewModel()
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State var showAlert = true
    @State var loadingView = true
    init() {}
    var body: some View {
        NavigationView {
            if viewModel.profile != nil {
                VStack(alignment: .center, spacing: 10) {
                    List {
                        HeaderView(name: viewModel.profile?.fullName ?? "",
                                   iconName: viewModel.profile?.avatarName ?? "",
                                   description: "\(viewModel.profile?.role ?? "") at \(viewModel.profile?.currentCompany ?? "")")
                        
                        Section(header: Text("Summary")
                                    .multilineTextAlignment(.leading)
                                    .font(.footnote)) {
                            Text(viewModel.profile?.professionalSummary ?? "")
                                .multilineTextAlignment(.leading)
                                .font(.footnote)
                        }
                        Section(header: Text("Skills")
                                    .multilineTextAlignment(.leading)
                                    .font(.footnote)) {
                            ForEach(viewModel.profile?.skills ?? []) { skill in
                                Text(skill.title ?? "")
                                    .font(.headline)
                                Text(skill.description ?? "")
                                    .font(.footnote)
                            }
                        }
                        Section(header: Text("Work Experience")
                                    .multilineTextAlignment(.leading)
                                    .font(.footnote)) {
                            ForEach(viewModel.profile?.experiences ?? []) { experience in
                                ExperienceCell(experience: experience)
                            }
                        }
                        Section(header: Text("Social profile")
                                    .multilineTextAlignment(.leading)
                                    .font(.footnote)) {
                            ForEach(viewModel.profile?.socialProfiles ?? []) { social in
                                SocialCell(social: social)
                            }
                        }
                        Section(header: Text("Education")
                                    .multilineTextAlignment(.leading)
                                    .font(.footnote)) {
                            Text(viewModel.profile?.education?.collegeName ?? "")
                                .font(.footnote)
                            Text(viewModel.profile?.education?.degree ?? "")
                                .font(.footnote)
                            Text(viewModel.profile?.education?.year ?? "")
                                .font(.footnote)
                        }
                    }
                    Button(action: {
                        self.isShowingMailView.toggle()
                    }) {
                        Text("Send Resume")
                    }
                    .disabled(!MFMailComposeViewController.canSendMail())
                    .sheet(isPresented: $isShowingMailView) {
                        MailView(result: self.$result)
                    }
                }.navigationBarTitle(Text("Profile"), displayMode: .large)
            }
            else {
                if viewModel.apiError != nil {
                    VStack {
                        Text("☹️")
                            .font(.largeTitle)
                            .alert(isPresented: $showAlert) { () -> Alert in
                                if let networkError = viewModel.apiError as? NetworkingError {
                                    return Alert(title: Text("\(networkError.errorDescription ?? "")"),
                                          message: Text("Please try again"),
                                          dismissButton: .cancel())
                                } else {
                                    return Alert(title: Text("\(viewModel.apiError?.localizedDescription ?? "")"),
                                          message: Text("Please try again"),
                                          dismissButton: .cancel())
                                }
                            }
                        Button {
                            showAlert = true
                            viewModel.retry()
                        } label: {
                            Text("Retry")
                        }

                    }

                } else {
                   LoadingView(isShowing: .constant(true)) {
                        NavigationView {
                            List(["1", "2", "3", "4", "5"], id: \.self) { row in
                                Text(row)
                            }
                        }
                    }
                }
            }
        }
        .onAppear() {
            viewModel.getProfileDetails()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct MailView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?
        
        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = context.coordinator
        mailViewController.setSubject("Resume of Ashish Tripathi - iOS Developer")
        mailViewController.setMessageBody("Hi,\n\n I am attaching my resume for the iOS developer position.", isHTML: false)

        if let filePath = Bundle.main.path(forResource: "resume", ofType: "pdf")
            {
                print("File path loaded.")
            if let fileData = NSData(contentsOfFile: filePath){
                    print("File data loaded.")
                mailViewController.addAttachmentData(fileData as Data, mimeType: "application/pdf", fileName: "Ashish_Tripathi_iOS_Developer.pdf")
                }
            }
        return mailViewController
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {}
}
