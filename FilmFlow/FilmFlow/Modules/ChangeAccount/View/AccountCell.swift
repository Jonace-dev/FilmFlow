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
        VStack(spacing: 10) {
            OLAImage(user.image, size: .extraLarge)
                .clipShape(.rect(cornerRadius: 10))
            Text(user.username)
                .font(.regular(size: 18))
                .foregroundStyle(Color.secondaryWhite)
        }
    }
}

#Preview {
    AccountCell(user: UserChangeAccount.getDefaultUsers().first!)
}
