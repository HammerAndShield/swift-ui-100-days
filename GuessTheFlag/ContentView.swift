//
//  ContentView.swift
//  Guess the Flag
//
//  Created by austin townsend on 5/25/25.
//

import SwiftUI

struct ContentView: View {
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScoreAlert = false
    @State private var showingResetAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var score = 0
    @State private var attempts = 0
    
    @State private var tappedFlag: Int? = nil
        
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            alertTitle = "Correct"
            alertMessage = "Good job, you got it right!"
            score += 1
        } else {
            alertTitle = "Wrong"
            alertMessage = "Wrong! That's the flag of \(countries[number])."
        }
        
        attempts += 1
        if attempts == 8 {
            alertTitle = "Game Over"
            alertMessage = "Your final score is \(score)/8."
            showingResetAlert = true
        } else {
            showingScoreAlert = true
        }
    }
    
    func askQuestion() {
        tappedFlag = nil
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetGame() {
        score = 0
        attempts = 0
        askQuestion()
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .titleStyle()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.largeTitle.weight(.semibold))
                            .foregroundStyle(.white)
                        
                        Text(countries[correctAnswer])
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            withAnimation() {
                                tappedFlag = number
                            }
                            flagTapped(number)
                        } label: {
                            FlagImage(country: countries[number])
                        }
                        .rotation3DEffect(Angle(degrees: tappedFlag == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                        .opacity(tappedFlag == nil || tappedFlag == number ? 1 : 0.25)
                        .scaleEffect(tappedFlag == nil || tappedFlag == number ? 1 : 0)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(alertTitle, isPresented: $showingScoreAlert) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(alertMessage)
        }
        .alert(alertTitle, isPresented: $showingResetAlert) {
            Button("Reset", action: resetGame)
        } message: {
            Text(alertMessage)
        }
    }
}

struct FlagImage: View {
    let country: String
    
    var body: some View {
        Image(country)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.weight(.bold))
            .foregroundStyle(.white)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

#Preview {
    ContentView()
}
