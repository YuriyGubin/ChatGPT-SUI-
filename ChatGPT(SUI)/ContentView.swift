//
//  ContentView.swift
//  ChatGPT(SUI)
//
//  Created by Yuriy on 01.03.2023.
//

import SwiftUI
import OpenAISwift

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
                print("")
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
