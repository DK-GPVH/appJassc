import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jassc/models/deudas.dart';
import 'package:jassc/pages/cliente/inicio.dart';
import 'package:jassc/pages/login.dart';
import 'package:jassc/models/pagos.dart';

class PagosPage extends StatefulWidget {
  final String manzana;
  final String lote;
  final String suministro;

  PagosPage(this.manzana, this.lote, this.suministro, {Key? key})
      : super(key: key);
  @override
  _PagosPageState createState() => _PagosPageState();
}

class _PagosPageState extends State<PagosPage> {
  late Future<List<Pagos>> lista_pagos;
  Future<List<Pagos>> listarPagos() async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/propiedades/${manzana.text}/${lote.text}/${suministro.text}");
    var response = await http.get(url, headers: {
      "Content-type": "application/json",
      "Accept": "application/json",
    });
    String body = utf8.decode(response.bodyBytes);
    final data = jsonDecode(body);
    if (data["res"]) {
      var newurl = Uri.parse(
          "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/pagos/${data["propiedad"]["id"]}");
      var newresponse = await http.get(newurl, headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
      });

      List<Pagos> pagos = [];
      if (newresponse.statusCode == 200) {
        String newbody = utf8.decode(newresponse.bodyBytes);
        final newdata = jsonDecode(newbody);
        print(newdata);
        var propiedad_pagos = newdata["mensaje"];
        if (propiedad_pagos.length > 0) {
          for (var i = 0; i < propiedad_pagos.length; i++) {
            pagos.add(Pagos(
                propiedad_pagos[i]["created_at"].toString(),
                propiedad_pagos[i]["descripcion"],
                propiedad_pagos[i]["tipo_pago"].toString(),
                propiedad_pagos[i]["estado"].toString(),
                propiedad_pagos[i]["monto"].toString()));
          }
          return pagos;
        } else {
          print(response.body);
          throw Exception("No hay pagos que mostrar");
        }
      } else {
        throw Exception("Error al mostrar datos");
      }
    } else {
      throw Exception("Fallo");
    }
  }

  @override
  void initState() {
    super.initState();
    lista_pagos = listarPagos();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: lista_pagos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: _listadoPagos(snapshot.data)),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  List<Widget> _listadoPagos(data) {
    List<Widget> pagos = [];
    int iteracion = 0;

    Widget tipoPago(pago) {
      if (pago.tipo_pago == "1") {
        return Text(
          "Efectivo",
          style: TextStyle(
              color: Colors.green, fontSize: 14, fontWeight: FontWeight.w500),
        );
      } else if (pago.tipo_pago == "2") {
        return Text(
          "Transferencia",
          style: TextStyle(
              color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w500),
        );
      } else {
        return Text(
          "No reconocido",
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
        );
      }
    }

    Widget estadoPago(pago) {
      if (pago.estado == "0") {
        return Text(
          "Pago_Error",
          style: TextStyle(
              color: Colors.red, fontSize: 14, fontWeight: FontWeight.w500),
        );
      } else if (pago.estado == "1") {
        return Text(
          "Pago_Realizado",
          style: TextStyle(
              color: Colors.green, fontSize: 14, fontWeight: FontWeight.w500),
        );
      } else {
        return Text(
          "No reconocido",
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
        );
      }
    }

    for (var pago in data) {
      iteracion++;

      pagos.add(Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(vertical: 5),
        width: MediaQuery.of(context).size.width * 1,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Colors.blue.shade100,
            border: Border.all(width: 3, color: Colors.blue.shade900),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 2, color: Colors.black54)),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: Text(
                        iteracion.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    title: Text(DateFormat("yyyy-MM-dd HH:mm:ss")
                        .format(DateTime.parse(pago.fecha_pago))),
                    subtitle: Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: tipoPago(pago),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: estadoPago(pago),
                          )
                        ],
                      ),
                    ))),
            Container(
              width: MediaQuery.of(context).size.width * 0.15,
              alignment: Alignment.center,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.10,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1, color: Colors.black)),
                    child: IconButton(
                        onPressed: () {
                          showDetallesPago(pago);
                        },
                        icon: Icon(
                          Icons.remove_red_eye_rounded,
                          color: Colors.blue,
                          size: 25,
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      ));
    }
    return pagos;
  }

  void showDetallesPago(pago) {
    List<Widget> _listaFechasPago(fechas) {
      List<Widget> dates = [];
      fechas.split(",").map((String text) {
        dates.add(Text(
          text,
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
        ));
      }).toString();
      return dates;
    }

    final alert = AlertDialog(
      scrollable: true,
      title: Text(
          "Detalle Pago : ${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.parse(pago.fecha_pago))}"),
      content: Container(
        margin: EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Monto total : ${pago.monto}",
                style: TextStyle(
                    color: Colors.blue.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Divider(
              color: Colors.blue.shade800,
              height: 2,
              thickness: 2,
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Text(
              "Descripcion :",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                children: _listaFechasPago(pago.descripcion),
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          icon: Icon(Icons.cancel),
          label: Text("Cerrar"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext) {
          return alert;
        });
  }
}
