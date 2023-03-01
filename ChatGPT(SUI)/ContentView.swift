//
//  ContentView.swift
//  ChatGPT(SUI)
//
//  Created by Yuriy on 01.03.2023.
//

import SwiftUI
import OpenAISwift

struct QuestionAndAnswer: Identifiable {
    
    let id = UUID()
    
    let question: String
    var answer: String
}

struct ContentView: View {
    
    let openAI = OpenAISwift(authToken: "")
    
    @State private var search = ""
    @State private var questionAndAnswers: [QuestionAndAnswer] = []
    @State private var searching = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                ScrollView(showsIndicators: false) {
                    ForEach(questionAndAnswers) { qa in
                        VStack(spacing: 10) {
                            Text(qa.question)
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(qa.answer)
                                .padding([.bottom], 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }.padding()
                
                HStack {
                    TextField("Type here...", text: $search)
                        .onSubmit {
                            if !search.isEmpty {
                                searching = true
                                performOpenAISearch()
                            }
                        }
                    .padding()
                    if searching {
                        ProgressView()
                            .padding()
                    }
                        
                }
                
            }.navigationTitle("ChatGPT")
        }
    }
    
    private func performOpenAISearch() {
        openAI.sendCompletion(with: search) { result in
            switch result {
            case .success(let success):
                
                let questioAndAnswer = QuestionAndAnswer(
                    question: search,
                    answer: success.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
                
                questionAndAnswers.append(questioAndAnswer)
                search = ""
                searching = false
                
            case .failure(let error):
                print(error.localizedDescription)
                searching = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
