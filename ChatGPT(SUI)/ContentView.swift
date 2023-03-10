//
//  ContentView.swift
//  ChatGPT(SUI)
//
//  Created by Yuriy on 01.03.2023.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @State var chatMessages: [ChatMessage] = []
    @State var messageText = ""
    @State var backColor = Color(#colorLiteral(red: 0.07088997215, green: 0.6400098801, blue: 0.4992959499, alpha: 1))
    
    let openAIService = OpenAIService()
    @State var cancellables = Set<AnyCancellable>()
    @Namespace var bottomID
    
    var body: some View {
       
        VStack {
            ZStack {
                Color.init(backColor.cgColor!)
                    .frame(height: 60)
                    .ignoresSafeArea()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                HStack {
                    Spacer()
                    Image("ChatGPT")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Text("ChatGPT")
                        .tracking(3)
                        .foregroundColor(.white)
                        .background(Color.init(backColor.cgColor!))
                        .font(.system(size: 27))
                        .bold()
                    Spacer()
                }
            }
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(chatMessages, id: \.id) { message in
                            messageVeiw(message: message)
                                .id(message.id)
                        }
                    }
                }
                .onAppear {
                    proxy.scrollTo(chatMessages.last?.id)
                }
                .onChange(of: chatMessages.count) { _ in
                    proxy.scrollTo(chatMessages.last?.id)
                }
            }
            
            HStack {
                TextField("Type here...", text: $messageText) {
                    sendMessage()
                }
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(12)
                Button {
                    sendMessage()
                } label: {
                    Text("Send")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.init(backColor.cgColor!))
                        .cornerRadius(12)
                }
            }
        }
        .padding()
    }
    
    func messageVeiw(message: ChatMessage) -> some View {
        HStack {
            if message.sender == .me { Spacer() }
            Text(message.content)
                .foregroundColor(message.sender == .me ? .white : .black)
                .padding()
                .background(message.sender == .me ? .black.opacity(0.8) : .gray.opacity(0.1))
                .cornerRadius(16)
            if message.sender == .gpt { Spacer() }
        }
    }
    
    func sendMessage() {
        let myMessage = ChatMessage(
            id: UUID().uuidString,
            content: messageText,
            dateCreated: Date(),
            sender: .me
        )
        chatMessages.append(myMessage)
        openAIService.sendMessage(message: messageText).sink { completion in
            //
        } receiveValue: { response in
            guard let textResponse = response.choices.first?.text.trimmingCharacters(
                in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))
            ) else { return }
            let gptMessage = ChatMessage(
                id: response.id,
                content: textResponse,
                dateCreated: Date(),
                sender: .gpt
            )
            chatMessages.append(gptMessage)
        }
        .store(in: &cancellables)
        
        messageText = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ChatMessage {
    let id: String
    let content: String
    let dateCreated: Date
    let sender: MessageSender
}

enum MessageSender {
    case me
    case gpt
}

