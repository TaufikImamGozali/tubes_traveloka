import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/hotel.dart';
import '../models/booking.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'traveloka.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT,
        role TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE hotels(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        location TEXT,
        rating INTEGER,
        price REAL,
        availableDates TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE bookings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        hotel_id INTEGER,
        checkin_date TEXT,
        checkout_date TEXT,
        total_price REAL,
        FOREIGN KEY(user_id) REFERENCES users(id),
        FOREIGN KEY(hotel_id) REFERENCES hotels(id)
      )
    ''');
  }

  // Operasi untuk User
  Future<int> insertUser(User user) async {
    Database db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUser(String username, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (maps.isNotEmpty) {
      return User(
        id: maps[0]['id'],
        username: maps[0]['username'],
        password: maps[0]['password'],
        role: maps[0]['role'],
      );
    }
    return null;
  }

  // Operasi untuk Hotel
  Future<int> insertHotel(Hotel hotel) async {
    Database db = await database;
    return await db.insert('hotels', hotel.toMap());
  }

  Future<List<Hotel>> getHotels() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('hotels');
    return List.generate(maps.length, (i) {
      return Hotel(
        id: maps[i]['id'],
        name: maps[i]['name'],
        location: maps[i]['location'],
        rating: maps[i]['rating'],
        price: maps[i]['price'],
        availableDates: maps[i]['availableDates'],
      );
    });
  }
    Future<int> updateHotel(Hotel hotel) async {
    final db = await database;
    return await db.update(
      'hotels',
      hotel.toMap(),
      where: 'id = ?',
      whereArgs: [hotel.id],
    );
  }

  Future<int> deleteHotel(int id) async {
    final db = await database;
    return await db.delete(
      'hotels',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  // Operasi untuk Booking
  Future<int> insertBooking(Booking booking) async {
    Database db = await database;
    return await db.insert('bookings', booking.toMap());
  }

  Future<List<Booking>> getBookingsByUser(int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'bookings',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return Booking(
        id: maps[i]['id'],
        userId: maps[i]['user_id'],
        hotelId: maps[i]['hotel_id'],
        checkinDate: maps[i]['checkin_date'],
        checkoutDate: maps[i]['checkout_date'],
        totalPrice: maps[i]['total_price'],
      );
    });
  }
    Future<List<Map<String, dynamic>>> getAllBookings() async {
    final db = await database;
    final List<Map<String, dynamic>> bookings = await db.rawQuery('''
      SELECT 
        b.id AS booking_id,
        u.username,
        h.name AS hotel_name,
        b.checkin_date,
        b.checkout_date,
        b.total_price
      FROM bookings b
      JOIN users u ON b.user_id = u.id
      JOIN hotels h ON b.hotel_id = h.id
    ''');
    return bookings;
  }

}