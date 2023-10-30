//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Héctor Manuel Sandoval Landázuri on 18/09/21.
//

import SwiftUI

let labels = [
    "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
    "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
    "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
    "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
    "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
    "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
    "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
    "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
    "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
    "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
    "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
]


struct MyImage: View {
    var image: String
    var body: some View {
    Image(image)
        .renderingMode(.original)
        .clipShape(Capsule())
        .overlay(Capsule()  .stroke(Color.black, lineWidth: 1))
        .shadow(color: .black, radius: 2)
        .accessibilityLabel(labels[image, default: "Unknown flag"])
        }
    }

struct Flag: Identifiable {
    let id = UUID()
    let country: String
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var score=0
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled().map(Flag.init)
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var alertMessage = ""
    @State private var animationAmount = 0.0
    @State private var animatedOpacity = 1.0
    
    func flagTapped(_ country: String) {
        if country == countries[correctAnswer].country {
            scoreTitle = "Correct"
            score+=1
            alertMessage="Your score is now \(score)"
            withAnimation {
                animationAmount += 360
                animatedOpacity = 0.25
            }
        } else {
            scoreTitle = "Wrong"
            alertMessage = "That flag is from  \(country)"
            score-=1
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        self.animatedOpacity = 1.0
    }
    
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack (spacing:30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer].country)
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                ForEach(countries.prefix(3)) { flag in
                    Group {
                        if flag.country == self.countries[self.correctAnswer].country {
                                Button  (action: {
                                self.flagTapped(flag.country)
                                }) {
                                    MyImage(image: flag.country)
                                }
                                .rotation3DEffect(.degrees(self.animationAmount), axis: (x: 0, y: 1, z: 0))
                        }else {
                            Button(action: {
                                self.flagTapped(flag.country)
                            }) {
                                MyImage(image: flag.country)   }
                            .opacity(self.animatedOpacity)
                       }
                    }
                }
                Text("Score: \(score)")
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
                Alert(title: Text(scoreTitle), message: Text(alertMessage), dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
