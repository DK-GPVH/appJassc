import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jassc/models/propiedad.dart';
import 'package:rive/rive.dart';

class PropiedadPage extends StatefulWidget {
  final String manzana;
  final String lote;
  final String suministro;

  PropiedadPage(this.manzana, this.lote, this.suministro, {Key? key})
      : super(key: key);

  @override
  _PropiedadPageState createState() => _PropiedadPageState();
}

class _PropiedadPageState extends State<PropiedadPage> {
  late Future<ListPropiedad> obtener_propiedad;
  Future<ListPropiedad> getPropiedad() async {
    var url = Uri.parse(
        'https://phplaravel-1149125-3997241.cloudwaysapps.com/api/propiedades/${widget.manzana}/${widget.lote}/${widget.suministro}');
    final response = await http.get(url, headers: {
      "Content-type": "application/json",
      "Accept": "application/json"
    });

    ListPropiedad propiedad;
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      if (data["res"]) {
        int id = 1;
        int manzana = data["propiedad"]["manzana"];
        int lote = data["propiedad"]["lote"];
        int estado = data["propiedad"]["estado"];

        propiedad = ListPropiedad(
            id.toString(),
            manzana.toString(),
            lote.toString(),
            data["propiedad"]["zona"],
            data["propiedad"]["suministro"],
            data["propiedad"]["cliente"],
            data["propiedad"]["categoria"],
            estado.toString(),
            data["propiedad"]["inscripcion"],
            data["propiedad"]["cliente_dni"]);

        return propiedad;
      } else {
        throw Exception("Fallo la conexion");
      }
    } else {
      throw Exception("Fallo la conexion");
    }
  }

  @override
  void initState() {
    super.initState();
    obtener_propiedad = getPropiedad();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: obtener_propiedad,
        builder: (BuildContext context, AsyncSnapshot<ListPropiedad> snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: _contenedorPropiedad(snapshot.data),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

Widget _contenedorPropiedad(data) {
  return Card(
    clipBehavior: Clip.antiAlias,
    elevation: 2,
    child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            width: 350,
            child: Column(
              children: [
                Container(
                  width: 350,
                  height: 250,
                  child: Icon(
                    Icons.house_rounded,
                    size: 264,
                    color: Colors.green,
                  ),
                ),
                ListTile(
                  leading: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue.shade800),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            data.id,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.yellow),
                          ),
                        ),
                      )),
                  title: Text(data.categoria),
                  subtitle: Text("Inscrito el: ${data.fechains}"),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Row(children: [
                          Icon(Icons.local_hotel),
                          Text(
                            "Manzana : ${data.manzana}",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Row(children: [
                          Icon(Icons.local_hotel),
                          Text(
                            "Lote : ${data.lote}",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Row(children: [
                          Icon(Icons.local_hotel),
                          Text(
                            "Zona : ${data.zona}",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(2),
                        child: Text(
                          "Propietario : ${data.cliente}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2),
                        child: Text(
                          "Numero de documento : ${data.cliente_dni}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ))),
  );
}
