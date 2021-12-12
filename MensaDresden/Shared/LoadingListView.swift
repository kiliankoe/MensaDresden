import SwiftUI

struct LoadingListView<ListValues, ListView: View>: View where ListValues: RandomAccessCollection {
    var result: LoadingResult<ListValues>
    var noDataMessage: LocalizedStringKey
    var noDataSubtitle: String? = nil
    var retryAction: () -> Void
    var showRetryOnNoData = false
    var listView: (ListValues) -> ListView

    var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }

    var noDataView: some View {
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
    }

    func failureView(_ error: Error) -> some View {
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
    }

    var body: some View {
        switch result {
        case .loading:
            loadingView
        case .failure(let error):
            failureView(error)
        case .success(let listValues):
            if listValues.isEmpty {
                noDataView
            } else {
                listView(listValues)
            }
        }
    }
}

//struct LoadingListView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoadingListView()
//    }
//}
