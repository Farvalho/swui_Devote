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
    @State private var showNewTaskItem: Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        NavigationView {
            ZStack {
                //main view
                VStack {
                    //header
                    Spacer(minLength: 80)
                    //task button
                    Button(action: {
                        showNewTaskItem = true
                    }, label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        
                        Text("New task")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    })
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.pink, .blue]), startPoint: .leading, endPoint: .trailing)
                            .clipShape(Capsule())
                    )
                    .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
                    
                    //tasks
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
                
                //new task item
                if showNewTaskItem {
                    BlankView()
                        .onTapGesture() {
                            withAnimation() {
                                showNewTaskItem = false
                            }
                        }
                    
                    NewTaskItemView(isShowing: $showNewTaskItem)
                }
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
