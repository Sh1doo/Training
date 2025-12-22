//
//  TimerView.swift
//  Training
//
//  Created by 冨岡獅堂 on 2024/12/13.
//

import SwiftUI

struct TimerView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    dismiss()
                }){
                    HStack{
                        Image(systemName: "chevron.left.circle")
                            .foregroundStyle(Color.black100)
                        Text("戻る")
                            .foregroundStyle(Color.black100)
                    }
                    .padding()
                    .background(content: {
                        Rectangle()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(height: 40)
                            .foregroundStyle(Color.white20)
                            .shadow(color: .gray, radius: 15)
                    })
                }
                Spacer()
            }.padding()
            Text("00:00.00")
                .font(.system(size: 80))
                .foregroundStyle(Color.white)
            
            HStack {
                Button(action: {
                    //Action
                }){
                    Image(systemName: "pause.fill")
                        .modifier(TrainingMenuButtonStyle())
                }
                
                Button(action: {
                    //Action
                }){
                    Image(systemName: "play.fill")
                        .modifier(TrainingMenuButtonStyle())
                }
            }.padding()
            
            Spacer()
        }
        .background {
            Color.black.ignoresSafeArea()
        }
    }
}

#Preview {
    TimerView()
}
