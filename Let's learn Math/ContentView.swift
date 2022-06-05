//
//  ContentView.swift
//  Let's learn Math
//
//  Created by Alex Bùi on 21/05/2022.
//

import SwiftUI

struct Question {
    var q: String
    var a: String
}

struct ContentView: View {
    @State private var imagesName = ["bear", "buffalo", "chick", "chicken", "cow", "crocodile", "dog", "duck", "elephant", "frog", "giraffe", "goat", "gorilla", "hippo", "horse", "monkey", "moose", "narwhal", "owl", "panda", "parrot", "penguin", "pig", "rabbit", "rhino", "sloth", "snake", "walrus", "whale", "zebra"]
    
    @State private var multiTable = 1
    let allMultiTable = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    @State private var numberOfQuestion = 20
    
    @State private var gameIsRunning = false
    @State private var questions = [Question]()
    @State private var currentQuestion = 0
    
    @State private var totalScore = 0
    @State private var remainingQuestion = 0
    
    @State private var userAnswer = ""
    @State private var isCorrect = false
    @State private var isWrong = false
    @State private var gameOver = false

    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertButtonTitle = ""
        
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [.teal, .yellow], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                if gameIsRunning {
                    
                    VStack {
                        HStack {
                            Image(imagesName[currentQuestion])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100, alignment: .center)
                            
                            Text(questions[currentQuestion].q)
                                .font(.title.bold())
                                .padding()
                                .frame(height: 50)
                                .background(.thickMaterial)
                                .cornerRadius(15)
                        }
                        
                        TextField("Type in your answer", text: $userAnswer)
                            .padding()
                            .background(.thickMaterial)
                            .keyboardType(.numberPad)
                            .focused($isFocused)
                        
                        Spacer()
                        Spacer()
                        
                        VStack {
                            Text("Total Score: \(totalScore)")
                                .font(.headline)
                            Text("Question Remaining: \(remainingQuestion)")
                                .font(.subheadline)
                        }
                        .scoreBoardStyle()
                        
                        Spacer()
                        
                        HStack {
                            Button {
                                checkAnswer(userAnswer)
                            } label: {
                                Text("Submit answer")
                                    .inGameButtonStyle()
                                    .foregroundColor(.teal)
                            }
                            
                            Button {
                                gameIsRunning = false
                            } label: {
                                Text("Quit Game")
                                    .inGameButtonStyle()
                                    .foregroundColor(.red)
                        }
                        }
                        
                        Spacer()
                    }
                }
                
                else {
                    VStack {
                        Spacer()
                        
                        Section {
                            Stepper("\(numberOfQuestion) questions", value: $numberOfQuestion, in: 10...30, step: 5)
                                .padding()
                                .frame(height: 50, alignment: .center)
                                .frame(maxWidth: .infinity)
                                .frame(maxWidth: 400)
                                .foregroundColor(.primary)
                                .background(.thickMaterial)
                                .cornerRadius(10)
                        } header: {
                            Text("Choose the number of questions you want to do")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        Section {
                            Text("Selected Multiplication Table: \(multiTable)")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            HStack {
                                ForEach(1..<4) { number in
                                    Button {
                                        withAnimation {
                                            multiTable = number
                                        }
                                    } label: {
                                        Text("\(number)")
                                            .buttonDesign()
                                    }
                                }
                            }
                            
                            HStack {
                                ForEach(4..<7) { number in
                                    Button {
                                        multiTable = number
                                    } label: {
                                        Text("\(number)")
                                            .buttonDesign()
                                    }
                                }
                            }
                            
                            HStack {
                                ForEach(7..<10) { number in
                                    Button {
                                        multiTable = number
                                    } label: {
                                        Text("\(number)")
                                            .buttonDesign()
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Section {
                            Button {
                                newGame()
                            } label: {
                                Text("Start Game")
                                    .frame(width: 250, height: 70, alignment: .center)
                                    .font(.largeTitle.bold())
                                    .foregroundColor(.primary)
                                    .background(.thickMaterial)
                                    .cornerRadius(15)
                            }
                        }
                        Spacer()
                    }
                    .navigationTitle("Let's learn Math")
                    .navigationBarHidden(false)
                }
            }
        }
        .alert(alertTitle, isPresented: $isCorrect) {
            Button("Continue", action: nextQuestion)
        } message: {
            Text("You received 1 score!")
        }
        
        .alert(alertTitle, isPresented: $isWrong) {
            Button("Continue", action: nextQuestion)
        } message: {
            Text(":( Let's try that again!")
        }
        
        .alert(alertTitle, isPresented: $gameOver) {
            Button("Quit Game", role: .destructive) { gameIsRunning = false }
            Button("Play again", role: .cancel, action: newGame)
        } message: {
            Text("Do you want to go again?")
        }
    }
    
    func newGame() {
        questions.removeAll()
                
        for _ in 1...numberOfQuestion {
            let number = allMultiTable.randomElement() ?? 1

            questions.append(Question(q: "How much is \(multiTable) x \(number)", a: String(multiTable * number)))
        }
        
        questions.shuffle()
        gameIsRunning = true
        currentQuestion = 0
        totalScore = 0
        remainingQuestion = numberOfQuestion
    }
    
    func nextQuestion() {
        questions.shuffle()
        imagesName.shuffle()
        
        if remainingQuestion == 1 {
            endGame()
        } else {
            currentQuestion += 1
            remainingQuestion -= 1
        }
        
        print(currentQuestion)
    }
    
    func checkAnswer(_ chosen: String) {
        if chosen == questions[currentQuestion].a {
            isCorrect = true
            totalScore += 1
            alertTitle = "CORRECT!"
        } else {
            isWrong = true
            alertTitle = "INCORRECT!"
        }
        
        userAnswer = ""
    }
    
    func endGame() {
        gameOver = true
        alertTitle = "GAME OVER!!!"
    }
}

struct ButtonDesign: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 100, height: 100, alignment: .center)
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .foregroundColor(.primary)
            .background(.thickMaterial)
            .cornerRadius(20)
    }
}

struct InGameButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.title.bold())
            .background(.thickMaterial)
            .cornerRadius(15)
    }
}

struct ScoreBoardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.thinMaterial)
            .cornerRadius(15)
    }
}

extension View {
    func buttonDesign() -> some View {
        modifier(ButtonDesign())
    }
    
    func inGameButtonStyle() -> some View {
        modifier(InGameButtonStyle())
    }
    
    func scoreBoardStyle() -> some View {
        modifier(ScoreBoardStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
