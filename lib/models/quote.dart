class ClientInfo {
  String name;
  String address;
  String reference;

  ClientInfo({
    required this.name,
    required this.address,
    required this.reference,
  });
}

class LineItem {
  String productName;
  int quantity;
  double rate;
  double? discount;
  double taxPercentage;

  LineItem({
    required this.productName,
    required this.quantity,
    required this.rate,
    this.discount,
    required this.taxPercentage,
  });

  double get subtotal {
    final priceAfterDiscount = rate - (discount ?? 0);
    final baseAmount = priceAfterDiscount * quantity;
    final taxAmount = baseAmount * (taxPercentage / 100);
    return baseAmount + taxAmount;
  }
}

enum QuoteStatus { draft, sent, accepted, rejected }

class Quote {
  ClientInfo clientInfo;
  List<LineItem> items;
  DateTime createdAt;
  DateTime? updatedAt;
  QuoteStatus status;
  bool isTaxInclusive;

  Quote({
    required this.clientInfo,
    required this.items,
    DateTime? createdAt,
    this.updatedAt,
    this.status = QuoteStatus.draft,
    this.isTaxInclusive = false,
  }) : createdAt = createdAt ?? DateTime.now();

  double get subtotal =>
      items.fold(0, (previousValue, item) => previousValue + item.subtotal);

  double get grandTotal => subtotal;

  void addItem(LineItem item) {
    items.add(item);
    updatedAt = DateTime.now();
  }

  void removeItem(int index) {
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
      updatedAt = DateTime.now();
    }
  }
}
