import 'package:flutter/material.dart';
import 'package:jassc/models/dropdownCategorias.dart';
import 'package:jassc/models/dropdownClientes.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:jassc/models/listpropiedades.dart';
import 'package:http/http.dart' as http;
import 'package:jassc/pages/admin/inicio.dart';
import 'package:jassc/pages/login.dart';

class PropiedadesPageAdmin extends StatefulWidget {
  final String email;
  final String password;
  final String token;

  PropiedadesPageAdmin(this.email, this.password, this.token, {Key? key})
      : super(key: key);

  @override
  _PropiedadesPageAdminState createState() => _PropiedadesPageAdminState();
}

class _PropiedadesPageAdminState extends State<PropiedadesPageAdmin> {
  late Future<List<ListPropiedad>> lista_propiedades;
  Future<List<ListPropiedad>> getPropiedades() async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/listar-propiedades");
    try {
      List<ListPropiedad> propiedades = [];
      var response = await http.get(url, headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": 'Bearer $token'
      });

      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);

      for (var i = 0; i < data["data"].length; i++) {
        propiedades.add(ListPropiedad(
            data["data"][i]["id"].toString(),
            data["data"][i]["manzana"].toString(),
            data["data"][i]["lote"].toString(),
            data["data"][i]["zona"],
            data["data"][i]["nrodesuministro"],
            data["data"][i]["cliente_id"].toString(),
            data["data"][i]["categoria_id"].toString(),
            data["data"][i]["estado"].toString(),
            data["data"][i]["fecha_inscripcion"],
            data["data"][i]["fecha_adeudo"]));
      }
      return propiedades;
    } catch (e) {
      throw Exception("Error con la conexion");
    }
  }

  @override
  void initState() {
    super.initState();
    lista_propiedades = getPropiedades();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: lista_propiedades,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Propiedades",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800),
                        ),
                        ElevatedButton.icon(
                            onPressed: () {
                              _showNewForm();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shadowColor: Colors.blue.shade800),
                            icon: Icon(Icons.add_home_work_rounded),
                            label: Text("Nuevo"))
                      ],
                    ),
                  ),
                  Divider(
                    height: 10,
                    color: Colors.blue.shade800,
                    thickness: 2,
                    indent: 15,
                    endIndent: 15,
                  ),
                  Column(children: _listadoPropiedades(snapshot.data))
                ]));
          } else if (snapshot.hasError) {
            return Center(
              child: Text("ERROR"),
            );
          }
          return Center(
            child: Text("Cargando..."),
          );
        });
  }

  List<Widget> _listadoPropiedades(data) {
    List<Widget> propiedades = [];
    int i = 0;
    for (var propiedad in data) {
      i++;
      propiedades.add(Container(
        margin: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width * 1,
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
            color: Colors.blue.shade600,
            border: Border.all(width: 3, color: Colors.black45),
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
                      i.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.fade,
                    )),
                title: Text(
                  "LOTE: ${propiedad.lote}\nMANZANA: ${propiedad.manzana}\nZONA: ${propiedad.zona}",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "\nFecha ins.: ${propiedad.fechains}\nFecha adeudo: ${propiedad.fechaadeudo}",
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.15,
              alignment: Alignment.centerRight,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1, color: Colors.black)),
                    child: IconButton(
                      onPressed: () {
                        _detallePropiedad(context, propiedad.id);
                      },
                      icon: Icon(
                        Icons.remove_red_eye_rounded,
                        color: Colors.blue,
                        size: 30,
                      ),
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        border: Border.symmetric(
                            vertical:
                                BorderSide(width: 1, color: Colors.black))),
                    child: IconButton(
                        onPressed: () {
                          _editPropiedad(context, propiedad.id);
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 30,
                        )),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          border: Border.all(width: 1, color: Colors.black)),
                      child: IconButton(
                          onPressed: () {
                            _showDelete(propiedad.id, propiedad.manzana,
                                propiedad.lote, propiedad.zona);
                          },
                          icon: Icon(
                            Icons.delete_forever_rounded,
                            color: Colors.white,
                            size: 30,
                          )))
                ],
              ),
            )
          ],
        ),
      ));
    }
    return propiedades;
  }

  void _detallePropiedad(context, id) async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/listar-propiedades/$id");
    try {
      var response = await http.get(url, headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      });
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);

      if (data["res"]) {
        print(data);
        _showDatos(context, data);
      } else {
        _showUnathorized;
      }
    } catch (e) {
      _showError;
    }
  }

  Future<String> _usuario(data) async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/listar-clientes/" +
            data["data"]["cliente_id"].toString());
    try {
      var response = await http.get(url, headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      });
      String body = utf8.decode(response.bodyBytes);
      final dataUser = jsonDecode(body);

      if (dataUser["res"]) {
        print(dataUser);
        return "${dataUser["data"]["nombre"].toString()}  ${dataUser["data"]["apellidop"].toString()}  ${dataUser["data"]["apellidom"].toString()}";
      } else {
        return "Usuario no identificado";
      }
    } catch (e) {
      return "Error con la conexion";
    }
  }

  Future<String> _categoria(data) async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/listar-categorias/" +
            data["data"]["categoria_id"].toString());
    try {
      var response = await http.get(url, headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      });
      String body = utf8.decode(response.bodyBytes);
      final dataUser = jsonDecode(body);

      if (dataUser["res"]) {
        return dataUser["data"]["descripcion"].toString();
      } else {
        return "Categoria no identificada";
      }
    } catch (e) {
      return "Error con la conexion";
    }
  }

  void _showDatos(context, data) {
    var user = _usuario(data);
    var categoria = _categoria(data);
    final alert = AlertDialog(
        scrollable: true,
        title: Text("Datos Propiedad " + data["data"]["id"].toString()),
        content: Container(
            alignment: Alignment.topLeft,
            child: Column(children: [
              Container(
                alignment: Alignment.topLeft,
                child: Wrap(
                  children: [
                    Text(
                      "MANZANA : ${data["data"]["manzana"].toString()}",
                      style: TextStyle(
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    Text(
                      "LOTE : ${data["data"]["lote"].toString()}",
                      style: TextStyle(
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    Text(
                      "ZONA : ${data["data"]["zona"]}",
                      style: TextStyle(
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Divider(
                height: 10,
                color: Colors.blue.shade800,
                thickness: 2,
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Container(
                alignment: Alignment.centerLeft,
                child: FutureBuilder(
                    future: user,
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        return Text("Usuario : " + snapshot.data.toString());
                      } else if (snapshot.hasError) {
                        return Text(snapshot.hasError.toString());
                      }
                      return Text("Usuario : Cargando....");
                    }),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  child: FutureBuilder(
                      future: categoria,
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                              "Categoria : " + snapshot.data.toString());
                        } else if (snapshot.hasError) {
                          return Text(snapshot.hasError.toString());
                        }
                        return Text("Categoria : Cargando...");
                      })),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                    "Fecha insc. : ${data["data"]["fecha_inscripcion"].toString()}"),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      "Fecha de adeudo : ${data["data"]["fecha_adeudo"].toString()}"))
            ])),
        actions: <Widget>[
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

  void _showUnathorized(BuildContext context) {
    final alert = AlertDialog(title: Text("No authorizado"), actions: <Widget>[
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

  void _editPropiedad(context, id) async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/listar-propiedades/$id");
    try {
      var response = await http.get(url, headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      });
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);

      if (data["res"]) {
        print(data);
        _showEditForm(data);
      } else {
        _showUnathorized;
      }
    } catch (e) {
      _showError;
    }
  }

  var selectedCategoria;
  var selectedCliente;
  var selectedActivo;
  var dateInscripcion;
  var dateDeuda;
  var manzanaForm;
  var loteForm;
  var zonaForm;
  var suministroForm;

  void _showEditForm(data) {
    manzanaForm =
        TextEditingController(text: data["data"]["manzana"].toString());
    loteForm = TextEditingController(text: data["data"]["lote"].toString());
    zonaForm = TextEditingController(text: data["data"]["zona"]);
    suministroForm =
        TextEditingController(text: data["data"]["nrodesuministro"]);
    selectedCategoria = data["data"]["categoria_id"];
    selectedCliente = data["data"]["cliente_id"];
    selectedActivo = data["data"]["estado"];

    dateInscripcion = DateTime.parse(data["data"]["fecha_inscripcion"]);
    dateDeuda = DateTime.parse(data["data"]["fecha_adeudo"]);
    Future<DateTime?> getDatePickerInscripcionWidget() {
      return showDatePicker(
        context: context,
        initialDate: dateInscripcion,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );
    }

    Future<DateTime?> getDatePickerDeudaWidget() {
      return showDatePicker(
        context: context,
        initialDate: dateDeuda,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );
    }

    void callDatePicker(state) async {
      var selectedDate = await getDatePickerInscripcionWidget();
      state(() {
        print(selectedDate.toString());
        dateInscripcion = selectedDate;
      });
    }

    void callDateDeudaPicker(state) async {
      var selectedDate = await getDatePickerDeudaWidget();
      state(() {
        print(selectedDate.toString());
        dateDeuda = selectedDate;
      });
    }

    final alert = AlertDialog(
        scrollable: true,
        title: Text("Editar Propiedad " + data["data"]["id"].toString()),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter state) {
            var _setstate = state;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Manzana',
                          icon: Icon(Icons.edit_road_rounded),
                          iconColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Colors.yellow.shade800;
                            }
                            return Colors.blue.shade800;
                          })),
                      controller: manzanaForm,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Lote',
                          icon: Icon(Icons.rounded_corner_rounded),
                          iconColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Colors.yellow.shade800;
                            }
                            return Colors.blue.shade800;
                          })),
                      controller: loteForm,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Zona',
                          icon: Icon(Icons.location_city_rounded),
                          iconColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Colors.yellow.shade800;
                            }
                            return Colors.blue.shade800;
                          })),
                      controller: zonaForm,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Suministro',
                          icon: Icon(Icons.waves_rounded),
                          iconColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Colors.yellow.shade800;
                            }
                            return Colors.blue.shade800;
                          })),
                      controller: suministroForm,
                    ),
                    FutureBuilder<List<DropdownCategoriasModel>>(
                        future: _dropcategorias(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return DropdownButtonFormField(
                                decoration: InputDecoration(
                                    labelText: 'Categoria',
                                    icon: Icon(
                                        Icons.local_convenience_store_rounded),
                                    iconColor: MaterialStateColor.resolveWith(
                                        (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.focused)) {
                                        return Colors.yellow.shade800;
                                      }
                                      return Colors.blue.shade800;
                                    })),
                                value: selectedCategoria,
                                items: snapshot.data!.map((e) {
                                  return DropdownMenuItem(
                                    value: e.id,
                                    child: Text(e.descripcion),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  selectedCategoria = value;
                                  setState(() {
                                    selectedCategoria;
                                    print(selectedCategoria);
                                  });
                                });
                          } else if (snapshot.hasError) {
                            return Text("Error ${snapshot.error}");
                          }
                          return const CircularProgressIndicator();
                        }),
                    FutureBuilder<List<DropdownClientesModel>>(
                        future: _dropClientes(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return DropdownButtonFormField(
                                decoration: InputDecoration(
                                    labelText: 'Documento del cliente',
                                    icon: Icon(Icons.account_box_rounded),
                                    iconColor: MaterialStateColor.resolveWith(
                                        (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.focused)) {
                                        return Colors.yellow.shade800;
                                      }
                                      return Colors.blue.shade800;
                                    })),
                                value: selectedCliente,
                                items: snapshot.data!.map((e) {
                                  return DropdownMenuItem(
                                    value: e.id,
                                    child: Text(e.documento),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  selectedCliente = value;
                                  setState(() {
                                    selectedCliente;
                                    print(selectedCliente);
                                  });
                                });
                          } else if (snapshot.hasError) {
                            return Text("Error : ${snapshot.error}");
                          }
                          return const CircularProgressIndicator();
                        }),
                    DropdownButtonFormField(
                        decoration: InputDecoration(
                            labelText: 'Estado',
                            icon: Icon(Icons.compare_rounded),
                            iconColor: MaterialStateColor.resolveWith(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.focused)) {
                                return Colors.yellow.shade800;
                              }
                              return Colors.blue.shade800;
                            })),
                        value: selectedActivo,
                        items: [
                          DropdownMenuItem(
                            child: Text("Activo"),
                            value: 1,
                          ),
                          DropdownMenuItem(
                            child: Text("Inactivo"),
                            value: 0,
                          )
                        ],
                        onChanged: (value) {
                          selectedActivo = value;
                          setState(() {
                            selectedActivo;
                            print(selectedActivo);
                          });
                        }),
                    Text("Fecha inscripcion"),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            callDatePicker(_setstate);
                          },
                          icon: const Icon(
                            Icons.edit_calendar_rounded,
                            color: Colors.blue,
                          ),
                        ),
                        Text(DateFormat("yyyy-MM-dd").format(dateInscripcion))
                      ],
                    ),
                    Text("Fecha de adeudo"),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            callDateDeudaPicker(_setstate);
                          },
                          icon: const Icon(
                            Icons.calendar_month_rounded,
                            color: Colors.blue,
                          ),
                        ),
                        Text(DateFormat("yyyy-MM-dd").format(dateDeuda))
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        actions: <Widget>[
          ElevatedButton.icon(
            onPressed: () {
              _actualizarPropiedad(
                  data["data"]["id"],
                  manzanaForm.text,
                  loteForm.text,
                  zonaForm.text,
                  suministroForm.text,
                  selectedActivo,
                  dateInscripcion,
                  dateDeuda,
                  selectedCliente,
                  selectedCategoria);
            },
            icon: Icon(Icons.save_rounded),
            label: Text("Guardar"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            icon: Icon(Icons.cancel),
            label: Text("Cerrar"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ]);

    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  void _showDelete(id, manzana, lote, zona) {
    final alert = AlertDialog(
        scrollable: true,
        actions: <Widget>[
          ElevatedButton.icon(
            onPressed: () {
              _eliminarPropiedad(id);
            },
            icon: Icon(
              Icons.check,
            ),
            label: Text("Aceptar"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            icon: Icon(Icons.cancel),
            label: Text("Cancelar"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
        title: Text("Eliminar Propiedad"),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter state) {
            var _setstate = state;
            return Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Lote : ${lote.toString()}"),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Manzana : ${manzana.toString()}"),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Zona : ${zona.toString()}"),
                  )
                ],
              ),
            );
          },
        ));
    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  Future<List<DropdownCategoriasModel>> _dropcategorias() async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/listar-categorias");
    try {
      var response = await http.get(url, headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      });
      String body = utf8.decode(response.bodyBytes);
      var data = jsonDecode(body);
      if (data["res"]) {
        final lista = data["data"];
        List<DropdownCategoriasModel> categorias_list = [];
        for (var i = 0; i < lista.length; i++) {
          categorias_list.add(DropdownCategoriasModel(
            lista[i]["id"],
            lista[i]["descripcion"],
            lista[i]["monto_correspondiente"].toString(),
          ));
        }
        return categorias_list;
      } else {
        throw Exception("No hay categorias a mostrar");
      }
    } catch (e) {
      throw Exception("Fallo la conexion");
    }
  }

  Future<List<DropdownClientesModel>> _dropClientes() async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/listar-clientes");
    try {
      var response = await http.get(url, headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      });
      String body = utf8.decode(response.bodyBytes);
      var data = jsonDecode(body);
      if (data["res"]) {
        final lista = data["data"];
        List<DropdownClientesModel> clientes_list = [];
        for (var i = 0; i < lista.length; i++) {
          clientes_list.add(DropdownClientesModel(
            lista[i]["id"],
            lista[i]["nombre"],
            lista[i]["nrodocumento"],
          ));
        }
        return clientes_list;
      } else {
        throw Exception("No hay clientes a mostrar");
      }
    } catch (e) {
      throw Exception("Fallo la conexion");
    }
  }

  void _actualizarPropiedad(id, manzanaForm, loteForm, zonaForm, suministroForm,
      estado, inscripcion, adeudo, cliente, categoria) async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/actualizar-propiedad/${id.toString()}");
    try {
      var response = await http.put(url,
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode({
            "manzana": manzanaForm,
            "lote": loteForm,
            "zona": zonaForm,
            "numero_suministro": suministroForm,
            "estado": estado,
            "fecha_inscripcion":
                DateFormat("yyyy-MM-dd").format(dateInscripcion),
            "fecha_adeudo": DateFormat("yyyy-MM-dd").format(dateDeuda),
            "cliente_id": (cliente != null) ? cliente : null,
            "categoria_id": (categoria != null) ? categoria : null,
          }));
      if (response.statusCode == 200) {
        print("Agregado correctamente");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text("Propiedad actualizada correctamente"),
                  scrollable: true,
                  actions: <Widget>[
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => InicioAdmin(
                                    email.text, password.text, token)),
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
        print("error de respuesta");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text(
                      "Error al actualizar propiedad verifique los datos e intentelo de nuevo"),
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
      print(e);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(
                    "Error en la conexion con el servidor intentelo mas tarde"),
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

  void _eliminarPropiedad(id) async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/eliminar-propiedad/${id.toString()}");
    try {
      var response = await http.delete(url, headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      });
      if (response.statusCode == 200) {
        print("Eliminado correctamente");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text("Propiedad eliminada correctamente"),
                  scrollable: true,
                  actions: <Widget>[
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => InicioAdmin(
                                    email.text, password.text, token)),
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
        print("error de respuesta");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text(
                      "Error al eliminar propiedad verifique los datos e intentelo de nuevo"),
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
      print(e);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(
                    "Error en la conexion con el servidor intentelo mas tarde"),
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

  void _showNewForm() {
    selectedCategoria = null;
    selectedCliente = null;
    selectedActivo = 0;
    dateInscripcion = DateTime.now();
    dateDeuda = DateTime.now();
    manzanaForm = TextEditingController(text: "");
    loteForm = TextEditingController(text: "");
    zonaForm = TextEditingController(text: "");
    suministroForm = TextEditingController(text: "");
    dateInscripcion = DateTime.now();
    dateDeuda = DateTime.now();
    Future<DateTime?> getDatePickerInscripcionWidget() {
      return showDatePicker(
        context: context,
        initialDate: dateInscripcion,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );
    }

    Future<DateTime?> getDatePickerDeudaWidget() {
      return showDatePicker(
        context: context,
        initialDate: dateDeuda,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );
    }

    void callDatePicker(state) async {
      var selectedDate = await getDatePickerInscripcionWidget();
      state(() {
        print(selectedDate.toString());
        dateInscripcion = selectedDate;
      });
    }

    void callDateDeudaPicker(state) async {
      var selectedDate = await getDatePickerDeudaWidget();
      state(() {
        print(selectedDate.toString());
        dateDeuda = selectedDate;
      });
    }

    final alert = AlertDialog(
        scrollable: true,
        title: Text("Nueva Propiedad"),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter state) {
            var _setstate = state;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Manzana',
                          icon: Icon(Icons.edit_road_rounded),
                          iconColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Colors.yellow.shade800;
                            }
                            return Colors.blue.shade800;
                          })),
                      controller: manzanaForm,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Lote',
                          icon: Icon(Icons.rounded_corner_rounded),
                          iconColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Colors.yellow.shade800;
                            }
                            return Colors.blue.shade800;
                          })),
                      controller: loteForm,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Zona',
                          icon: Icon(Icons.location_city_rounded),
                          iconColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Colors.yellow.shade800;
                            }
                            return Colors.blue.shade800;
                          })),
                      controller: zonaForm,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Suministro',
                          icon: Icon(Icons.waves),
                          iconColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Colors.yellow.shade800;
                            }
                            return Colors.blue.shade800;
                          })),
                      controller: suministroForm,
                    ),
                    FutureBuilder<List<DropdownCategoriasModel>>(
                        future: _dropcategorias(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return DropdownButtonFormField(
                                decoration: InputDecoration(
                                    labelText: 'Categoria',
                                    icon: Icon(
                                        Icons.local_convenience_store_rounded),
                                    iconColor: MaterialStateColor.resolveWith(
                                        (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.focused)) {
                                        return Colors.yellow.shade800;
                                      }
                                      return Colors.blue.shade800;
                                    })),
                                value: selectedCategoria,
                                items: snapshot.data!.map((e) {
                                  return DropdownMenuItem(
                                    value: e.id,
                                    child: Text(e.descripcion),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  selectedCategoria = value;
                                  setState(() {
                                    selectedCategoria;
                                    print(selectedCategoria);
                                  });
                                });
                          } else if (snapshot.hasError) {
                            return Text("Error ${snapshot.error}");
                          }
                          return const CircularProgressIndicator();
                        }),
                    FutureBuilder<List<DropdownClientesModel>>(
                        future: _dropClientes(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return DropdownButtonFormField(
                                decoration: InputDecoration(
                                    labelText: 'Documento del cliente',
                                    icon: Icon(Icons.account_box_rounded),
                                    iconColor: MaterialStateColor.resolveWith(
                                        (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.focused)) {
                                        return Colors.yellow.shade800;
                                      }
                                      return Colors.blue.shade800;
                                    })),
                                value: selectedCliente,
                                items: snapshot.data!.map((e) {
                                  return DropdownMenuItem(
                                    value: e.id,
                                    child: Text(e.documento),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  selectedCliente = value;
                                  setState(() {
                                    selectedCliente;
                                    print(selectedCliente);
                                  });
                                });
                          } else if (snapshot.hasError) {
                            return Text("Error : ${snapshot.error}");
                          }
                          return const CircularProgressIndicator();
                        }),
                    DropdownButtonFormField(
                        decoration: InputDecoration(
                            labelText: 'Estado',
                            icon: Icon(Icons.compare_rounded),
                            iconColor: MaterialStateColor.resolveWith(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.focused)) {
                                return Colors.yellow.shade800;
                              }
                              return Colors.blue.shade800;
                            })),
                        value: selectedActivo,
                        items: [
                          DropdownMenuItem(
                            child: Text("Activo"),
                            value: 1,
                          ),
                          DropdownMenuItem(
                            child: Text("Inactivo"),
                            value: 0,
                          )
                        ],
                        onChanged: (value) {
                          selectedActivo = value;
                          setState(() {
                            selectedActivo;
                            print(selectedActivo);
                          });
                        }),
                    Text("Fecha inscripcion"),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            callDatePicker(_setstate);
                          },
                          icon: const Icon(
                            Icons.edit_calendar_rounded,
                            color: Colors.blue,
                          ),
                        ),
                        Text(DateFormat("yyyy-MM-dd").format(dateInscripcion))
                      ],
                    ),
                    Text("Fecha de adeudo"),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            callDateDeudaPicker(_setstate);
                          },
                          icon: const Icon(
                            Icons.calendar_month_rounded,
                            color: Colors.blue,
                          ),
                        ),
                        Text(DateFormat("yyyy-MM-dd").format(dateDeuda))
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        actions: <Widget>[
          ElevatedButton.icon(
            onPressed: () {
              _crearPropiedad(
                  manzanaForm.text,
                  loteForm.text,
                  zonaForm.text,
                  suministroForm.text,
                  selectedActivo,
                  dateInscripcion,
                  dateDeuda,
                  selectedCliente,
                  selectedCategoria);
            },
            icon: Icon(Icons.save_rounded),
            label: Text("Guardar"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            icon: Icon(Icons.cancel),
            label: Text("Cerrar"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ]);

    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  void _crearPropiedad(manzanaForm, loteForm, zonaForm, suministroForm, estado,
      inscripcion, adeudo, cliente, categoria) async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/crear-propiedad");
    try {
      var response = await http.post(url,
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode({
            "manzana": manzanaForm,
            "lote": loteForm,
            "zona": zonaForm,
            "numero_suministro": suministroForm,
            "estado": estado,
            "fecha_inscripcion":
                DateFormat("yyyy-MM-dd").format(dateInscripcion),
            "fecha_adeudo": DateFormat("yyyy-MM-dd").format(dateDeuda),
            "cliente_id": (cliente != null) ? cliente : null,
            "categoria_id": (categoria != null) ? categoria : null,
          }));
      if (response.statusCode == 201) {
        print("Agregado correctamente");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text("Propiedad agregada correctamente"),
                  scrollable: true,
                  actions: <Widget>[
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => InicioAdmin(
                                    email.text, password.text, token)),
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
        print("error de respuesta");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text(
                      "Error al agregar propiedad verifique los datos e intentelo de nuevo"),
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
      print(e);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(
                    "Error en la conexion con el servidor intentelo mas tarde"),
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
}
