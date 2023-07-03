//
//  PKDarkThemeView.swift
//  PurchaseKit-Demo
//
//  Created by Apps4World on 8/17/20.
//  Copyright © 2020 Apps4World. All rights reserved.
//

import SwiftUI

struct PKDarkThemeView: View {
    
    @Environment(\.presentationMode) var presentationMode
    var title: String
    var subtitle: String
    var features: [String]
    var productIds: [String]
    
    var body: some View {
        VStack {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    Image("dark-header").resizable().aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: 350).clipped()
                    VStack {
                        Text(title).font(.largeTitle).bold()
                        Text(subtitle).font(.headline)
                    }.foregroundColor(.white).padding()
                    VStack {
                        ForEach(0..<features.count) { index in
                            HStack {
                                Image(systemName: "checkmark.circle").resizable()
                                    .frame(width: 25, height: 25).foregroundColor(.white)
                                Text(self.features[index]).font(.system(size: 22)).foregroundColor(.white)
                                Spacer()
                            }
                        }.padding(.leading, 30).padding(.trailing, 30)
                        
                        Spacer(minLength: 45)
                        
                        ForEach(0..<productIds.count) { index in
                            Button(action: {
                                
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 28.5).foregroundColor(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))).frame(height: 57)
                                    VStack {
//                                        Text(PKManager.formattedProductTitle(identifier: self.productIds[index])).foregroundColor(.white).bold()
//                                        if !PKManager.introductoryPrice(identifier: self.productIds[index]).isEmpty {
//                                            Text(PKManager.introductoryPrice(identifier: self.productIds[index]))
//                                                .font(.system(size: 13)).fontWeight(.light).foregroundColor(.white)
//                                        }
                                    }
                                }
                            })
                        }.padding(.leading, 30).padding(.trailing, 30).padding(.top, 10)
                    }.padding(.top, 40).padding(.bottom, 20)
                    
                    Button(action: {
//                        PKManager.restorePurchases { (error, status, id) in
//                            self.presentationMode.wrappedValue.dismiss()
//                            self.completion?((error, status, id))
//                        }
                    }, label: {
                        Text("Restore Purchases").foregroundColor(.white)
                    }).padding(.bottom, 50)
                }
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                            
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .accentColor(.black)
                                .frame(width: 32, height: 32)
                        })
                    }
                    Spacer()
                }.padding(20)
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.75), .black]), startPoint: .top, endPoint: .bottom))
        .edgesIgnoringSafeArea(.all)
    }
}
