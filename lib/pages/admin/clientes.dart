import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jassc/models/listclientes.dart';
import 'package:jassc/models/dropdownTipoDocumentos.dart';
import 'package:jassc/pages/admin/inicio.dart';
import 'package:jassc/pages/login.dart';
import 'package:flutter/services.dart';

class ClientesPageAdmin extends StatefulWidget {
  final String email;
  final String password;
  final String token;

  ClientesPageAdmin(this.email, this.password, this.token, {Key? key})
      : super(key: key);

  @override
  _ClientesPageAdminState createState() => _ClientesPageAdminState();
}

class _ClientesPageAdminState extends State<ClientesPageAdmin> {
  TextEditingController inputSearch = TextEditingController(text: "");
  late Future<List<ListCliente>> lista_clientes;
  Future<List<ListCliente>> getClientes() async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/listar-clientes");
    try {
      List<ListCliente> clientes = [];
      var response = await http.get(url, headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": 'Bearer $token'
      });

      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);

      for (var i = 0; i < data["data"].length; i++) {
        clientes.add(ListCliente(
          data["data"][i]["id"].toString(),
          data["data"][i]["nombre"],
          data["data"][i]["apellidop"],
          data["data"][i]["apellidom"],
          data["data"][i]["fechanac"],
          data["data"][i]["tipo_documento_id"].toString(),
          data["data"][i]["nrodocumento"],
          data["data"][i]["telefono"],
        ));
      }
      return clientes;
    } catch (e) {
      throw Exception("Error con la conexion");
    }
  }

  @override
  void initState() {
    super.initState();
    lista_clientes = getClientes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: lista_clientes,
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
                          "Clientes",
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
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: TextField(
                        controller: inputSearch,
                        decoration: InputDecoration(
                            hintText: "Buscar",
                            icon: Icon(
                              Icons.search_rounded,
                              color: Colors.blue.shade600,
                            ),
                            border: OutlineInputBorder(),
                            helperText: "Busqueda clientes"),
                        onChanged: (value) {
                          setState(() {});
                        },
                      )),
                  Divider(
                    height: 10,
                    color: Colors.blue.shade800,
                    thickness: 2,
                    indent: 15,
                    endIndent: 15,
                  ),
                  Column(
                      children:
                          _listadoClientes(snapshot.data, inputSearch.text))
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

  List<Widget> _listadoClientes(data, input) {
    List<Widget> clientes = [];
    var iteracion = 0;
    if (input.isNotEmpty) {
      for (var cliente in data) {
        if (cliente.nombre.toLowerCase().contains(input.toLowerCase()) ||
            cliente.apellidop.toLowerCase().contains(input.toLowerCase()) ||
            cliente.apellidom.toLowerCase().contains(input.toLowerCase()) ||
            cliente.nrodocumento.contains(input.toLowerCase())) {
          iteracion++;
          clientes.add(Container(
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
                            border:
                                Border.all(width: 2, color: Colors.black54)),
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
                      title: Text(
                        "${cliente.nombre} ${cliente.apellidop} ${cliente.apellidom}",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      subtitle: Text(
                        "Nro. documento : ${cliente.nrodocumento}\nTelefono : ${cliente.telefono}",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    )),
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
                              _detalleCliente(context, cliente.id);
                            },
                            icon: Icon(Icons.remove_red_eye_rounded,
                                color: Colors.blue, size: 30)),
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
                              _editClientes(context, cliente.id);
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
                              border:
                                  Border.all(width: 1, color: Colors.black)),
                          child: IconButton(
                              onPressed: () {
                                _showDelete(cliente.id,
                                    "${cliente.nombre} ${cliente.apellidop} ${cliente.apellidom}");
                              },
                              icon: Icon(
                                Icons.delete_forever_rounded,
                                color: Colors.white,
                                size: 30,
                              ))),
                    ],
                  ),
                )
              ],
            ),
          ));
        }
      }
    } else {
      for (var cliente in data) {
        iteracion++;
        clientes.add(Container(
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
                        iteracion.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    title: Text(
                      "${cliente.nombre} ${cliente.apellidop} ${cliente.apellidom}",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    subtitle: Text(
                      "Nro. documento : ${cliente.nrodocumento}\nTelefono : ${cliente.telefono}",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  )),
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
                            _detalleCliente(context, cliente.id);
                          },
                          icon: Icon(Icons.remove_red_eye_rounded,
                              color: Colors.blue, size: 30)),
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
                            _editClientes(context, cliente.id);
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
                              _showDelete(cliente.id,
                                  "${cliente.nombre} ${cliente.apellidop} ${cliente.apellidom}");
                            },
                            icon: Icon(
                              Icons.delete_forever_rounded,
                              color: Colors.white,
                              size: 30,
                            ))),
                  ],
                ),
              )
            ],
          ),
        ));
      }
    }
    return clientes;
  }

  void _detalleCliente(context, id) async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/listar-clientes/$id");
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

  Future<String> _tipoDocumento(data) async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/listar-tipo-documentos/" +
            data["data"]["tipo_documento_id"].toString());
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
        return dataUser["data"]["descripcion"].toString();
      } else {
        return "Error";
      }
    } catch (e) {
      return "Error";
    }
  }

  void _showDatos(context, data) {
    var tipoDocumento = _tipoDocumento(data);
    final alert = AlertDialog(
        scrollable: true,
        title: Text("Datos Cliente " + data["data"]["id"].toString()),
        content: Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.centerLeft,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  "${data["data"]["nombre"]}  ${data["data"]["apellidop"]}  ${data["data"]["apellidom"]}",
                  style: TextStyle(
                      color: Colors.blue.shade600,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Divider(
                height: 10,
                thickness: 2,
                color: Colors.blue.shade800,
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Container(
                alignment: Alignment.centerLeft,
                child: FutureBuilder(
                    future: tipoDocumento,
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          "Tipo de documento : ${snapshot.data}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        );
                      } else if (snapshot.hasError) {
                        return Text(snapshot.hasError.toString());
                      }
                      return Text("Tipo de documento : Cargando ...");
                    }),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Nro. de documento : ${data["data"]["nrodocumento"]}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Telefono : ${data["data"]["telefono"]}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
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

  void _editClientes(context, id) async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/listar-clientes/$id");
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

  var selectedTipoDocumento;
  var dateNacimiento;
  var apellido_paterno;
  var apellido_materno;
  var numero_documento;
  var telefono;
  var nombre;
  final _formKey = GlobalKey<FormState>();
  void _showEditForm(data) {
    nombre = TextEditingController(text: data["data"]["nombre"].toString());
    apellido_paterno = TextEditingController(text: data["data"]["apellidop"]);
    apellido_materno = TextEditingController(text: data["data"]["apellidom"]);
    numero_documento =
        TextEditingController(text: data["data"]["nrodocumento"]);
    telefono = TextEditingController(text: data["data"]["telefono"]);

    selectedTipoDocumento = data["data"]["tipo_documento_id"];

    dateNacimiento = DateTime.parse(data["data"]["fechanac"]);
    Future<DateTime?> getDatePickerNacimientoWidget() {
      return showDatePicker(
        context: context,
        initialDate: dateNacimiento,
        firstDate: DateTime(1900),
        lastDate: DateTime(2006),
      );
    }

    void callDatePicker(state) async {
      var selectedDate = await getDatePickerNacimientoWidget();
      state(() {
        print(selectedDate.toString());
        dateNacimiento = selectedDate;
      });
    }

    final alert = AlertDialog(
        scrollable: true,
        title: Text("Editar Cliente " + data["data"]["id"].toString()),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter state) {
            var _setstate = state;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Nombre',
                          icon: Icon(Icons.person_4_rounded),
                          iconColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Colors.yellow.shade800;
                            }
                            return Colors.blue.shade800;
                          })),
                      controller: nombre,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese datos';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))
                      ],
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Apellido paterno',
                          icon: Icon(Icons.person_rounded),
                          iconColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Colors.yellow.shade800;
                            }
                            return Colors.blue.shade800;
                          })),
                      controller: apellido_paterno,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese el texto';
                        } else {
                          int spaceCount = 0;
                          for (int i = 0; i < value.length; i++) {
                            if (value[i] == ' ') {
                              spaceCount++;
                            }
                            if (spaceCount > 1) {
                              return 'El texto no puede contener más de un espacio en blanco';
                            }
                          }
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Apellido materno',
                          icon: Icon(Icons.person_2_rounded),
                          iconColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Colors.yellow.shade800;
                            }
                            return Colors.blue.shade800;
                          })),
                      controller: apellido_materno,
                    ),
                    Text("Fecha de nacimiento"),
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
                        Text(DateFormat("yyyy-MM-dd").format(dateNacimiento))
                      ],
                    ),
                    FutureBuilder<List<DropdownTipoDocumentosModel>>(
                        future: _dropTipoDocumentos(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return DropdownButtonFormField(
                                decoration: InputDecoration(
                                    labelText: 'Documento del cliente',
                                    icon: Icon(Icons.assignment_ind_rounded),
                                    iconColor: MaterialStateColor.resolveWith(
                                        (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.focused)) {
                                        return Colors.yellow.shade800;
                                      }
                                      return Colors.blue.shade800;
                                    })),
                                value: selectedTipoDocumento,
                                items: snapshot.data!.map((e) {
                                  return DropdownMenuItem(
                                    value: e.id,
                                    child: Text(e.descripcion),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  selectedTipoDocumento = value;
                                  setState(() {
                                    selectedTipoDocumento;
                                    print(selectedTipoDocumento);
                                  });
                                });
                          } else if (snapshot.hasError) {
                            return Text("Error : ${snapshot.error}");
                          }
                          return const CircularProgressIndicator();
                        }),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Numero de documento',
                          icon: Icon(Icons.branding_watermark_rounded),
                          iconColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Colors.yellow.shade800;
                            }
                            return Colors.blue.shade800;
                          })),
                      onChanged: (value) {
                        int n;
                        if (selectedTipoDocumento == 2) {
                          n = 8;
                        } else if (selectedTipoDocumento == 1) {
                          n = 12;
                        } else {
                          n = 0;
                        }
                        if (value.length != n) {
                          numero_documento.text = value.substring(0, n);
                        }
                      },
                      validator: (value) {
                        int n;
                        if (selectedTipoDocumento == 2) {
                          n = 8;
                        } else if (selectedTipoDocumento == 1) {
                          n = 12;
                        } else {
                          n = 0;
                        }
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese datos';
                        } else if (value.length != n) {
                          return 'El dato debe tener $n caracteres';
                        }
                        return null;
                      },
                      controller: numero_documento,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Telefono',
                          icon: Icon(Icons.contact_phone_rounded),
                          iconColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Colors.yellow.shade800;
                            }
                            return Colors.blue.shade800;
                          })),
                      controller: telefono,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length != 9) {
                          return "Debe tener 9 caracteres";
                        } else if (!value.startsWith('9')) {
                          return 'El valor debe empezar por 9';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[1-9]')),
                      ],
                      keyboardType: TextInputType.number,
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
              if (_formKey.currentState!.validate()) {
                _editarCliente(
                    data["data"]["id"].toString(),
                    nombre.text,
                    apellido_paterno.text,
                    apellido_materno.text,
                    dateNacimiento,
                    selectedTipoDocumento,
                    numero_documento.text,
                    telefono.text);
              }
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

  void _editarCliente(id, nombre, apellidoP, apellidoM, nacimiento,
      tipoDocumento, numeroDocumento, telefono) async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/actualizar-cliente/$id");
    try {
      var response = await http.put(url,
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode({
            "nombre": nombre,
            "apellidop": apellidoP,
            "apellidom": apellidoM,
            "fecha_nacimiento": DateFormat("yyyy-MM-dd").format(nacimiento),
            "tipo_documento": tipoDocumento,
            "numero_documento": numeroDocumento,
            "telefono": telefono
          }));
      if (response.statusCode == 200) {
        print("Agregado correctamente");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text("Cliente actualizado correctamente"),
                  scrollable: true,
                  actions: <Widget>[
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => InicioAdmin(
                                  email.text, password.text, token)),
                          (route) => route.isFirst,
                        );
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
                      "Error al actualizar cliente verifique los datos e intentelo de nuevo"),
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

  Future<List<DropdownTipoDocumentosModel>> _dropTipoDocumentos() async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/listar-tipo-documentos");
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
        List<DropdownTipoDocumentosModel> tipo_documentos_list = [];
        for (var i = 0; i < lista.length; i++) {
          tipo_documentos_list.add(DropdownTipoDocumentosModel(
            lista[i]["id"],
            lista[i]["descripcion"],
          ));
        }
        return tipo_documentos_list;
      } else {
        throw Exception("No hay tipo de documentos a mostrar");
      }
    } catch (e) {
      throw Exception("Fallo la conexion");
    }
  }

  void _showNewForm() {
    dateNacimiento = DateTime(2004, 1, 1);
    nombre = TextEditingController(text: "");
    apellido_paterno = TextEditingController(text: "");
    apellido_materno = TextEditingController(text: "");
    numero_documento = TextEditingController(text: "");
    telefono = TextEditingController(text: "");
    Future<DateTime?> getDatePickerNacimientoWidget() {
      return showDatePicker(
        context: context,
        initialDate: dateNacimiento,
        firstDate: DateTime(1900),
        lastDate: DateTime(2006),
      );
    }

    void callDatePicker(state) async {
      var selectedDate = await getDatePickerNacimientoWidget();
      state(() {
        print(selectedDate.toString());
        dateNacimiento = selectedDate;
      });
    }

    final alert = AlertDialog(
        scrollable: true,
        title: Text("Nuevo Cliente"),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter state) {
            var _setstate = state;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Nombre',
                          icon: Icon(Icons.person_4_rounded),
                          iconColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Colors.yellow.shade800;
                            }
                            return Colors.blue.shade800;
                          })),
                      controller: nombre,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese datos';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))
                      ],
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Apellido Paterno',
                          icon: Icon(Icons.person_rounded),
                          iconColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Colors.yellow.shade800;
                            }
                            return Colors.blue.shade800;
                          })),
                      controller: apellido_paterno,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese el texto';
                        } else {
                          int spaceCount = 0;
                          for (int i = 0; i < value.length; i++) {
                            if (value[i] == ' ') {
                              spaceCount++;
                            }
                            if (spaceCount > 1) {
                              return 'El texto no puede contener más de un espacio en blanco';
                            }
                          }
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Apellido Materno',
                          icon: Icon(Icons.person_2_rounded),
                          iconColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Colors.yellow.shade800;
                            }
                            return Colors.blue.shade800;
                          })),
                      controller: apellido_materno,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese el texto';
                        } else {
                          int spaceCount = 0;
                          for (int i = 0; i < value.length; i++) {
                            if (value[i] == ' ') {
                              spaceCount++;
                            }
                            if (spaceCount > 1) {
                              return 'El texto no puede contener más de un espacio en blanco';
                            }
                          }
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))
                      ],
                    ),
                    Text("Fecha de nacimiento"),
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
                        Text(DateFormat("yyyy-MM-dd").format(dateNacimiento))
                      ],
                    ),
                    FutureBuilder<List<DropdownTipoDocumentosModel>>(
                        future: _dropTipoDocumentos(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(children: [
                              DropdownButtonFormField(
                                  decoration: InputDecoration(
                                      labelText: 'Tipo de documento',
                                      icon: Icon(Icons.assignment_ind_rounded),
                                      iconColor: MaterialStateColor.resolveWith(
                                          (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.focused)) {
                                          return Colors.yellow.shade800;
                                        }
                                        return Colors.blue.shade800;
                                      })),
                                  value: selectedTipoDocumento,
                                  items: snapshot.data!.map((e) {
                                    return DropdownMenuItem(
                                      value: e.id,
                                      child: Text(e.descripcion),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    selectedTipoDocumento = value;
                                    setState(() {
                                      selectedTipoDocumento = value;
                                      print(selectedTipoDocumento);
                                    });
                                  }),
                            ]);
                          } else if (snapshot.hasError) {
                            return Text("Error ${snapshot.error}");
                          }
                          return const CircularProgressIndicator();
                        }),
                    TextFormField(
                        maxLength: 12,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: 'Numero de Documento',
                            icon: Icon(Icons.branding_watermark_rounded),
                            iconColor: MaterialStateColor.resolveWith(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.focused)) {
                                return Colors.yellow.shade800;
                              }
                              return Colors.blue.shade800;
                            })),
                        onChanged: (value) {
                          int n;
                          if (selectedTipoDocumento == 2) {
                            n = 8;
                          } else if (selectedTipoDocumento == 1) {
                            n = 12;
                          } else {
                            n = 0;
                          }
                          if (value.length != n) {
                            numero_documento.text = value.substring(0, n);
                          }
                        },
                        validator: (value) {
                          int n;
                          if (selectedTipoDocumento == 2) {
                            n = 8;
                          } else if (selectedTipoDocumento == 1) {
                            n = 12;
                          } else {
                            n = 0;
                          }
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese datos';
                          } else if (value.length != n) {
                            return 'El dato debe tener $n caracteres';
                          }
                          return null;
                        },
                        controller: numero_documento),
                    TextFormField(
                      maxLength: 9,
                      decoration: InputDecoration(
                          labelText: 'Telefono',
                          icon: Icon(Icons.contact_phone_rounded),
                          iconColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Colors.yellow.shade800;
                            }
                            return Colors.blue.shade800;
                          })),
                      controller: telefono,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length != 9) {
                          return "Debe tener 9 caracteres";
                        } else if (!value.startsWith('9')) {
                          return 'El valor debe empezar por 9';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[1-9]')),
                      ],
                      keyboardType: TextInputType.number,
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
              if (_formKey.currentState!.validate()) {
                _crearCliente(
                    nombre.text,
                    apellido_paterno.text,
                    apellido_materno.text,
                    dateNacimiento,
                    selectedTipoDocumento,
                    numero_documento.text,
                    telefono.text);
              }
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

  void _crearCliente(nombre, apellidoP, apellidoM, nacimiento, tipoDocumento,
      numeroDocumento, telefono) async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/crear-cliente");
    try {
      var response = await http.post(url,
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode({
            "nombre": nombre,
            "apellidop": apellidoP,
            "apellidom": apellidoM,
            "fecha_nacimiento": DateFormat("yyyy-MM-dd").format(nacimiento),
            "tipo_documento": tipoDocumento,
            "numero_documento": numeroDocumento,
            "telefono": telefono
          }));
      if (response.statusCode == 201) {
        print("Agregado correctamente");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text("Cliente agregado correctamente"),
                  scrollable: true,
                  actions: <Widget>[
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => InicioAdmin(
                                  email.text, password.text, token)),
                          (route) => route.isFirst,
                        );
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
                      "Error al agregar cliente verifique los datos e intentelo de nuevo"),
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

  void _eliminarCliente(id) async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/eliminar-cliente/$id");
    try {
      var response = await http.delete(url, headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      });
      if (response.statusCode == 200) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text("Cliente eliminado correctamente"),
                  scrollable: true,
                  actions: <Widget>[
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => InicioAdmin(
                                  email.text, password.text, token)),
                          (route) => route.isFirst,
                        );
                      },
                      icon: Icon(Icons.save_rounded),
                      label: Text("Aceptar"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                    ),
                  ]);
            });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text(
                      "Error al eliminar el cliente verifique los datos e intentelo de nuevo"),
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

  void _showDelete(id, nombre) {
    final alert = AlertDialog(
        scrollable: true,
        actions: <Widget>[
          ElevatedButton.icon(
            onPressed: () {
              _eliminarCliente(id);
            },
            icon: Icon(Icons.check),
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
        title: Text("Eliminar Cliente"),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter state) {
            var _setstate = state;
            return Container(
              margin: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Text(
                nombre,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade600),
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
}
