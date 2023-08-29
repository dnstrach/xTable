//
//  ContentView.swift
//  xTable
//
//  Created by Dominique Strachan on 8/24/23.
//

import SwiftUI

struct generalTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .fontWeight(.bold)
    }
}

struct ContentView: View {
    @State private var gameActive = false
    @State private var animals = ["bear", "buffalo", "chick", "chicken", "cow", "crocodile", "dog", "duck", "elephant", "frog", "giraffe", "goat", "gorilla", "hippo", "horse", "narwhal", "owl", "panda", "parrot", "pig", "rabbit", "rhino", "sloth", "snake", "walrus", "whale", "zebra"].shuffled()
    @State private var rotation = 0.0
    
    @State private var numSelected = 2
    @State private var roundsSelected = 3
    @State private var rounds = 0
    @State private var finalRound = false
    @State private var score = 0
    
    @State private var multipliers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].shuffled()
    @State private var multiplier = 0
    @State private var correctAnswer = 0
    @State private var choices = [0, 1, 2, 3]
    
    var body: some View {
        
        ZStack {
            
            //BACKGROUND
            LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("LightOrange")]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                
                //SCORE & ROUND
                VStack(spacing: 50) {
                    HStack(spacing: 100) {
                        Text(gameActive ? "Score: \(score)" : "")
                            .font(.title)
                        
                        Text(gameActive ? "Rounds: \(rounds)" : "")
                            .font(.title)
                    }
                    
                    //TITLE
                    Text(gameActive ? "\(numSelected) x \(multiplier) = " : "xTable")
                        .font(.system(size: 60))
                        .italic()
                }
                
                Spacer()
                
                //READY / RESTART
                VStack(spacing: 5) {
                    Button {
                        gameActive.toggle()
                        rotation += 360
                        readyRestartTapped()
                        generateAnswers()
                    } label: {
                        Image("penguin")
                           
                    }
                    .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 0, z: 1))
                    .animation(.spring(), value: gameActive)
                    
                    Text(gameActive ? "Restart" : "Ready")
                        .font(.system(size: 40))

                }
            }
            .textStyle()
            
            //HOME VIEW
            if gameActive == false {
                VStack {
                    Stepper("xTable: \(numSelected)", value: $numSelected, in: 2...12)
                    
                    Stepper("Rounds: \(roundsSelected)", value: $roundsSelected, in: 3...12, step: 3)
                        
                    
                }
                .textStyle()
                .font(.title)
                .padding(.horizontal, 50)
                .frame(width: 375, height: 150)
                .background(Color("Orange"))
                .clipShape(RoundedRectangle(cornerRadius: 60))
            }
                
            
            //GAME VIEW
            if gameActive {
                VStack(spacing: 40) {
                        
                        ForEach(0..<4) { index in
                            Button {
                                generateMultiplier()
                                answerCorrect(answer: choices[index])
                                generateAnswers()
                                
                                if rounds == roundsSelected {
                                    finalRound = true
                                }
                                
                            } label: {
                                Label("\(choices[index])", image: animals[index])
                                    .textStyle()
                                    .font(.system(size: 50))
                            }
                        }
                        
                    }
                    .frame(width: 250, height: 450)
                    .background(Color("Orange"))
                    .clipShape(RoundedRectangle(cornerRadius: 60))
                    .padding(.bottom, 50)
                    
            }
            
        }
        .alert("Game Over!", isPresented: $finalRound) {
            Button("New Game", action: newGame)
        } message: {
            Text("\(score) points/\(rounds) rounds")
        }
    }
    
    func generateMultiplier() {
        multiplier = multipliers[0]
        
        multipliers.removeFirst()
        
        print(multiplier)
    }
    
    func generateAnswers() {
        correctAnswer = numSelected * multiplier
        
        var answers: Set<Int> = [correctAnswer]
        
        for _ in 0...2 {
            var generatedNumber = generateNumber()
            while isDuplicate(set: answers, generatedNumber: generatedNumber) {
                generatedNumber = generateNumber()
            }
            
            answers.insert(generatedNumber)
        }
        
        choices = answers.shuffled()
    }
    
    func isDuplicate(set: Set<Int>, generatedNumber: Int) -> Bool {
        return set.contains(generatedNumber)
    }
    
    func generateNumber() -> Int {
        let newNumber: Int
            
            if numSelected == 2  {
                newNumber = Int.random(in: 0...24)
            } else if numSelected == 3 {
                newNumber = Int.random(in: 0...36)
            } else if numSelected == 4 {
                newNumber = Int.random(in: 0...48)
            } else if numSelected == 5 {
                newNumber = Int.random(in: 0...60)
            } else if numSelected == 6 {
                newNumber = Int.random(in: 0...72)
            } else if numSelected == 7 {
                newNumber = Int.random(in: 0...84)
            } else if numSelected == 8 {
                newNumber = Int.random(in: 0...96)
            } else if numSelected == 9 {
                newNumber = Int.random(in: 0...108)
            } else if numSelected == 10 {
                newNumber = Int.random(in: 0...120)
            } else if numSelected == 11 {
                newNumber = Int.random(in: 0...132)
            } else {
                newNumber = Int.random(in: 0...144)
            }
            
        return newNumber

    }
    
    func answerCorrect(answer: Int) {
        if answer == correctAnswer {
            score += 1
            
        }
        
        rounds += 1
        animals.shuffle()
    }
    
    func readyRestartTapped() {
        if gameActive == false {
            score = 0
            rounds = 0
            numSelected = 2
            roundsSelected = 3
            
            multipliers.removeAll()
            multipliers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].shuffled()
        }
        
        if gameActive == true {
            generateMultiplier()
        }
    }
    
    func newGame() {
        multipliers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].shuffled()
        score = 0
        rounds = 0
        finalRound = false
        gameActive = false
        rotation += 360
    }
    
}

extension View {
    func textStyle() -> some View {
        modifier(generalTextStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
