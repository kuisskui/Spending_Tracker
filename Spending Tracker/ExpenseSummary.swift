import SwiftUI

struct ExpenseSummary: Identifiable {
    let id = UUID()
    var category: Category
    var count: Int16
    var totalAmount: Decimal
}
