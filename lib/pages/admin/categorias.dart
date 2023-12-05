import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jassc/models/listcategorias.dart';
import 'package:jassc/pages/admin/inicio.dart';
import 'package:jassc/pages/login.dart';

class CategoriasPageAdmin extends StatefulWidget {
  final String email;
  final String password;
  final String token;

  CategoriasPageAdmin(this.email, this.password, this.token, {Key? key})
      : super(key: key);

  @override
  _CategoriasPageAdminState createState() => _CategoriasPageAdminState();
}

class _CategoriasPageAdminState extends State<CategoriasPageAdmin> {
  TextEditingController inputSearch = TextEditingController(text: "");
  late Future<List<ListCategorias>> lista_categorias;
  Future<List<ListCategorias>> getCategorias() async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/listar-categorias");
    try {
      List<ListCategorias> categorias = [];
      var response = await http.get(url, headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": 'Bearer $token'
      });

      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);

      for (var i = 0; i < data["data"].length; i++) {
        categorias.add(ListCategorias(
          data["data"][i]["id"].toString(),
          data["data"][i]["descripcion"],
          data["data"][i]["monto_correspondiente"].toString(),
        ));
      }
      return categorias;
    } catch (e) {
      throw Exception("Error con la conexion");
    }
  }

  @override
  void initState() {
    super.initState();
    lista_categorias = getCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: lista_categorias,
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
                          "Categorias",
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
                            helperText: "Busqueda categoria",
                            border: OutlineInputBorder()),
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
                          _listadoCategorias(snapshot.data, inputSearch.text))
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

  List<Widget> _listadoCategorias(data, input) {
    List<Widget> categorias = [];
    int iteracion = 0;
    if (input.isNotEmpty) {
      for (var categoria in data) {
        iteracion++;
        if (categoria.descripcion.toLowerCase().contains(input.toLowerCase()) ||
            categoria.monto_correspondiente.contains(input)) {
          categorias.add(Container(
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
                    width: MediaQuery.of(context).size.width * 0.55,
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
                        categoria.descripcion,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Monto : ${categoria.monto_correspondiente}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
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
                              _detalleCategoria(context, categoria.id);
                            },
                            icon: Icon(
                              Icons.remove_red_eye_rounded,
                              color: Colors.blue,
                              size: 25,
                            )),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.10,
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            border: Border.symmetric(
                                horizontal:
                                    BorderSide(width: 1, color: Colors.black))),
                        child: IconButton(
                            onPressed: () {
                              _editCategorias(context, categoria.id);
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 25,
                            )),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.10,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              border:
                                  Border.all(width: 1, color: Colors.black)),
                          child: IconButton(
                              onPressed: () {
                                _showDelete(
                                    categoria.id, categoria.descripcion);
                              },
                              icon: Icon(
                                Icons.delete_forever_rounded,
                                color: Colors.white,
                                size: 25,
                              )))
                    ],
                  ),
                )
              ],
            ),
          ));
        }
      }
    } else {
      for (var categoria in data) {
        iteracion++;
        categorias.add(Container(
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
                  width: MediaQuery.of(context).size.width * 0.55,
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
                      categoria.descripcion,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Monto : ${categoria.monto_correspondiente}",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
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
                            _detalleCategoria(context, categoria.id);
                          },
                          icon: Icon(
                            Icons.remove_red_eye_rounded,
                            color: Colors.blue,
                            size: 25,
                          )),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.10,
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          border: Border.symmetric(
                              horizontal:
                                  BorderSide(width: 1, color: Colors.black))),
                      child: IconButton(
                          onPressed: () {
                            _editCategorias(context, categoria.id);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: 25,
                          )),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.10,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            border: Border.all(width: 1, color: Colors.black)),
                        child: IconButton(
                            onPressed: () {
                              _showDelete(categoria.id, categoria.descripcion);
                            },
                            icon: Icon(
                              Icons.delete_forever_rounded,
                              color: Colors.white,
                              size: 25,
                            )))
                  ],
                ),
              )
            ],
          ),
        ));
      }
    }
    return categorias;
  }

  void _detalleCategoria(context, id) async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/listar-categorias/$id");
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

  void _showDatos(context, data) {
    final alert = AlertDialog(
        scrollable: true,
        title: Text("Datos Categoria " + data["data"]["id"].toString()),
        content: Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${data["data"]["descripcion"]}",
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
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                    "Monto correspondiente : ${data["data"]["monto_correspondiente"].toString()}"),
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
    final alert = AlertDialog(title: Text("Error Conexion"), actions: <Widget>[
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

  void _editCategorias(context, id) async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/listar-categorias/$id");
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

  TextEditingController descripcion = TextEditingController(text: "");
  TextEditingController montoCorrespondiente = TextEditingController(text: "");
  void _showEditForm(data) {
    descripcion =
        TextEditingController(text: data["data"]["descripcion"].toString());
    montoCorrespondiente = TextEditingController(
        text: data["data"]["monto_correspondiente"].toString());

    final alert = AlertDialog(
        scrollable: true,
        title: Text("Editar Categoria " + data["data"]["id"].toString()),
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
                          labelText: 'Descripcion',
                          icon: Icon(Icons.description_rounded),
                          iconColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Colors.yellow.shade800;
                            }
                            return Colors.blue.shade800;
                          })),
                      controller: descripcion,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Monto Correspondiente',
                          icon: Icon(Icons.monetization_on_rounded),
                          iconColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Colors.yellow.shade800;
                            }
                            return Colors.blue.shade800;
                          })),
                      controller: montoCorrespondiente,
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
              _editarCategoria(data["data"]["id"], descripcion.text,
                  montoCorrespondiente.text);
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

  void _editarCategoria(id, descripcion, monto) async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/actualizar-categoria/${id.toString()}");
    try {
      var response = await http.put(url,
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode({
            "descripcion": descripcion,
            "monto_correspondiente": double.parse(monto)
          }));
      if (response.statusCode == 200) {
        print("Creado correctamente");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text("Categoria actualizada correctamente"),
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
                      "Error al actualizar la categoria verifique los datos e intentelo de nuevo"),
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

  void _showNewForm() {
    descripcion = TextEditingController(text: "");
    montoCorrespondiente = TextEditingController(text: "");
    final alert = AlertDialog(
        scrollable: true,
        title: Text("Nueva Categoria"),
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
                          labelText: 'Descripcion',
                          icon: Icon(Icons.description_rounded),
                          iconColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Colors.yellow.shade800;
                            }
                            return Colors.blue.shade800;
                          })),
                      controller: descripcion,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Monto Correspondiente',
                          icon: Icon(Icons.monetization_on_rounded),
                          iconColor: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Colors.yellow.shade800;
                            }
                            return Colors.blue.shade800;
                          })),
                      controller: montoCorrespondiente,
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
              _registrarCategoria(descripcion.text, montoCorrespondiente.text);
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

  void _registrarCategoria(des, mont) async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/crear-categoria");
    try {
      var response = await http.post(url,
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
          body:
              jsonEncode({"descripcion": des, "monto_correspondiente": mont}));
      if (response.statusCode == 201) {
        print("Creado correctamente");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text("Categoria creada correctamente"),
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
                      "Error al crear la categoria verifique los datos e intentelo de nuevo"),
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

  void _showDelete(data, descripcion) {
    final alert = AlertDialog(
        scrollable: true,
        actions: <Widget>[
          ElevatedButton.icon(
            onPressed: () {
              _eliminarCategoria(data);
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
        title: Text("Eliminar Categoria"),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter state) {
            var _setstate = state;
            return Container(
              margin: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Text(
                descripcion,
                style: TextStyle(
                    color: Colors.blue.shade800,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
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

  void _eliminarCategoria(id) async {
    var url = Uri.parse(
        "https://phplaravel-1149125-3997241.cloudwaysapps.com/api/eliminar-categoria/${id.toString()}");
    try {
      var response = await http.delete(
        url,
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      if (response.statusCode == 200) {
        print("Eliminado correctamente");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text("Categoria eliminada correctamente"),
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
                      "Error al eliminar la categoria verifique los datos e intentelo de nuevo"),
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
}
