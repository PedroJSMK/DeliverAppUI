//
//  Home.swift
//  DeliverAppUI
//
//  Created by PedroJSMK on 05/10/21.
//

import SwiftUI

struct Home: View {
    
    @StateObject var HomeModel = HomeViewModel()
    var body: some View {
        
        ZStack {
            VStack(spacing: 10) {
                HStack(spacing: 15) {
                    Button(action: {
                        withAnimation(.easeIn){HomeModel.showMenu.toggle()}
                    }, label: {
                        
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .foregroundColor(Color(.blue))
                    })
                    
                    Text(HomeModel.userLocation == nil ? "Localizando..." : "Delivery Para voce")
                        .foregroundColor(.black)
                    
                    Text(HomeModel.userAdress)
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(Color(.blue))
                    
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                }
                .padding([.horizontal,.top])
                
                Divider()
                
                HStack(spacing: 15){
                        Image(systemName: "magnifyinglass")
                            .font(.title2)
                            .foregroundColor(.gray)
                    
                    TextField("Buscar Comida", text: $HomeModel.search)
                
                }
                .padding(.horizontal)
                .padding(.top,15)
                
                Divider()
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack(spacing: 25){
                        ForEach(HomeModel.filtered){ item in
                            
                            // items view
                            ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                                   ItemView(item: item)
                                
                                
                                HStack {
                                    Text("Delivery Gratis")
                                        .foregroundColor(.white)
                                        .padding(.vertical,10)
                                        .padding(.horizontal)
                                        .background(Color(.systemPink))

                                    Spacer(minLength: 0)

                                    Button(action: {}, label: {
                                        Image(systemName: "plus")
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(Color(.systemPink))
                                            .clipShape(Circle())
                                        
                                    })
                                }
                                .padding(.trailing,10)
                                .padding(.top,10)
                             })
                            .frame(width: UIScreen.main.bounds.width - 30)

                        }

                    }
                    .padding(.top,10)
                    
                })
            }
            
            // side menu
            HStack {
                Menu(homeData: HomeModel)
                    // move efeito
                    .offset(x: HomeModel.showMenu ? 0 : -UIScreen.main.bounds.width / 1.6)
                
                Spacer(minLength: 0)
            }
            .background(Color.black.opacity(HomeModel.showMenu ? 0.3 : 0).ignoresSafeArea()
                            .onTapGesture(perform: {
                                withAnimation(.easeIn){HomeModel.showMenu.toggle()}
                            })
            )
            
            // pedir autorizacao de localizacao via configs
            if HomeModel.noLocation {
                Text("Por favor ative sua localizacao nas configuracoes")
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width - 100, height: 120)
                    .background(Color.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3).ignoresSafeArea())
            }
            
        }
        .onAppear(perform: {
            
            // location delegate
            HomeModel.locationManager.delegate = HomeModel
        })
        .onChange(of: HomeModel.search, perform: { value in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if value == HomeModel.search && HomeModel.search != "" {
                    
                    // Busca no db
                    HomeModel.filterData()
                }
            }
            
            if HomeModel.search == ""{
                // reset
                withAnimation(.linear){HomeModel.filtered = HomeModel.items}
            }
        })
    }
}

