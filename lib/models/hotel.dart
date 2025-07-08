class Hotel {
  int? id;
  String name;
  String location;
  int rating;
  double price;
  String availableDates;

  Hotel({this.id, required this.name, required this.location, required this.rating, required this.price, required this.availableDates});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'rating': rating,
      'price': price,
      'availableDates': availableDates,
    };
  }
}