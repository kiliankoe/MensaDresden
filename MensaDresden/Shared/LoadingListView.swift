import SwiftUI

struct LoadingListView<ListValues, ListView: View>: View {
    var result: LoadingResult<ListValues>
    var noDataMessage: LocalizedStringKey
    var noDataSubtitle: String? = nil
    var retryAction: () -> Void
    var showRetryOnNoData = false
    var listView: (ListValues) -> ListView

    var body: some View {
        switch result {
        case .loading:
            return AnyView(
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            )
        case .noData:
            return AnyView(
                VStack {
                    Spacer()
                    VStack {
                        Text(noDataMessage)
                            .padding(.bottom)
                        if noDataSubtitle != nil {
                            Text(noDataSubtitle!)
                        }
                        if showRetryOnNoData {
                            Button(action: {
                                self.retryAction()
                            }, label: { Text("list.try-again") })
                        }
                    }
                    .padding()
                    Spacer()
                }
            )
        case .failure(let error):
            return AnyView(
                VStack {
                    Spacer()
                    VStack {
                        Text(error.localizedDescription)
                            .padding(.bottom)
                        Button(action: {
                            self.retryAction()
                        }, label: { Text("list.try-again") })
                    }
                    .padding()
                    Spacer()
                }
            )
        case .success(let listValues):
            return AnyView(
                listView(listValues)
            )
        }
    }
}

//struct LoadingListView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoadingListView()
//    }
//}
