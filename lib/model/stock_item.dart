class Stock {
  double? cost;
  double? increasePercent;
  String? name;
  String? image;
  String? positiveText;
  String? negativeText;
  String? positiveArticle;
  String? negativeArticle;
  int? amount;

  Stock(
      {this.cost,
      this.increasePercent,
      this.name,
      this.image,
      this.amount,
      this.positiveText,
      this.negativeText,
      this.positiveArticle,
      this.negativeArticle});

  factory Stock.fromJson(Map<String, dynamic> parsedJson) {
    return Stock(
      cost: parsedJson['cost'] ?? "",
      increasePercent: parsedJson['increasePercent'] ?? "",
      name: parsedJson['name'] ?? "",
      image: parsedJson['image'] ?? "",
      positiveText: parsedJson['positiveText'] ?? "",
      negativeText: parsedJson['negativeText'] ?? "",
      positiveArticle: parsedJson['positiveArticle'] ?? "",
      negativeArticle: parsedJson['negativeArticle'] ?? "",
      amount: parsedJson['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "cost": cost,
      "increasePercent": increasePercent,
      "name": name,
      "image": image,
      "positiveText": positiveText,
      "negativeText": negativeText,
      "positiveArticle": positiveArticle,
      "negativeArticle": negativeArticle,
      "amount": amount
    };
  }
}
