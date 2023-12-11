//
//  AccountCell.swift
//  FilmFlow
//
//  Created by Jonathan Onrubia Solis on 11/12/23.
//

import SwiftUI

struct AccountCell: View {
    
    let user: UserChangeAccount
    
    var body: some View {
        VStack {
            OLAImage(user.image, size: .large)
            Text(user.username)
                .font(.bold(size: 20))
                .foregroundStyle(Color.secondaryWhite)
        }
    }
}

#Preview {
    AccountCell(user: UserChangeAccount.getDefaultUsers().first!)
}
