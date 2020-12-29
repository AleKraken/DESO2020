import 'package:animate_do/animate_do.dart';
import 'package:comidapp/DB/dataBaseProvider.dart';
import 'package:comidapp/models/comidaCreada.dart';
import 'package:comidapp/models/ingrediente.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PaginaTresIngredientes extends StatefulWidget {
  PaginaTresIngredientes({Key key}) : super(key: key);

  @override
  _PaginaTresIngredientesState createState() => _PaginaTresIngredientesState();
}

class _PaginaTresIngredientesState extends State<PaginaTresIngredientes> {
  List<Ingrediente> listaIngredientesBusqueda = new List<Ingrediente>();

  Future _futureIngredientes;
  List<Ingrediente> listaIngredientes = new List<Ingrediente>();

  @override
  void initState() {
    super.initState();
    _futureIngredientes = _getIngredientes();
  }

  Future _getIngredientes() async {
    await DatabaseProvider.db.getIngredientes().then(
      (lIngredientes) {
        if (this.mounted) {
          setState(() {
            listaIngredientes = lIngredientes;
            listaIngredientesBusqueda.addAll(listaIngredientes);
          });
        }
      },
    );
    return Future.delayed(Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Text("Selecciona los ingredientes",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline3),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
              child: Text(
                  "Selecciona entre 1 y 20 ingredientes para tu comida.",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.subtitle1),
            ),
          ),
          FutureBuilder(
              future: _futureIngredientes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverToBoxAdapter(
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: LinearProgressIndicator()),
                        ],
                      ),
                    ),
                  );
                } else {
                  return SliverToBoxAdapter(
                    child: FadeIn(
                      duration: Duration(milliseconds: 400),
                      child: _searchBar(),
                    ),
                  );
                }
              }),
          FutureBuilder(
              future: _futureIngredientes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverToBoxAdapter(
                    child: Container(),
                  );
                } else {
                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 45,
                        crossAxisCount: 3),
                    delegate: SliverChildListDelegate(
                      getContenedores(listaIngredientesBusqueda),
                    ),
                  );
                }
              }),
          SliverToBoxAdapter(
            child: Container(
              height: 50,
            ),
          ),
        ],
      ),
    );
  }

  _searchBar() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AnimatedContainer(
            alignment: Alignment.topLeft,
            duration: Duration(milliseconds: 350),
            curve: Curves.ease,
            width: MediaQuery.of(context).size.width - 25,
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  blurRadius: 11,
                  color: Theme.of(context).shadowColor,
                  offset: const Offset(0, 5),
                  spreadRadius: -2,
                ),
              ],
            ),
            child: TextField(
              cursorColor: Theme.of(context).iconTheme.color,
              decoration: InputDecoration(
                hintStyle: Theme.of(context).textTheme.subtitle1,
                icon: Icon(Icons.search),
                hintText: "Buscar ingredientes",
                border: InputBorder.none,
              ),
              style: Theme.of(context).textTheme.headline2,
              onChanged: (text) {
                text = text.toLowerCase();
                if (this.mounted) {
                  setState(() {
                    listaIngredientesBusqueda =
                        listaIngredientes.where((ingredienteBusqueda) {
                      var tituloIngrediente =
                          ingredienteBusqueda.nombreIngrediente.toLowerCase();
                      return tituloIngrediente.contains(text);
                    }).toList();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  getContenedores(List<Ingrediente> listaIngredientes) {
    List<Widget> listaContenedores = new List<Widget>();

    for (int i = 0; i < listaIngredientes.length; i++) {
      listaContenedores.add(ContenedorIngrediente(i, listaIngredientes));
    }

    return listaContenedores;
  }
}

Color getColor(int index) {
  Color color = new Color(0xFFFBB45C);

  if (index % 6 == 0) {
    color = Color(0xFF45AAB4);
  } else {
    if (index % 5 == 0) {
      color = Color(0xFFF9637C);
    } else {
      if (index % 4 == 0) {
        color = Color(0xFF038DB2);
      } else {
        if (index % 3 == 0) {
          color = Color(0xFFFE7A66);
        } else {
          if (index % 2 == 0) {
            color = Color(0xFF206491);
          }
        }
      }
    }
  }
  return color;
}

class ContenedorIngrediente extends StatelessWidget {
  final int index;
  final List<Ingrediente> listaIngredientes;

  ContenedorIngrediente(this.index, this.listaIngredientes);

  ComidaCreada comidaCreada = ComidaCreada.getComidaCreada();

  bool elementoSeleccionado = false;

  @override
  Widget build(BuildContext context) {
    comidaCreada.getListaIngredientes().forEach((element) {
      if (listaIngredientes[index].idIngrediente == element.idIngrediente) {
        elementoSeleccionado = true;
      }
    });

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Theme.of(context).shadowColor,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
        borderRadius: BorderRadius.circular(10),
        color: getColor(index),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 0),
            child: Text("${listaIngredientes[index].nombreIngrediente}",
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(color: Colors.white),
                textScaleFactor: .8,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis),
          ),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black,
                  offset: const Offset(0, 22),
                  spreadRadius: -14,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage(
                imageErrorBuilder: (BuildContext context, Object exception,
                    StackTrace stackTrace) {
                  print('Error Handler');
                  return Container(
                    width: 100.0,
                    height: 100.0,
                    child: Image.asset('assets/images/ingredienteCargando.png'),
                  );
                },
                placeholder:
                    AssetImage('assets/images/ingredienteCargando.png'),
                image: NetworkImage(
                    '${listaIngredientes[index].rutaImagenIngrediente}'),
                fit: BoxFit.cover,
                height: 100.0,
                width: 100.0,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.5),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LikeButton(
                  isLiked: elementoSeleccionado,
                  size: 28,
                  circleColor: CircleColor(
                      start: Color(0xFFFBB45C), end: Color(0xFFFBB45C)),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: Color(0xFFFBB45C),
                    dotSecondaryColor: Color(0xFFF9637C),
                  ),
                  likeBuilder: (bool isLiked) {
                    return isLiked
                        ? Icon(
                            MdiIcons.check,
                            color: Theme.of(context).iconTheme.color,
                            size: 21,
                          )
                        : Icon(
                            MdiIcons.plus,
                            color: Colors.white,
                            size: 21,
                          );
                  },
                  onTap: (agregadoSeleccionado) async {
                    if (!agregadoSeleccionado) {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      if (comidaCreada.listaIngredientes.length < 20) {
                        comidaCreada
                            .agregarIngrediente(listaIngredientes[index]);
                        comidaCreada.agregarCantidadIngredienteALista();

                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            margin: EdgeInsets.symmetric(
                                vertical: 30, horizontal: 15),
                            elevation: 6.0,
                            behavior: SnackBarBehavior.floating,
                            content: Text(
                                'Se agregó ${listaIngredientes[index].nombreIngrediente} a la comida'),
                            duration: Duration(milliseconds: 1500),
                          ),
                        );
                        return !agregadoSeleccionado;
                      } else {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            elevation: 6.0,
                            behavior: SnackBarBehavior.floating,
                            content: Text(
                                'Has alcanzado el límite de ingredientes por comida (20)'),
                            duration: Duration(milliseconds: 1500),
                          ),
                        );
                        return agregadoSeleccionado;
                      }
                    } else {
                      comidaCreada.quitarIngrediente(listaIngredientes[index]);

                      return !agregadoSeleccionado;
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
