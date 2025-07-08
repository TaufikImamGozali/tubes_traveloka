import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../models/hotel.dart';
import '../../models/user.dart';
import '../../services/database_helper.dart';
import '../../widgets/hotel_card.dart';
import 'booking_history_screen.dart';
import 'hotel_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  HomeScreen({required this.user});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper();
  late Future<List<Hotel>> _hotels;
  String _searchQuery = '';
  // Nanti tambahkan filter di sini

  @override
  void initState() {
    super.initState();
    _refreshHotels();
  }

  void _refreshHotels() {
    setState(() {
      _hotels = dbHelper.getHotels();
    });
  }

  List<Hotel> _filterHotels(List<Hotel> hotels) {
    if (_searchQuery.isEmpty) return hotels;
    return hotels.where((hotel) {
      final query = _searchQuery.toLowerCase();
      return hotel.name.toLowerCase().contains(query) ||
          hotel.location.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Halo, ${widget.user.username}!'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Theme.of(context).primaryColor, Theme.of(context).colorScheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.history),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookingHistoryScreen(user: widget.user)),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Cari hotel impianmu...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                ),
              ),
            ),
          ),
          FutureBuilder<List<Hotel>>(
            future: _hotels,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SliverFillRemaining(child: Center(child: Text('Tidak ada hotel tersedia.')));
              }

              final filteredHotels = _filterHotels(snapshot.data!);

              return AnimationLimiter(
                child: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: HotelCard(
                              hotel: filteredHotels[index],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HotelDetailScreen(
                                      hotel: filteredHotels[index],
                                      user: widget.user,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: filteredHotels.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Tampilkan dialog/bottom sheet untuk filter
        },
        child: Icon(Icons.filter_list),
      ),
    );
  }
}