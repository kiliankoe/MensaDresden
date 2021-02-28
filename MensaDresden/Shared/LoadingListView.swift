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
            VStack {
                Spacer()
                ProgressView()
                Spacer()
            }
        case .noData:
            VStack {
                Spacer()
                VStack {
                    Text(noDataMessage)
                        .padding(.bottom)
                    if noDataSubtitle != nil {
                        Text(noDataSubtitle!)
                    }
                    if showRetryOnNoData {
                        Button {
                            retryAction()
                        } label: {
                            Text("list.try-again")
                        }
                    }
                }
                .padding()
                Spacer()
            }
        case .failure(let error):
            VStack {
                Spacer()
                VStack {
                    Text(error.localizedDescription)
                        .padding(.bottom)
                    Button {
                        retryAction()
                    } label: {
                        Text("list.try-again")
                    }
                }
                .padding()
                Spacer()
            }
        case .success(let listValues):
            listView(listValues)
        }
    }
}

//struct LoadingListView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoadingListView()
//    }
//}
