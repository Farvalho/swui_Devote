//
//  ListRowItemView.swift
//  Devote
//
//  Created by Fábio Carvalho on 01/09/2022.
//

import SwiftUI

struct ListRowItemView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var item: Item
    
    var body: some View {
        Toggle(isOn: $item.completion) {
            Text(item.task ?? "")
                .font(.system(.title, design: .rounded))
                .fontWeight(.heavy)
                .foregroundColor(item.completion ? .pink : .primary)
                .padding(.vertical, 12)
                .animation(.default, value: item.completion)
        }
        .onReceive(item.objectWillChange) { _ in
            if self.viewContext.hasChanges {
                try? self.viewContext.save()
            }
        }
        .toggleStyle(CheckboxStyle())
    }
}
