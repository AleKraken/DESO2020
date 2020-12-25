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

  DetallesComida(this.comida, this.index);

  @override
  _DetallesComidaState createState() => _DetallesComidaState(comida, index);
}

class _DetallesComidaState extends State<DetallesComida> {
  final Comida comida;
  final int index;

  _DetallesComidaState(this.comida, this.index);

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
                            tag: 'heroImagen$index',
                            child: Image.network(comida.rutaImagen,
                                fit: BoxFit.cover),
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
  const SliverInstrucciones(this.comida);

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
  final Comida comida;
  _SliverIngredientesState(this.comida);

  List<Ingrediente> listaIngredientes = new List<Ingrediente>();
  Future _futureIngredientes;

  void initState() {
    super.initState();
    _futureIngredientes = getIngredientes();
  }

  Future getIngredientes() async {
    for (int i = 0; i < comida.listaIngredientesEnComida.length; i++) {
      listaIngredientes.add(await DatabaseProvider.db
          .getIngredienteIndividual(comida.listaIngredientesEnComida[i]));
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
                  padding: EdgeInsets.only(top: 10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
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

  List<Widget> columnaIngredientes() {
    List<Widget> listaFilas = new List<Widget>();

    for (int i = 0; i < comida.listaIngredientesEnComida.length; i++) {
      listaFilas.add(Divider());
      listaFilas.add(
        filaIngrediente(i),
      );
    }
    return listaFilas;
  }

  Widget filaIngrediente(int index) {
    return SlideInLeft(
      delay: Duration(milliseconds: 100 + (index * 100)),
      from: 50,
      child: FadeIn(
        delay: Duration(milliseconds: 100 + (index * 100)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
                          print('Error Handler');
                          return Container(
                            width: 100.0,
                            height: 100.0,
                            child: Image.asset(
                                'assets/images/ingredienteCargando.png'),
                          );
                        },
                        placeholder:
                            AssetImage('assets/images/ingredienteCargando.png'),
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
                  Divider(color: Colors.transparent, height: 6),
                  Text("${listaIngredientes[index].nombreIngrediente}",
                      textAlign: TextAlign.end,
                      style: Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(fontSize: 12)),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
            Expanded(
              child: Text("${comida.listaMedidasIngredientes[index]}",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.subtitle2),
            ),
          ],
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
                        style: Theme.of(context).textTheme.headline6),
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
                        style: Theme.of(context).textTheme.headline6),
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
                        style: Theme.of(context).textTheme.headline6),
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
            content: Text('Comida agregada a horario'),
            duration: Duration(seconds: 3),
          ),
        );
        comidaNotifier.setComidaGuardada(false);
      }
    });
  }
}
