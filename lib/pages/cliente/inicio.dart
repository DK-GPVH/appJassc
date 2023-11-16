import 'package:flutter/material.dart';
import 'package:jassc/pages/cliente/cliente.dart';
import 'package:jassc/pages/cliente/deudas.dart';
import 'package:jassc/pages/login.dart';
import 'package:jassc/pages/cliente/pagos.dart';
import 'package:jassc/pages/cliente/propiedad.dart';

class Inicio extends StatefulWidget {
  final String manzana;
  final String lote;
  final String suministro;

  Inicio(this.manzana, this.lote, this.suministro, {Key? key})
      : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _currentIndex = 0;
  final List<Widget> pages = [
    PropiedadPage(manzana.text, lote.text, suministro.text),
    DeudasPage(manzana.text, lote.text, suministro.text),
    PagosPage(manzana.text, lote.text, suministro.text)
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JASSC',
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'JASSC',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                Text(
                  'SALIR',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  color: Colors.white,
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => false,
                  ),
                ),
              ],
            ),
          ],
          backgroundColor: Colors.blue.shade800,
        ),
        body: pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onTapTapped,
          backgroundColor: Colors.white,
          fixedColor: Colors.blue.shade800,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.house_rounded,
                color: Colors.blue.shade800,
              ),
              label: 'Propiedad',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.date_range,
                color: Colors.blue.shade800,
              ),
              label: 'Deudas',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.monetization_on,
                color: Colors.blue.shade800,
              ),
              label: 'Pagos',
            ),
          ],
        ),
      ),
    );
  }

  void onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
