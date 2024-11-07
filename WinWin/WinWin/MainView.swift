//
//  ContentView.swift
//  WinWin
//
//  Created by Developer on 25/09/2024.
//

import SwiftUI

struct MainView: View {
    
    let numbers = Array(1...49)
    
    @State var selected: Set<Int> = []
    @State var checking: Int = 0
    @State var winResult: String = ""
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 7)
    
    var body: some View {
        
        ZStack{
            Rectangle()
                .fill(Color.gray)
                .ignoresSafeArea()
            VStack{
                Text("Choose your number")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.white)
                LazyVGrid(columns: columns, spacing: 10){
                    ForEach(numbers, id: \.self){ number in
                        Text("\(number)")
                            .font(.title)
                            .frame(minWidth: 50, minHeight: 50)
                            .foregroundStyle(Color.white)
                            .background(checking == number ? Color.blue : (selected.contains(number) ? Color.cyan : Color.green))
                            .clipShape(Circle())
                            .onTapGesture {
                                toggleSelected(for: number)
                            }
                        
                        
                    }
                }
                .padding(10)
                Spacer()
                Text("\(winResult)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(minHeight: 20)
                    .foregroundStyle(Color.white)
                    .padding()
                
                Button(action: {
                    startSelection()
                }, label: {
                    Text("Start")
                        .font(.largeTitle)
                        .padding()
                        .fontWeight(.bold)
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                })
                Spacer(minLength: 100)
                
            }
        }
        
    }
    
    func startSelection(){
            winResult = ""
            var currentIndex = 0
            let totalNumbers = numbers.count
            let randomNum = Int.random(in: 1...49) // Generate random number at the start
            print("Random number to match: \(randomNum)")

            // Create a single timer
        _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
                if currentIndex < totalNumbers {
                    let number = self.numbers[currentIndex]
                    withAnimation {
                        self.checking = number
                    }
                    
                    if self.checking == randomNum {
                        if selected.contains(randomNum){
                            winResult = "You win"
                        }
                        else {
                            winResult = "You lose"
                        }
                        print("Match found! Stopping timer.")
                        timer.invalidate()
                        return
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation {
                            self.checking = 0
                        }
                    }

                    currentIndex += 1
                } else {
                    timer.invalidate()
                }
            }

    }
    
    func toggleSelected(for number: Int){
        if selected.contains(number) {
            selected.remove(number)
        } else {
            if selected.count < 1 {
                selected.insert(number)
            }
        }
    }
}


#Preview {
    MainView()
}
