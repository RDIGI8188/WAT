import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wat/Controller/Postdata/Addresscontroller.dart'; // Replace with actual path to your AddressFormController

class AddressFormPage extends StatefulWidget {
  const AddressFormPage({Key? key}) : super(key: key);

  @override
  _AddressFormPageState createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  final AddressFormController _controller = Get.put(AddressFormController());

  String description = '';
  List<File> images = [];

  @override
  void initState() {
    super.initState();
    print("Initializing AddressFormPage...");
    _fetchUserId();
    _fetchData();
  }

  Future<void> _fetchUserId() async {
    print("Fetching User ID...");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? userName = prefs.getString('user_name');

    print("Fetched User ID: $userId");
    print("Fetched User Name: $userName");

    setState(() {
      if (userId != null && userId.isNotEmpty) {
        _idController.text = userId;
      }
      if (userName != null && userName.isNotEmpty) {
        _usernameController.text = userName;
      }
    });
  }

  Future<void> _fetchData() async {
    print("Fetching data from SharedPreferences...");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    description = prefs.getString('description') ?? '';
    List<String> imagePaths = prefs.getStringList('images') ?? [];
    images = imagePaths.map((path) => File(path)).toList();

    print("Fetched Description: $description");
    print("Fetched Image Paths: $imagePaths");

    setState(() {});
  }

  Future<void> _getCurrentLocation() async {
    print("Getting current location...");
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print("Location service enabled: $serviceEnabled");
    if (!serviceEnabled) {
      _showLocationDialog();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    print("Initial Location Permission: $permission");
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print("Requested Location Permission: $permission");
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permission permanently denied.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Location permission permanently denied.')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(
        "Fetched Position: Lat ${position.latitude}, Lng ${position.longitude}");

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    print("Fetched Placemark: $place");

    setState(() {
      _locationController.text =
          "Lat: ${position.latitude}, Lng: ${position.longitude}";
      _cityController.text = place.locality ?? '';
      _pincodeController.text = place.postalCode ?? '';
      _addressController.text = [
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.postalCode,
        place.country
      ].where((e) => e != null && e.isNotEmpty).join(', ');
      _latitudeController.text = position.latitude.toString();
      _longitudeController.text = position.longitude.toString();
    });
  }

  void _showLocationDialog() {
    print("Showing location dialog...");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enable Location'),
          content: const Text(
              'Location services are disabled. Please enable location services to proceed.'),
          actions: [
            TextButton(
                onPressed: () {
                  print("Location dialog canceled.");
                  Navigator.pop(context);
                },
                child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                print("Opening location settings...");
                Geolocator.openLocationSettings();
                Navigator.pop(context);
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building AddressFormPage UI...");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address Details'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text('Enter Your Address Details',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(
                maxLines: 3,
                controller: _addressController,
                decoration: const InputDecoration(
                    hintText: 'Enter Address', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                    labelText: 'City', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _pincodeController,
                decoration: const InputDecoration(
                    labelText: 'Pincode', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your pincode';
                  }
                  if (value.length != 6) {
                    return 'Pincode should be 6 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getCurrentLocation,
                child: Text(_locationController.text.isEmpty
                    ? 'Fetch AutoFill Address'
                    : _locationController.text),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print("Form validated. Submitting form...");
                    _controller.submitForm(
                      _idController.text,
                      _usernameController.text,
                      description,
                      _addressController.text,
                      _latitudeController.text,
                      _longitudeController.text,
                      images,
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
