import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jassc/pages/admin/inicio.dart';
import 'package:jassc/pages/cliente/inicio.dart';
import 'package:http/http.dart' as http;

import 'package:jassc/widgets/header.dart';
import 'package:jassc/widgets/logo.dart';

TextEditingController manzana = TextEditingController(text: "");
TextEditingController lote = TextEditingController(text: "");
TextEditingController suministro = TextEditingController(text: "");
TextEditingController email = TextEditingController(text: "");
TextEditingController password = TextEditingController(text: "");
String token = "";

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool selectlogin = true;
  @override
  Widget build(BuildContext context) {
    manzana = TextEditingController(text: "");
    lote = TextEditingController(text: "");
    suministro = TextEditingController(text: "");
    email = TextEditingController(text: "");
    password = TextEditingController(text: "");
    final MaterialStateProperty<Color?> trackColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.yellow.shade800;
        }
        return Colors.blue.shade800;
      },
    );
    final MaterialStateProperty<Color?> thumbColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.blue.shade800;
        }
        return Colors.yellow.shade800;
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.only(top: 0),
        physics: BouncingScrollPhysics(),
        children: [
          Stack(
            children: (selectlogin)
                ? [
                    HeaderLogin(),
                    LogoHeader(),
                  ]
                : [
                    HeaderLoginAdmin(),
                    LogoHeaderAdmin(),
                  ],
          ),
          Switch(
              trackColor: trackColor,
              thumbColor: thumbColor,
              value: selectlogin,
              onChanged: (bool value) {
                setState(() {
                  selectlogin = value;
                });
              }),
          (selectlogin) ? _Titulo() : _TituloAdmin(),
          SizedBox(height: 40),
          (selectlogin) ? _HouseDates() : _EmailAndPassword(),
          SizedBox(height: 40),
          (selectlogin) ? _BottonSignIn() : _BottonSignInAdmin(),
        ],
      ),
    );
  }
}

class _Titulo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: [
          Text(
            'INGRESAR',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          )
        ],
      ),
    );
  }
}

class _TituloAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: [
          Text(
            'ADMINISTRADOR',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.yellow.shade800,
            ),
          )
        ],
      ),
    );
  }
}

class _HouseDates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          TextField(
            controller: manzana,
            keyboardType: TextInputType.number,
            obscureText: false,
            decoration: InputDecoration(
              hintText: 'Manzana',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(
                Icons.house_rounded,
                color: Colors.blue.shade800,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(50),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black87),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: lote,
            keyboardType: TextInputType.number,
            obscureText: false,
            decoration: InputDecoration(
              hintText: 'Lote',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(
                Icons.house_outlined,
                color: Colors.blue.shade800,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(50),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black87),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: suministro,
            keyboardType: TextInputType.emailAddress,
            obscureText: false,
            decoration: InputDecoration(
              hintText: 'Suministro',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(
                Icons.water,
                color: Colors.blue.shade800,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(50),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black87),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmailAndPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            obscureText: false,
            decoration: InputDecoration(
              hintText: 'CORREO',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(
                Icons.person,
                color: Colors.yellow.shade800,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(50),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue.shade800),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          SizedBox(height: 40),
          TextField(
            controller: password,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: 'CONTRASENA',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(
                Icons.house_outlined,
                color: Colors.yellow.shade800,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(50),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue.shade800),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottonSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(25),
      decoration: BoxDecoration(
          color: Colors.blue.shade800, borderRadius: BorderRadius.circular(50)),
      child: TextButton(
        child: Text(
          'Ingresar',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        onPressed: () {
          if (suministro.text == "" || lote.text == "" || manzana.text == "") {
            _nulldata(context);
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        Inicio(manzana.text, lote.text, suministro.text)));
          }
        },
      ),
    );
  }
}

class _BottonSignInAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(25),
      decoration: BoxDecoration(
          color: Colors.yellow.shade800,
          borderRadius: BorderRadius.circular(50)),
      child: TextButton(
        child: Text(
          'Ingresar',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        onPressed: () {
          if (email.text == "" || password.text == "") {
            _nulldata(context);
          } else {
            _loguear(context);
            //Navigator.push(
            // context,
            // MaterialPageRoute(
            //   builder: (_) => AccesoPage(email.text, password.text)));
          }
        },
      ),
    );
  }
}

void _nulldata(context) {
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
                    "Por favor complete todo los cuadros para poder realizar la consulta",
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

void _loguear(context) async {
  var url = Uri.parse(
      "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/login");
  try {
    var response = await http.post(url,
        body: jsonEncode({"email": email.text, "password": password.text}),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json"
        });
    String body = utf8.decode(response.bodyBytes);
    final data = jsonDecode(body);

    if (data["res"]) {
      token = data["access_token"];
      print(data);
      _welcome(context, token);
    } else {
      _errorpassword(context);
    }
  } catch (e) {
    _erroruser(context);
  }
}

void _errorpassword(context) {
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
                    "Contrase;a incorrecta",
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

void _erroruser(context) {
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
                    "Usuario no encontrado intentelo mas tarde",
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

void _welcome(context, data) {
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
                      "Bienvenido",
                      style: TextStyle(
                          color: Colors.green,
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => InicioAdmin(
                                  email.text, password.text, data)));
                        },
                        child: Text("ACEPTAR")),
                  )
                ],
              )
            ],
          ),
        );
      });
}
