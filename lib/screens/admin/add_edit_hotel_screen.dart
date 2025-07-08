import 'package:flutter/material.dart';
import '../../models/hotel.dart';
import '../../services/database_helper.dart';

class AddEditHotelScreen extends StatefulWidget {
  final Hotel? hotel;

  AddEditHotelScreen({this.hotel});

  @override
  _AddEditHotelScreenState createState() => _AddEditHotelScreenState();
}

class _AddEditHotelScreenState extends State<AddEditHotelScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _location;
  late int _rating;
  late double _price;
  late String _availableDates;

  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (widget.hotel != null) {
      _name = widget.hotel!.name;
      _location = widget.hotel!.location;
      _rating = widget.hotel!.rating;
      _price = widget.hotel!.price;
      _availableDates = widget.hotel!.availableDates;
    } else {
      _name = '';
      _location = '';
      _rating = 1;
      _price = 0.0;
      _availableDates = '';
    }
  }

  void _saveHotel() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final hotel = Hotel(
        id: widget.hotel?.id,
        name: _name,
        location: _location,
        rating: _rating,
        price: _price,
        availableDates: _availableDates,
      );

      if (widget.hotel == null) {
        await dbHelper.insertHotel(hotel);
      } else {
        await dbHelper.updateHotel(hotel);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hotel == null ? 'Add Hotel' : 'Edit Hotel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Name cannot be empty' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _location,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) => value!.isEmpty ? 'Location cannot be empty' : null,
                onSaved: (value) => _location = value!,
              ),
              DropdownButtonFormField<int>(
                value: _rating,
                items: [1, 2, 3, 4, 5]
                    .map((label) => DropdownMenuItem(
                          child: Text(label.toString()),
                          value: label,
                        ))
                    .toList(),
                hint: Text('Rating'),
                onChanged: (value) {
                  setState(() {
                    _rating = value!;
                  });
                },
              ),
              TextFormField(
                initialValue: _price.toString(),
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Price cannot be empty' : null,
                onSaved: (value) => _price = double.parse(value!),
              ),
              TextFormField(
                initialValue: _availableDates,
                decoration: InputDecoration(labelText: 'Available Dates (YYYY-MM-DD,YYYY-MM-DD)'),
                validator: (value) => value!.isEmpty ? 'Available dates cannot be empty' : null,
                onSaved: (value) => _availableDates = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveHotel,
                child: Text('Save Hotel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}