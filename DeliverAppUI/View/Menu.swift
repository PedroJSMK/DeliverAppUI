//
//  Menu.swift
//  DeliverAppUI
//
//  Created by PedroJSMK on 05/10/21.
//

import SwiftUI

struct Menu: View {
    @ObservedObject var homeData : HomeViewModel
    var body: some View {
        
        VStack {
            Button(action: {}, label: {
                HStack(spacing: 15){
                   
                    Image(systemName: "cart")
                        .font(.title)
                        .foregroundColor(Color(.blue))
                    
                    Text("Carrinho")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer(minLength: 0)
                }
                .padding()
            })
            
            Spacer()
            
            HStack {
                Spacer()
                
                Text("Versao 1.0")
                    .fontWeight(.bold)
                    .foregroundColor(Color(.blue))
            }
            .padding(10)
        }
        .padding([.top,.trailing])
        .frame(width: UIScreen.main.bounds.width / 1.6)
        .background(Color.white.ignoresSafeArea())
    }
}

