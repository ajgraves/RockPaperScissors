//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Aaron Graves on 3/13/24.
//

import SwiftUI

struct ContentView: View {
    // Array for all the choices
    private var choices: [String] = ["Rock", "Paper", "Scissors"]
    // What did the computer choose?
    @State private var computerMove: Int = Int.random(in: 0...2)
    // Should the user win or lose?
    @State private var userShouldWin: Bool = Bool.random()
    // User's score
    @State private var score: Int = 0
    // Number of rounds played
    @State private var rounds: Int = 0
    // Number of rounds that should be played
    let roundLimit: Int = 10
    // Are we showing the score alert?
    @State private var showingScore: Bool = false
    // Are we resetting the game progress?
    @State private var showingReset: Bool = false
    // scoreTitle shows the title on the score alert
    @State private var scoreTitle = ""
    // scoreMessage shows the score message
    @State private var scoreMessage = ""
    // Computed property to return the winning value
    var neededToWin: String {
        if(choices[computerMove] == "Rock") {
            return "Paper"
        } else if(choices[computerMove] == "Paper") {
            return "Scissors"
        } else {
            return "Rock"
        }
    }
    
    
    // Blue botton style for the choices
    struct BlueButton: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .fontWeight(.bold)
        }
    }
    
    var body: some View {
        ZStack {
            AngularGradient(gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .red]), center: .center, angle: .degrees(90))
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Rock Paper Scissors")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                
                Spacer()
                
                VStack(spacing: 15) {
                    HStack(spacing: 30) {
                        VStack {
                            Text("The app chose")
                                .font(.subheadline.weight(.heavy))
                            
                            Text(choices[computerMove])
                                .font(.largeTitle.weight(.semibold))
                        }
                        
                        VStack {
                            Text("And you should")
                                .font(.subheadline.weight(.heavy))
                            
                            Text(userShouldWin ? "WIN" : "LOSE")
                                .font(.largeTitle.weight(.semibold))
                        }
                    }
                    
                    Text("Make your choice")
                        .padding(30)
                        .font(.title.weight(.heavy))
                    
                    HStack {
                        ForEach(0..<3) { number in
                            Button {
                                buttonTap(choices[number])
                            } label: {
                                Text(choices[number])
                            }
                            .buttonStyle(BlueButton())
                            
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 30))
                .opacity(0.90)
                
                Spacer()
                
                Text("Score: \(score)")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Next", action: askQuestion)
        } message: {
            Text(scoreMessage)
        }
        .alert("Game over!", isPresented: $showingReset) {
            Button("Begin again", action: startOver)
        } message: {
            Text("You've completed \(roundLimit) rounds, your final score is \(score)")
        }
        
    }
    
    func buttonTap(_ choice: String) {
        // The user made a choice! Let's check it
        var userWins: Bool = false
        // Reset the score alert text
        scoreTitle = ""
        scoreMessage = ""
        // We just played a round, so count it!
        rounds += 1
        
        // Only check for cases where we need userWins to be true, because the default is false.
        if(choice == neededToWin && userShouldWin) {
            userWins = true
        }
        if(choice != neededToWin && userShouldWin == false) {
            userWins = true
        }
        // Last check, if user picked the same as computer, user loses
        if(choice == choices[computerMove]) {
            userWins = false
        }
        
        if userWins {
            score += 1
            scoreTitle = "Great job!"
            scoreMessage = "You chose correctly! You gained a point, your score is now \(score)"
        } else {
            score -= 1
            scoreTitle = "Oops!"
            scoreMessage = "That wasn't quite right. A point has been deducted, your new score is \(score)."
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        // We reset for the next question, triggered from the after-round alert
        computerMove = Int.random(in: 0...2)
        userShouldWin = Bool.random()
        
        // If we've completed the game, let's start over
        if(rounds >= roundLimit) {
            showingReset = true
        }
    }
    
    func startOver() {
        // We reset the game, after we've reached the configured number of rounds
        score = 0
    }
}

#Preview {
    ContentView()
}
