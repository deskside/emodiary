//
//  TodayView.swift
//  EmoDiary
//
//  Created by Joey Xie on 2022/11/15.
//

import SwiftUI
import CoreData

struct TodayView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "timestamp", ascending: false)]) var records: FetchedResults<Record>
    @FetchRequest(sortDescriptors: []) var emotions: FetchedResults<Emotion>
    
    @State private var showingAlerts = true
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State var showingSheet:Bool = false
    var body: some View {
        
        NavigationStack {
            ScrollView{
                LazyVStack{
                    
                    // MARK: Cover
                    ZStack(alignment: .bottomTrailing) {
                        Image("mountain")
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(contentMode: .fit)
                            .ignoresSafeArea()
                        
                        
                        Image("avatar")
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .frame(width: 75, height: 75)
                            .padding()
                            .offset(x: 0, y: 30)
                    }
                    .padding(.bottom, 15)
                    
                    // MARK: OneTouch
                    OneTouchView()
                    
                    // MARK: Records
                    Group {
                        ForEach(records){ each in
                            NavigationLink{
                                TestView()
                            } label: {
                                
                                RecordLineView(record: each)
                                
                            }
                        }
                    }
                    Spacer()
                    
                }
            }
            .background(.secondarySystemBackground)
            .ignoresSafeArea()
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem {
                    Button {
                        showingSheet.toggle()
                    } label: {
                        Text("Add")
                    }.sheet(isPresented: $showingSheet) {
                        AddRecordView(showingSheet: $showingSheet)
                        
                    }
                }
            }
            
        }
    }}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
