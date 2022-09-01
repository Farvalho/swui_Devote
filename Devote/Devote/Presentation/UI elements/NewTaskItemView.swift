//
//  NewTaskItemView.swift
//  Devote
//
//  Created by Fábio Carvalho on 01/09/2022.
//

import SwiftUI

struct NewTaskItemView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var task: String = ""
    @Binding var isShowing: Bool
    
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    
    var body: some View {
        VStack {
            Spacer()
    
            VStack(spacing: 16) {
                TextField("New task:", text: $task)
                    .padding()
                    .background(
                        Color(uiColor: .systemGray6)
                    )
                    .cornerRadius(10)
                    .foregroundColor(.pink)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                
                Button(action: {
                    addItem()
                }, label: {
                    Spacer()
                    Text("SAVE")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Spacer()
                })
                .padding()
                .foregroundColor(.white)
                .background(isButtonDisabled ? .blue : .pink)
                .cornerRadius(10)
                .disabled(isButtonDisabled)
                
            } //: VStack
            .padding(.horizontal)
            .padding(.vertical, 20)
            .background(.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.65), radius: 24)
            .frame(maxWidth: 640)
            
        } //: VStack
        .padding()
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
            isShowing = false
        }
    }
}

struct NewTaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskItemView(isShowing: .constant(true))
            .background(Color.gray.edgesIgnoringSafeArea(.all))
    }
}
