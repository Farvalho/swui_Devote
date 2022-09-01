//
//  ContentView.swift
//  Devote
//
//  Created by Fábio Carvalho on 01/09/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State var task: String = ""
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    VStack(spacing: 16) {
                        TextField("New task:", text: $task)
                            .padding()
                            .background(
                                Color(uiColor: .systemGray6)
                            )
                            .cornerRadius(10)
                        
                        Button(action: {
                            addItem()
                        }, label: {
                            Spacer()
                            Text("SAVE")
                            Spacer()
                        })
                        .padding()
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(isButtonDisabled ? .gray : .pink)
                        .cornerRadius(10)
                        .disabled(isButtonDisabled)

                    }
                    .padding()
                    
                    List {
                        ForEach(items) { item in
                                NavigationLink {
                                    Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                                } label: {
                                    VStack(alignment: .leading) {
                                        Text(item.task ?? "")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                        
                                        Text(item.timestamp!, formatter: itemFormatter)
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                    }
                                }
                        } //: ForEach
                        .onDelete(perform: deleteItems)
                        
                    } //: List
                    .listStyle(InsetGroupedListStyle())
                    .shadow(color: .black.opacity(0.3), radius: 12)
                    .padding(.vertical, 0)
                    .frame(maxWidth:640)
                    
                } //: VStack
            } //: ZStack
            .navigationTitle("Daily tasks")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .background(BackgroundImageView())
            .background(backgroundGradient.ignoresSafeArea(.all))
            .onAppear() {
                UITableView.appearance().backgroundColor = UIColor.clear
            }
            
        } //: NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            task = ""
            hideKeyboard()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
