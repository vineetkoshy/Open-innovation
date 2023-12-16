import 'package:flutter/material.dart';
import 'dart:math';

int basePrice = 200;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking Reservation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ParkingReservationPage(),
    );
  }
}

class ParkingReservationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parking Reservation'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.green], // Adjust colors as needed
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Do you want to reserve parking?',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserDetailsPage()),
                      );
                    },
                    child: Text('Yes'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MovieTicketPricePage(totalPrice: basePrice=200)),
                      );
                    },
                    child: Text('No'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orange, Colors.pink], // Adjust colors as needed
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please provide your details:',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'Car Registration Number'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReservationConfirmationPage()),
                  );
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReservationConfirmationPage extends StatefulWidget {
  @override
  _ReservationConfirmationPageState createState() =>
      _ReservationConfirmationPageState();
}

class _ReservationConfirmationPageState
    extends State<ReservationConfirmationPage> {
  final Random random = Random();
  bool additionalHours = false;
  int additionalHoursCount = 1;

  String generateRandomFloor() {
    return (random.nextInt(4) + 1).toString();
  }

  String generateRandomParkingSpot() {
    final String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final String floor = generateRandomFloor();
    final String spot = alphabet[random.nextInt(alphabet.length)] +
        (random.nextInt(9) + 1).toString().padLeft(2, '0');
    return 'Floor: $floor, Spot: $spot';
  }

  @override
  Widget build(BuildContext context) {
    String parkingDetails = generateRandomParkingSpot();

    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Confirmation'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple, Colors.blue], // Adjust colors as needed
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Parking has been reserved!',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Text(
                'Your Parking Details:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                parkingDetails,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        additionalHours = true;
                      });
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Reserve Additional Hours?'),
                            content: Text(
                                'Do you want to reserve the spot for additional hours?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false); // No
                                },
                                child: Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, true); // Yes
                                },
                                child: Text('Yes'),
                              ),
                            ],
                          );
                        },
                      ).then((result) {
                        if (result != null && result) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                AdditionalHoursPage(
                              count: additionalHoursCount,
                            ),
                          ).then((count) {
                            if (count != null) {
                              additionalHoursCount = count;
                              int totalPrice = basePrice + (additionalHoursCount * 20);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieTicketPricePage(totalPrice: totalPrice),
                                ),
                              );
                            }
                          });
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MovieTicketPricePage(totalPrice: basePrice=300)),
                          );
                        }
                      });
                    },
                    child: Text('Do you want to reserve additional hours?'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdditionalHoursPage extends StatefulWidget {
  final int count;

  AdditionalHoursPage({required this.count});

  @override
  _AdditionalHoursPageState createState() => _AdditionalHoursPageState();
}

class _AdditionalHoursPageState extends State<AdditionalHoursPage> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Additional Hours'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orange, Colors.pink], // Adjust colors as needed
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Select additional hours:',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_count > 1) {
                          _count--;
                        }
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  SizedBox(width: 20),
                  Text(
                    '$_count',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _count++;
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _count);
                },
                child: Text('Confirm Additional Hours'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieTicketPricePage extends StatelessWidget {
  final int totalPrice;

  MovieTicketPricePage({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Ticket Price'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.red, Colors.yellow], // Adjust colors as needed
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ticket price: $totalPrice Rs.',
                style: TextStyle(fontSize: 20),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('PAY'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
