import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:jassc/models/deudas.dart';
import 'package:http/http.dart' as http;
import 'package:jassc/pages/cliente/inicio.dart';
import 'package:jassc/pages/login.dart';
import 'package:rive/rive.dart';
import 'package:pay/pay.dart';
import 'payment_config.dart';

class DeudasPage extends StatefulWidget {
  final String manzana;
  final String lote;
  final String suministro;

  DeudasPage(this.manzana, this.lote, this.suministro, {Key? key})
      : super(key: key);

  @override
  _DeudasPageState createState() => _DeudasPageState();
}

class _DeudasPageState extends State<DeudasPage> {
  late Future<List<Deudas>> listadoDeudas;
  Future<List<Deudas>> getDeudas() async {
    var url = Uri.parse(
        'https://phplaravel-1149125-3997241.cloudwaysapps.com/api/propiedades/${widget.manzana}/${widget.lote}/${widget.suministro}');
    final response = await http.get(url, headers: {
      "Content-type": "application/json",
      "Accept": "application/json"
    });
    List<Deudas> deudas = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);

      var propiedad_deudas = data["propiedad"]["deudas"];
      if (propiedad_deudas.length > 0) {
        for (var i = 0; i < propiedad_deudas.length; i++) {
          deudas.add(Deudas(
              i.toString(),
              data["propiedad"]["manzana"].toString(),
              data["propiedad"]["lote"].toString(),
              data["propiedad"]["zona"],
              data["propiedad"]["categoria"],
              data["propiedad"]["categoria_monto"].toString(),
              propiedad_deudas[i],
              data["propiedad"]["id"].toString()));
        }
        return deudas;
      } else {
        deudas.add(Deudas(
            "1",
            data["propiedad"]["manzana"].toString(),
            data["propiedad"]["lote"].toString(),
            data["propiedad"]["zona"],
            data["propiedad"]["categoria"],
            data["propiedad"]["categoria_monto"].toString(),
            "",
            ""));

        return deudas;
      }
    } else {
      throw Exception("Fallo conexion");
    }
  }

  @override
  void initState() {
    super.initState();
    listadoDeudas = getDeudas();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      FutureBuilder(
        future: listadoDeudas,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Center(
                      child: _listaDeudas(snapshot.data),
                    )));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error en los datos',
                style: TextStyle(color: Colors.blue),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      _pagar(),
    ]);
  }

  List<Deudas> _selectedDeudas = [];
  Widget _listaDeudas(data) {
    return SingleChildScrollView(
      child: ListBody(
          children: data.map<Widget>((deuda) {
        DateTime fecha = DateTime.parse(deuda.fecha);
        return new Container(
            margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: 3, color: Colors.green),
            ),
            child: CheckboxListTile(
                value: _selectedDeudas.contains(deuda),
                title: Text(
                  "De : ${deuda.fecha} \nHasta : ${fecha.year}-${fecha.month + 1}-${fecha.day}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Monto correspondiente : S/. ${deuda.monto}"),
                secondary: Icon(
                  Icons.monetization_on_rounded,
                  color: Colors.green,
                ),
                onChanged: (isChecked) => itemChange(deuda, isChecked!)));
      }).toList()),
    );
  }

  void _realizarPagos(
      propiedad, fecha, descripcion, tipo, estado, monto) async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/nuevo-pago");
    try {
      var response = await http.post(url,
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode({
            "propiedad_id": propiedad,
            "fecha_pago": fecha.toString(),
            "descripcion": descripcion,
            "tipo_pago": tipo,
            "estado_pago": estado,
            "monto": monto
          }));
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);

      if (response.statusCode == 201) {
        print(data);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text(data["mensaje"]),
                  scrollable: true,
                  actions: <Widget>[
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Inicio(
                                    manzana.text, lote.text, suministro.text)),
                            (route) => route.isFirst);
                      },
                      icon: Icon(Icons.save_rounded),
                      label: Text("Aceptar"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                    ),
                  ]);
            });
      } else {
        print("Error al agregar pago");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text(
                      "Error al registrar pago verifique los datos e intentelo de nuevo"),
                  scrollable: true,
                  actions: <Widget>[
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      icon: Icon(Icons.save_rounded),
                      label: Text("Aceptar"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                    ),
                  ]);
            });
      }
    } catch (e) {
      print("Error");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("Error con la conexion intentelo mas tarde"),
                scrollable: true,
                actions: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    icon: Icon(Icons.save_rounded),
                    label: Text("Aceptar"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ]);
          });
    }
  }

  void _showError(BuildContext context) {
    final alert = AlertDialog(title: Text("Error Coneccion"), actions: <Widget>[
      TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text('Cerrar'))
    ]);

    showDialog(
        context: context,
        builder: (BuildContext) {
          return alert;
        });
  }

  List<PaymentItem> detalles = [];
  List<String> fechas_pago = [];
  int metodo_pago = 2;
  int estado_pago = 1;

  Widget _pagar() {
    double total = 0;
    fechas_pago.clear();
    if (_selectedDeudas.length > 0) {
      for (var i = 0; i < _selectedDeudas.length; i++) {
        total = total + double.parse(_selectedDeudas[i].monto);
        fechas_pago.add(_selectedDeudas[i].fecha);
        detalles.add(PaymentItem(
          label: "Mes 1 : ${_selectedDeudas[i].fecha}",
          amount: _selectedDeudas[i].monto,
          status: PaymentItemStatus.final_price,
        ));
      }
      detalles.add(PaymentItem(
          label: "Total",
          amount: total.toString(),
          status: PaymentItemStatus.final_price));

      var applePayButton = ApplePayButton(
        paymentConfiguration:
            PaymentConfiguration.fromJsonString(defaultApplePay),
        paymentItems: detalles,
        style: ApplePayButtonStyle.black,
        width: 250,
        height: 50,
        type: ApplePayButtonType.buy,
        onPaymentResult: (result) => debugPrint("Resultad del pago $result"),
        loadingIndicator: const CircularProgressIndicator(),
      );

      var googlePayButton = GooglePayButton(
        paymentConfiguration:
            PaymentConfiguration.fromJsonString(defaultGooglePay),
        paymentItems: detalles,
        width: 250,
        height: 50,
        type: GooglePayButtonType.buy,
        onPaymentResult: (result) {
          if (result.isNotEmpty) {
            _realizarPagos(_selectedDeudas[0].propiedadId, DateTime.now(),
                fechas_pago, metodo_pago, estado_pago, total);
          } else {
            print("Pago no efectuado");
          }
        },
        loadingIndicator: const CircularProgressIndicator(),
      );

      return SizedBox(
          width: double.infinity,
          height: 100,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  border: Border.all(width: 3, color: Colors.black45),
                  color: Colors.blue.shade800),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      total.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
                    Container(
                      child:
                          (Platform.isIOS) ? applePayButton : googlePayButton,
                    )
                  ],
                ),
              )));
    }
    return ListTile();
  }

  void itemChange(Deudas deuda, bool selected) {
    setState(() {
      if (selected) {
        _selectedDeudas.add(deuda);
      } else {
        _selectedDeudas.remove(deuda);
      }
    });
  }
}
