import 'package:animate_do/animate_do.dart';
import 'package:comidapp/DB/dataBaseProvider.dart';
import 'package:comidapp/Notifiers/comidaNotifier.dart';
import 'package:comidapp/models/comida.dart';
import 'package:comidapp/models/ingrediente.dart';
import 'package:comidapp/pages/opcionesComida.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DetallesComida extends StatefulWidget {
  final Comida comida;
  final int index;
  final String rutaHero;

  DetallesComida(this.comida, this.index, this.rutaHero);

  @override
  _DetallesComidaState createState() =>
      _DetallesComidaState(comida, index, rutaHero);
}

class _DetallesComidaState extends State<DetallesComida> {
  final Comida comida;
  final int index;
  final String rutaHero;

  _DetallesComidaState(this.comida, this.index, this.rutaHero);

  @override
  Widget build(BuildContext context) {
    final double alturaSliver = MediaQuery.of(context).size.height * 0.35;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          SliverAppBar(
            pinned: false,
            expandedHeight: alturaSliver,
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: FadeIn(
              delay: Duration(milliseconds: 300),
              duration: Duration(milliseconds: 600),
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  child: Icon(
                    MdiIcons.arrowLeft,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.black,
            flexibleSpace: Stack(
              children: [
                Positioned(
                    child: Container(
                      child: FlexibleSpaceBar(
                        centerTitle: true,
                        background: Container(
                          height: 180,
                          child: Hero(
                            tag: '$rutaHero',
                            child: FadeInImage(
                              placeholder: AssetImage(
                                  'assets/images/comidaCargando.jpg'),
                              image: NetworkImage(
                                '${comida.rutaImagen}',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0),
                Positioned(
                  child: SlideInUp(
                    duration: Duration(milliseconds: 500),
                    child: Container(
                      height: 23,
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(100),
                        ),
                      ),
                    ),
                  ),
                  bottom: -1,
                  left: 0,
                  right: 0,
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: SliverTitulo(comida, index),
          ),
          SliverToBoxAdapter(
            child: SliverSubtitulo(comida),
          ),
          SliverToBoxAdapter(
            child: SliverInformacion(comida),
          ),
          SliverToBoxAdapter(
            child: SliverIngredientes(comida),
          ),
          SliverToBoxAdapter(
            child: SliverInstrucciones(comida),
          ),
        ],
      ),
    );
  }
}

class SliverInstrucciones extends StatelessWidget {
  final Comida comida;
  SliverInstrucciones(this.comida);

  String traduccion;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 70, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Preparación",
              textScaleFactor: .9,
              style: Theme.of(context).textTheme.headline3),
          Divider(),
          Text("${comida.pasosPreparacion}",
              textScaleFactor: .9,
              style: Theme.of(context).textTheme.subtitle1),
        ],
      ),
    );
  }
}

class SliverIngredientes extends StatefulWidget {
  final Comida comida;
  SliverIngredientes(this.comida);

  @override
  _SliverIngredientesState createState() => _SliverIngredientesState(comida);
}

class _SliverIngredientesState extends State<SliverIngredientes> {
  Comida comida;
  _SliverIngredientesState(this.comida);

  List<Ingrediente> listaIngredientes = new List<Ingrediente>();
  Future _futureIngredientes;
  List<String> advertenciasIngredientes = new List<String>();
  List<String> favoritosIngredientes = new List<String>();

  void initState() {
    super.initState();
    _futureIngredientes = getIngredientes();
  }

  Future getIngredientes() async {
    comida = await DatabaseProvider.db.getComidaConIngredientes(comida);

    for (int i = 0; i < comida.listaIngredientesEnComida.length; i++) {
      listaIngredientes.add(await DatabaseProvider.db
          .getIngredienteIndividual(comida.listaIngredientesEnComida[i]));
      if (listaIngredientes.last.disgustaIngrediente == 1) {
        advertenciasIngredientes.add(listaIngredientes.last.nombreIngrediente);
      }
      if (listaIngredientes.last.favoritoIngrediente == 1) {
        favoritosIngredientes.add(listaIngredientes.last.nombreIngrediente);
      }
    }
    return Future.delayed(Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _futureIngredientes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          } else {
            return Container(
              child: FadeIn(
                delay: Duration(milliseconds: 300),
                duration: Duration(milliseconds: 600),
                child: Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        favoritosIngredientes.length > 0
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF038DB2),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 11,
                                        color: Theme.of(context).shadowColor,
                                        offset: const Offset(0, 5),
                                        spreadRadius: -2,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 7),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                              "Esta receta contiene ${getNombresFavoritos()}",
                                              textAlign: TextAlign.start,
                                              textScaleFactor: .9,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline2
                                                  .copyWith(
                                                      color: Colors.white)),
                                        ),
                                        Container(width: 10),
                                        Icon(
                                          MdiIcons.heart,
                                        ),
                                        Container(width: 5),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        Divider(color: Colors.transparent),
                        advertenciasIngredientes.length > 0
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFC63637),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 11,
                                        color: Theme.of(context).shadowColor,
                                        offset: const Offset(0, 5),
                                        spreadRadius: -2,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 7),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                              "Esta receta contiene ${getNombresAdvertencias()}",
                                              textAlign: TextAlign.start,
                                              textScaleFactor: .9,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline2
                                                  .copyWith(
                                                      color: Colors.white)),
                                        ),
                                        Container(width: 10),
                                        Icon(
                                          MdiIcons.thumbDown,
                                        ),
                                        Container(width: 5),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        Container(
                          margin: EdgeInsets.only(top: 35, bottom: 5),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                              "${comida.listaIngredientesEnComida.length} Ingredientes",
                              textAlign: TextAlign.start,
                              textScaleFactor: .9,
                              style: Theme.of(context).textTheme.headline3),
                        ),
                        Column(
                          children: columnaIngredientes(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  String getNombresFavoritos() {
    favoritosIngredientes = favoritosIngredientes.toSet().toList();

    String favoritos = "";

    if (favoritosIngredientes.length == 1) {
      return "${favoritosIngredientes[0]}.";
    } else if (favoritosIngredientes.length == 2) {
      return favoritos +=
          "${favoritosIngredientes[0]} y ${favoritosIngredientes[1]}.";
    } else {
      for (int i = 0; i < favoritosIngredientes.length; i++) {
        if (i == 0 && favoritosIngredientes.length > 2) {
          favoritos += "${favoritosIngredientes[i]}";
        } else {
          if (i == favoritosIngredientes.length - 2) {
            favoritos +=
                ", ${favoritosIngredientes[i]} y ${favoritosIngredientes[i + 1]}.";
            return favoritos;
          } else {
            favoritos += ", ${favoritosIngredientes[i]}";
          }
        }
      }
    }
    return favoritos;
  }

  String getNombresAdvertencias() {
    advertenciasIngredientes = advertenciasIngredientes.toSet().toList();

    String advertencia = "";

    if (advertenciasIngredientes.length == 1) {
      return "${advertenciasIngredientes[0]}.";
    } else if (advertenciasIngredientes.length == 2) {
      return advertencia +=
          "${advertenciasIngredientes[0]} y ${advertenciasIngredientes[1]}.";
    } else {
      for (int i = 0; i < advertenciasIngredientes.length; i++) {
        if (i == 0 && advertenciasIngredientes.length > 2) {
          advertencia += "${advertenciasIngredientes[i]}";
        } else {
          if (i == advertenciasIngredientes.length - 2) {
            advertencia +=
                ", ${advertenciasIngredientes[i]} y ${advertenciasIngredientes[i + 1]}.";
            return advertencia;
          } else {
            advertencia += ", ${advertenciasIngredientes[i]}";
          }
        }
      }
    }
    return advertencia;
  }

  List<Widget> columnaIngredientes() {
    List<Widget> listaFilas = new List<Widget>();

    for (int i = 0; i < comida.listaIngredientesEnComida.length; i++) {
      listaFilas.add(Divider(color: Colors.transparent, height: 12));
      listaFilas.add(
        filaIngrediente(i),
      );
    }
    return listaFilas;
  }

  Widget filaIngrediente(int index) {
    return SlideInUp(
      delay: Duration(milliseconds: 100 + (index * 100)),
      from: 50,
      child: FadeIn(
        delay: Duration(milliseconds: 100 + (index * 100)),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                blurRadius: 6,
                color: Theme.of(context).shadowColor,
                offset: const Offset(0, 5),
                spreadRadius: -2,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          "${listaIngredientes[index].nombreIngrediente}",
                          textAlign: TextAlign.end,
                          style: Theme.of(context)
                              .textTheme
                              .headline2
                              .copyWith(fontSize: 12),
                        ),
                      ),
                      Container(width: 10),
                      Container(
                        height: 30,
                        width: 30,
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
                            imageErrorBuilder: (BuildContext context,
                                Object exception, StackTrace stackTrace) {
                              return Container(
                                width: 30.0,
                                height: 30.0,
                                child: Image.asset(
                                    'assets/images/ingredienteCargando.png'),
                              );
                            },
                            placeholder: AssetImage(
                                'assets/images/ingredienteCargando.png'),
                            image: index > 534
                                ? AssetImage(
                                    'assets/images/ingredienteCargando.png')
                                : NetworkImage(
                                    '${listaIngredientes[index].rutaImagenIngrediente}'),
                            fit: BoxFit.cover,
                            height: 100.0,
                            width: 100.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 20,
                alignment: Alignment.center,
                child: Text("•",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.headline2),
              ),
              Expanded(
                child: Text("${comida.listaMedidasIngredientes[index]}",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.subtitle2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SliverInformacion extends StatelessWidget {
  final Comida comida;
  const SliverInformacion(this.comida);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18),
      padding: EdgeInsets.symmetric(vertical: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: SlideInUp(
              delay: Duration(milliseconds: 420),
              from: 20,
              child: FadeIn(
                delay: Duration(milliseconds: 420),
                duration: Duration(milliseconds: 400),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF45AAB4),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Theme.of(context).shadowColor,
                        spreadRadius: 0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    child: Text("Tipo\n${comida.categoria}",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SlideInUp(
              delay: Duration(milliseconds: 550),
              from: 20,
              child: FadeIn(
                delay: Duration(milliseconds: 550),
                duration: Duration(milliseconds: 400),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF45AAB4),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Theme.of(context).shadowColor,
                        spreadRadius: 0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    child: Text("${comida.minutosPreparacion}\nMinutos",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SlideInUp(
              delay: Duration(milliseconds: 700),
              from: 20,
              child: FadeIn(
                delay: Duration(milliseconds: 700),
                duration: Duration(milliseconds: 400),
                child: Container(
                  decoration: BoxDecoration(
                    color: comida.calorias < 650
                        ? Color(0xFF45AAB4)
                        : comida.calorias < 1000
                            ? Color(0xFFFBB45C)
                            : Color(0xFFC63637),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Theme.of(context).shadowColor,
                        spreadRadius: 0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    child: Text("${comida.calorias}\nCalorías",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SliverSubtitulo extends StatelessWidget {
  final Comida comida;
  const SliverSubtitulo(this.comida);

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      delay: Duration(milliseconds: 300),
      duration: Duration(milliseconds: 600),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 25),
        child: Text(
          "Comida ${comida.area}",
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    );
  }
}

class SliverTitulo extends StatelessWidget {
  final Comida comida;
  final int index;

  SliverTitulo(this.comida, this.index);

  ComidaNotifier comidaNotifier = new ComidaNotifier();

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      delay: Duration(milliseconds: 300),
      duration: Duration(milliseconds: 600),
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 25),
                child: Text("${comida.nombreComida}",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.headline3),
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 10)),
            LikeButton(
              likeCountPadding: EdgeInsets.all(0),
              isLiked: comida.favoritoComida == 1 ? true : false,
              size: 38,
              circleColor:
                  CircleColor(start: Color(0xFFFBB45C), end: Color(0xFFFBB45C)),
              bubblesColor: BubblesColor(
                dotPrimaryColor: Color(0xFFFBB45C),
                dotSecondaryColor: Color(0xFFF9637C),
              ),
              likeBuilder: (bool isLiked) {
                return isLiked
                    ? Icon(
                        MdiIcons.heart,
                        color: Colors.red,
                        size: 25,
                      )
                    : Icon(
                        MdiIcons.heart,
                        color: Color(0xFFB9B9B9),
                        size: 25,
                      );
              },
              onTap: (favoritoSeleccionado) async {
                if (comida.favoritoComida == 0) {
                  await DatabaseProvider.db
                      .setComidaFavorita(comida.idComida, 1);

                  comida.favoritoComida = 1;
                  return !favoritoSeleccionado;
                } else {
                  await DatabaseProvider.db
                      .setComidaFavorita(comida.idComida, 0);
                  comida.favoritoComida = 0;
                  return !favoritoSeleccionado;
                }
              },
            ),
            Padding(padding: EdgeInsets.only(right: 10)),
            LikeButton(
              animationDuration: Duration(seconds: 0),
              size: 28,
              likeBuilder: (bool isLiked) {
                return Icon(
                  MdiIcons.plus,
                  color: Color(0xFF038DB2),
                  size: 21,
                );
              },
              onTap: (agregarSeleccionado) async {
                mostrarOpcionesHorario(context, index);
                return !agregarSeleccionado;
              },
            ),
            Padding(padding: EdgeInsets.only(right: 10)),
          ],
        ),
      ),
    );
  }

  ComidaNotifier getComidaNotifierObject() {
    return comidaNotifier;
  }

  mostrarOpcionesHorario(context, int indexComida) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setLocalState) {
            return OpcionesComida(context, comida, index, comidaNotifier);
          },
        );
      },
    ).whenComplete(() {
      if (comidaNotifier.comidaGuardada) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            elevation: 6.0,
            behavior: SnackBarBehavior.floating,
            content: Text('Comida agregada a horario'),
            duration: Duration(seconds: 3),
          ),
        );
        comidaNotifier.setComidaGuardada(false);
      }
    });
  }
}
