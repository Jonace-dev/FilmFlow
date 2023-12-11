
import SwiftUI

struct ChangeAccountView: View {
    
    @ObservedObject private var viewModel: ChangeAccountViewModel
    
    private var twoColumnGrid = [GridItem(), GridItem()]
    private var usersChangeAccount = UserChangeAccount.getDefaultUsers()
    
    init(viewModel: ChangeAccountViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color.backgroundDark.ignoresSafeArea(.all)
            VStack(alignment: .center) {
                
                LazyVGrid(columns: twoColumnGrid, spacing: 30) {
                    ForEach(usersChangeAccount, id: \.self) { user in
                        AccountCell(user: user)
                            .onTapGesture {
                                NavigationRouter.main.navigate(toPath: HomeWireframe.path, withParameters: [
                                    "user": user
                                ])
                            }
                            
                    }
                }
            }
            .padding(.horizontal, LayoutSpacing.max)
        }
    }
}

struct ChangeAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeAccountWireframe().view
    }
}
