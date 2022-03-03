//
//  HomeView.swift
//  CalendarSelf
//
//  Created by Kyungyun Lee on 03/03/2022.
//

import SwiftUI

struct HomeView: View {
    
    @State var currentDate : Date = Date()
    
    var body: some View {
        ScrollView {
            VStack {
                CustomDatePicker(currentDate: $currentDate)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
