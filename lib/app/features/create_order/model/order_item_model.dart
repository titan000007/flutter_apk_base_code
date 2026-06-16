class OrderItem {
  final String itemType;
  final String title;
  final String description;
  final String amount;
  final String? link;
  final String? imageUrl;

  OrderItem({
    required this.itemType,
    required this.title,
     this.link,
    required this.description,
    required this.amount,
     this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'name': title,
    'des': description,
    'price': amount,
    'image': imageUrl,
    "link": link,
    "itemType": itemType,
  };
}
