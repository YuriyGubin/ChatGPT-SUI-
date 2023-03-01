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
    var answer: String?
}

struct ContentView: View {
    
    let openAI = OpenAISwift(authToken: "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")
    @State private var search: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                
                TextField("Type here...", text: $search)
                    .onSubmit {
                        if !search.isEmpty {
                            performOpenAISearch()
                        }
                    }
                
            }.navigationTitle("ChatGPT")
        }
    }
    
    private func performOpenAISearch() {
        openAI.sendCompletion(with: search) { result in
            switch result {
            case .success(let success):
                print(success.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
