//
//  ContentView.swift
//  Multiplication (Challange 3)
//
//  Created by Omer Avital on 6/1/22.
//

import SwiftUI

struct QuestionData: Equatable, Identifiable, Hashable {
    let num1: Int
    let num2: Int
    var id: String { "\(num1)×\(num2)" }
    var solution: Int { num1 * num2 }
    var isCorrect: Bool?
    
    init(num1: Int, num2: Int) {
        self.num1 = num1
        self.num2 = num2
    }
    
    init(range: ClosedRange<Int>) {
        num1 = range.randomElement() ?? range.lowerBound
        num2 = range.randomElement() ?? range.upperBound
    }
    
    func check(guess: Int?) -> Bool {
        guess == solution
    }
}

struct Question: View {
    let questionData: QuestionData
    let onGuess: (_ isCorrect: Bool) -> Void
    
    @State private var givenAnswer: Int?
    @State private var isCorrect: Bool?
    
    var body: some View {
        return VStack {
            ZStack {
                VStack {
                    Text("\(questionData.num1) × \(questionData.num2)")
                        .font(.title2.bold())
                    
                    TextField("Answer", value: $givenAnswer, formatter: NumberFormatter())
                        .foregroundColor(isCorrect == nil ? nil : (isCorrect ?? false ? .green : .red))
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(isCorrect == nil ? .gray : (isCorrect ?? false ? .green : .red))
                        )
                        .keyboardType(.numberPad)
                        .onSubmit {
                            isCorrect = questionData.check(guess: givenAnswer)
                            onGuess(isCorrect ?? false)
                        }
                        .disabled(isCorrect != nil)
                }
                .padding()
                
                if let isCorrect = isCorrect {
                    HStack {
                        Image(systemName: isCorrect ? "checkmark.circle" : "x.circle")
                            .font(.title2)
                        Text(isCorrect ? "Correct!" : "Wrong!")
                    }
                    .foregroundColor(isCorrect ? .green : .red)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.top, 10)
                }
            }
        }
    }
}

struct ContentView: View {
    let numOfQuestionsChoices = [2, 5, 10, 20]
    
    // General
    @State private var isPlaying = false
    @State private var gameNumber = 0
    
    // Settings
    @State private var maxNum = 10
    @State private var numOfQuestionsIndex = 1
    var numberOfQuestions: Int { numOfQuestionsChoices[numOfQuestionsIndex] }
    var numRange: ClosedRange<Int> { 1...maxNum }
    
    // Game
    @State private var questions = [QuestionData]()
    @State private var endTitle = ""
    @State private var endMessage = ""
    @State private var isShowingEnd = false
    
    var body: some View {
        NavigationView {
            Form {
                if isPlaying {
                    ForEach(Array(questions.enumerated()), id: \.element.id) { i, question in
                        Section {
                            Question(questionData: question) { isCorrect in
                                onGuess(isCorrect: isCorrect, questionNum: i)
                            }
                        }
                    }
                } else {
                    Section("Settings") {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Difficulty")
                                    .font(.headline)
                                Text("Max number to multiply")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Text(String(maxNum))
                                .padding(.trailing, 5)
                            Stepper("Difficulty", value: $maxNum, in: 4...12)
                                .labelsHidden()
                        }
                        
                        HStack {
                            Text("Number of questions")
                                .font(.headline)
                            
                            Picker("Number of questions", selection: $numOfQuestionsIndex) {
                                ForEach(0..<numOfQuestionsChoices.count) {
                                    Text("\(numOfQuestionsChoices[$0])")
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                    
                    Button("Start") {
                        start()
                    }
                }
            }
            .navigationTitle("Multiplication Game")
            .alert(endTitle, isPresented: $isShowingEnd) {
                Button("Ok", action: restart)
            } message: {
                Text(endMessage)
            }
            .toolbar {
                if isPlaying {
                    Button("Restart", action: restart)
                }
            }
            .animation(.default, value: isPlaying)
        }
    }
    
    func onGuess(isCorrect: Bool, questionNum: Int) {
        questions[questionNum].isCorrect = isCorrect
        
        if (questions.reduce(true) { $0 && $1.isCorrect != nil }) {
            end()
        }
    }
    
    func start() {
        var questionsSet = Set([QuestionData]())
        while questionsSet.count < numberOfQuestions {
            questionsSet.insert(QuestionData(range: numRange))
        }
        questions = Array(questionsSet)
        gameNumber += 1
        isPlaying = true
    }
    
    func restart() {
        isPlaying = false

    }
    
    func end() {
        let points = questions.reduce(0) { $0 + ($1.isCorrect ?? false ? 1 : 0) }
        
        endTitle = "You did it!"
        endMessage = "You got \(points)/\(numberOfQuestions) questions correct!"
        isShowingEnd = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
