import 'package:flutter/material.dart';
import 'package:jassc/models/deudas.dart';
import 'package:rive/rive.dart';

class ClientePage extends StatefulWidget {
  final String manzana;
  final String lote;
  final String suministro;

  ClientePage(this.manzana, this.lote, this.suministro, {Key? key})
      : super(key: key);

  @override
  _ClientePageState createState() => _ClientePageState();
}

class _ClientePageState extends State<ClientePage> {
  late Future<Deudas> deuda;
  Future<Deudas> obtenerDeuda() async {
    Deudas deuda = Deudas('1', '2', '3', '1', '2', '3', '1', "2");
    return deuda;
  }

  @override
  void initState() {
    super.initState();
    deuda = obtenerDeuda();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: deuda,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: RiveAnimation.network(
                  'https://public.rive.app/community/runtime-files/113-173-loading-book.riv'),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error'),
            );
          }
          return Center(
              child: RiveAnimation.network(
                  'https://public.rive.app/community/runtime-files/69-98-loading.riv'));
        });
  }

  Widget _datosCliente(data) {
    return Text(data.lote);
  }
}
