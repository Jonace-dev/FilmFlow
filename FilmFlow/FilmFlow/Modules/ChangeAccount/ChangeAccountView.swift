
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
                
                LazyVGrid(columns: twoColumnGrid, spacing: 40) {
                    ForEach(usersChangeAccount, id: \.self) { user in
                        AccountCell(user: user)
                            .onTapGesture {
                                NavigationRouter.main.navigate(toPath: HomeWireframe.path, withParameters: [
                                    "user": user
                                ], replace: true)
                            }
                            
                    }
                }
            }
            .padding(.bottom, LayoutSpacing.max)
            .olaNavigationBar("¿Quien eres? Elige tu perfil", displayMode: .inline)
            .padding(.horizontal, LayoutSpacing.ultraMax)
        }
    }
}

struct ChangeAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeAccountWireframe().view
    }
}
