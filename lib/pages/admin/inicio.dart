import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jassc/pages/admin/categorias.dart';
import 'package:jassc/pages/admin/clientes.dart';
import 'package:jassc/pages/admin/propiedades.dart';
import 'package:jassc/pages/login.dart';

class InicioAdmin extends StatefulWidget {
  final String email;
  final String password;
  final String token;

  InicioAdmin(this.email, this.password, this.token, {Key? key})
      : super(key: key);

  @override
  _InicioAdminState createState() => _InicioAdminState();
}

class _InicioAdminState extends State<InicioAdmin> {
  int _currentIndex = 0;
  final List<Widget> pages = [
    PropiedadesPageAdmin(email.text, password.text, token),
    ClientesPageAdmin(email.text, password.text, token),
    CategoriasPageAdmin(email.text, password.text, token)
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'JASSC | ADMIN',
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              "JASSC | ADMIN",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                      icon: const Icon(Icons.exit_to_app_rounded),
                      color: Colors.white,
                      onPressed: () {
                        _logout(context);
                      }),
                ],
              )
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
                label: "Propiedades",
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person_add_alt_1_rounded,
                    color: Colors.blue.shade800,
                  ),
                  label: "clientes"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.category_rounded,
                    color: Colors.blue.shade800,
                  ),
                  label: "Categorias")
            ],
          ),
        ));
  }

  void onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

void _logout(context) async {
  var url = Uri.parse(
      "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/cierre-sesion");
  try {
    var response = await http.get(url, headers: {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    });
    String body = utf8.decode(response.bodyBytes);
    final data = jsonDecode(body);
    _cierreSesion(context);
  } catch (e) {
    _errorCierreSesion(context);
  }
}

void _cierreSesion(context) {
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(50.0))),
      builder: (context) {
        return SizedBox(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                children: [
                  ListTile(),
                  Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 55,
                    ),
                  ),
                  Center(
                    child: Text(
                      "Sesion Cerrada correctamente",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                  ),
                  ListTile(),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shadowColor: Colors.blue.shade800,
                          fixedSize: Size(250, 35)),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => LoginPage(),
                            ),
                            (route) => false);
                      },
                      child: Text("ACEPTAR"),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      });
}

void _errorCierreSesion(context) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Center(
            child: Wrap(
              children: [
                Center(
                  child: Icon(
                    Icons.error_rounded,
                    size: 30,
                    color: Colors.red,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Error al cerrar Sesion intentelo mas tarde",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
