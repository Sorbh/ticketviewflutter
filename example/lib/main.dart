import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticketview/ticketview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter TicketView Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

bool _showTicketView = true;

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe3e3e3),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      _showTicketView = true;
                    });
                  },
                  child: Text('Ticket View'),
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      _showTicketView = false;
                    });
                  },
                  child: Text('Receipt View'),
                )
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(10),
                child: _showTicketView
                    ? _getTicketInfoView()
                    : _getTicketReceiptView(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getTicketInfoView() {
    return Center(
      child: Container(
        height: 160,
        margin: EdgeInsets.all(10),
        child: TicketView(
          child: Container(),
        ),
      ),
    );
  }

  Container ticketInfoWidget() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            'PROMO TICKET',
            style: GoogleFonts.poppins(color: Colors.black, fontSize: 16),
          ),
          Text(
            '\$10.00',
            style: GoogleFonts.poppins(
                color: Colors.red, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          Text(
            '120 Tickets Available',
            style: GoogleFonts.poppins(color: Colors.black, fontSize: 12),
          )
        ],
      ),
    );
  }

  int _ticketCount = 0;
  Container counterWidget() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: Colors.grey,
                size: 30,
              ),
              onPressed: () {
                if (_ticketCount > 0) {
                  setState(() {
                    _ticketCount--;
                  });
                }
              }),
          Expanded(
            child: Text(
              "$_ticketCount",
              // ticket.selectedTickets.value.toString(),
              maxLines: 1,
              softWrap: true,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.black, fontSize: 30),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                _ticketCount++;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _getTicketReceiptView() {
    return TicketView(
      backgroundPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      backgroundColor: Color(0xFF8F1299),
      contentPadding: EdgeInsets.symmetric(vertical: 24, horizontal: 0),
      drawArc: false,
      triangleAxis: Axis.vertical,
      borderRadius: 6,
      drawDivider: true,
      trianglePos: .5,
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'DRAKE',
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        Expanded(child: Container()),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Price: ',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              TextSpan(
                                text: '\$15.00',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14),
                    Text(
                      'VR Tickets, General Admission',
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Madison Square Garden, NY',
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: 14),
                    Text(
                      'November 30,2020, 7:00PM',
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 14),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Price: ',
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          TextSpan(
                            text: '\$15.00',
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                child: Image.asset('assets/qr_placeholder.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
