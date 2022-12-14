//
//  EmotionsManagementView.swift
//  EmoDiary
//
//  Created by Joey Xie on 2022/11/19.
//

import SwiftUI
import CoreData

struct EmotionsManagementView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"name", ascending: true)]) var emotions: FetchedResults<Emotion>
    
    @State var showingSheet = false
//    @State var showingSheetEdit = false
    
    @State private var searchQuery = ""
    
    @State var nameTemp:String = ""
    @State var emojiTemp:String = ""
    @State var infoTemp:String = "" 
    
    var body: some View {
        List{
            
            Section(header: Image(systemName: "tag")){
                ForEach(emotions){each in
                    
                    NavigationLink {
                        EmotionDetailView(emotion: each)
                    } label: {
                        EmotionLineView(emotion: each)
                        
                    }
//                    .swipeActions(edge: .leading, allowsFullSwipe:true) {
//                        Button {
//                            showingSheetEdit.toggle()
//                        } label: {
//                            Text("Edit")
//                        }.sheet(isPresented: $showingSheetEdit) {
//                            AddEmotionView(emotion:each ,editMode: true, showingSheet: $showingSheetEdit)
//                        }
//
//                    }
                    
                }
                .onDelete(perform: deleteItems)
            }
        }
        .searchable(text: $searchQuery)
        .onChange(of: searchQuery, perform: { newValue in
            emotions.nsPredicate = searchPredicate(query: newValue)
        })
        .navigationTitle("Emotions")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem (placement: .navigationBarTrailing) {
                Button {
                    showingSheet.toggle()
                } label: {
                    Image(systemName: "plus.app")
                }.sheet(isPresented: $showingSheet) {
                    AddEmotionView(editMode: false, showingSheet: $showingSheet)
                }
            }
        }
        
    }
    
    
    
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { emotions[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func searchPredicate(query:String) -> NSPredicate? {
        if query.isEmpty { return nil}
        return NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Emotion.name), query)
    }
}

struct EmotionsManagementView_Previews: PreviewProvider {
    static var previews: some View {
        EmotionsManagementView()
    }
}
