class Booking {
  int? id;
  int userId;
  int hotelId;
  String checkinDate;
  String checkoutDate;
  double totalPrice;

  Booking({this.id, required this.userId, required this.hotelId, required this.checkinDate, required this.checkoutDate, required this.totalPrice});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'hotel_id': hotelId,
      'checkin_date': checkinDate,
      'checkout_date': checkoutDate,
      'total_price': totalPrice,
    };
  }
}