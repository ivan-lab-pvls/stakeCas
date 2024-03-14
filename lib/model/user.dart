class UserItem {
  double? balance;

  UserItem({this.balance});

  factory UserItem.fromJson(Map<String, dynamic> parsedJson) {
    return UserItem(
      balance: parsedJson['balance'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "balance": balance,
    };
  }
}
