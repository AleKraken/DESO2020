import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:comidapp/DB/dataBaseProvider.dart';
import 'package:comidapp/Notifiers/comidaNotifier.dart';
import 'package:comidapp/models/comida.dart';
import 'package:comidapp/pages/opcionesComida.dart';
import 'package:comidapp/pages/pageVistaReceta.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:like_button/like_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RecetasComidas extends StatefulWidget {
  RecetasComidas({Key key}) : super(key: key);

  @override
  _RecetasComidasState createState() => _RecetasComidasState();
}

class _RecetasComidasState extends State<RecetasComidas> {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Container(
          child: SliverSuperior(),
        ),
      ),
    );
  }
}

class SliverSuperior extends StatefulWidget {
  SliverSuperior({Key key}) : super(key: key);

  @override
  _SliverSuperiorState createState() => _SliverSuperiorState();
}

class _SliverSuperiorState extends State<SliverSuperior> {
  Future _futureComidas;
  List<Comida> listaComidasSugeridas = new List<Comida>();
  List<Comida> listaComidasSugeridasDisgustos = new List<Comida>();

  List<Comida> listaComidas = new List<Comida>();
  List<String> listaComidasStr = new List<String>();
  List<Comida> listaComidasBusqueda = new List<Comida>();

  Future _futureComidasSugeridas;
  Future _futureComidasSugeridasDisgustos;

  CarouselController carouselController = new CarouselController();
  int indiceCarousel = 0;

  bool mostrarTodo = false;

  @override
  void initState() {
    super.initState();
    _futureComidas = _getComidas();
    _futureComidasSugeridas = _getComidasSugeridas();
    _futureComidasSugeridasDisgustos = _getComidasSugeridasDisgustos();
  }

  Future _getComidasSugeridasDisgustos() async {
    await DatabaseProvider.db
        .getComidasSugeridasDisgustos()
        .then((lComidaSugeridaDisgustos) {
      if (this.mounted) {
        setState(() {
          listaComidasSugeridasDisgustos = lComidaSugeridaDisgustos;
        });
      }
    });
  }

  Future _getComidasSugeridas() async {
    await DatabaseProvider.db
        .getComidasSugeridasFavoritos()
        .then((lComidaSugerida) {
      if (this.mounted) {
        setState(() {
          listaComidasSugeridas = lComidaSugerida;
        });
      }
    });
  }

  Future _getComidas() async {
    await DatabaseProvider.db.getComidas().then(
      (lComidas) {
        if (this.mounted) {
          setState(() {
            listaComidas = lComidas;
            listaComidasBusqueda.addAll(lComidas);
          });
        }
      },
    );
    for (int i = 0; i < listaComidas.length; i++) {
      listaComidasStr.add(listaComidas[i].nombreComida);
      await Future.delayed(Duration.zero);
    }
    return Future.delayed(Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: CustomScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height / 6,
            elevation: 20,
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).backgroundColor,
            shadowColor: Colors.black,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFFBB45C),
                    Color(0xFFFE7A66),
                  ],
                ),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  FlexibleSpaceBar(
                    centerTitle: true,
                    title: Container(
                      alignment: Alignment.bottomCenter,
                      child: Text("Comidas",
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .headline1
                              .copyWith(color: Colors.white)),
                    ),
                    background: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          decoration: new BoxDecoration(
                            image: new DecorationImage(
                              image: new AssetImage(
                                  'assets/images/comidasPortada.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FlexibleSpaceBar.createSettings(
                    currentExtent: 20,
                    child: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Container(
                        height: 26,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.bottomLeft,
                        width: MediaQuery.of(context).size.width,
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 26,
                            icon: Icon(Icons.menu, color: Color(0xFF45AAB4)),
                            onPressed: () {
                              mostrarMenu(context);
                            }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Divider(color: Colors.transparent, height: 10),
          ),

          //SECCION DE COMIDAS SUGERIDAS DE FAVORITOS
          !mostrarTodo
              ? FutureBuilder(
                  future: _futureComidasSugeridas,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SliverToBoxAdapter(
                        child: Container(height: 370),
                      );
                    } else {
                      return SliverToBoxAdapter(
                        child: SlideInUp(
                          from: 35,
                          duration: Duration(milliseconds: 800),
                          child: FadeIn(
                            duration: Duration(milliseconds: 800),
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 16, left: 4, right: 4),
                                    child: Text(
                                      "Comidas que podrían gustarte",
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                    ),
                                  ),
                                  Container(height: 5),
                                  listaComidasSugeridas.length < 16
                                      ? Container(
                                          padding: EdgeInsets.only(
                                              left: 4, right: 4),
                                          child: Text(
                                            "Basadas en tus ingredientes favoritos",
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                        )
                                      : Container(),
                                  CarouselSlider.builder(
                                    carouselController: carouselController,
                                    itemCount: listaComidasSugeridas.length,
                                    options: CarouselOptions(
                                      autoPlayCurve: Curves.ease,
                                      viewportFraction: .7,
                                      autoPlay: true,
                                      initialPage: 1,
                                      height: 305,
                                      enableInfiniteScroll: false,
                                      autoPlayAnimationDuration:
                                          Duration(milliseconds: 1000),
                                      autoPlayInterval: Duration(seconds: 5),
                                      enlargeCenterPage: true,
                                    ),
                                    itemBuilder: (context, index) {
                                      return ContenedorComidaSugerida(
                                          index,
                                          listaComidasSugeridas[index],
                                          "HeroSugeridoFavoritos$index");
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                )
              : SliverToBoxAdapter(child: Container()),

          //SECCIÓN DE COMIDAS FAVORITAS SIN DISGUSTOS
          !mostrarTodo
              ? FutureBuilder(
                  future: _futureComidasSugeridasDisgustos,
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
                        child: SlideInUp(
                          from: 35,
                          duration: Duration(milliseconds: 800),
                          child: FadeIn(
                            duration: Duration(milliseconds: 800),
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 16, left: 4, right: 4),
                                    child: Text(
                                      "También podría interesarte",
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                    ),
                                  ),
                                  Container(height: 5),
                                  listaComidasSugeridasDisgustos.length < 16
                                      ? Container(
                                          padding: EdgeInsets.only(
                                              left: 4, right: 4),
                                          child: Text(
                                            "Sin ingredientes que te disgustan",
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                        )
                                      : Container(),
                                  CarouselSlider.builder(
                                    itemCount:
                                        listaComidasSugeridasDisgustos.length,
                                    options: CarouselOptions(
                                      autoPlayCurve: Curves.ease,
                                      viewportFraction: .7,
                                      autoPlay: true,
                                      initialPage: 1,
                                      height: 305,
                                      enableInfiniteScroll: false,
                                      autoPlayAnimationDuration:
                                          Duration(milliseconds: 1000),
                                      autoPlayInterval: Duration(seconds: 5),
                                      enlargeCenterPage: true,
                                    ),
                                    itemBuilder: (context, index) {
                                      return ContenedorComidaSugerida(
                                          index,
                                          listaComidasSugeridasDisgustos[index],
                                          'HeroSugeridosSinDisgustos$index');
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                )
              : SliverToBoxAdapter(child: Container()),
          mostrarTodo
              ? FutureBuilder(
                  future: _futureComidas,
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
                  })
              : SliverToBoxAdapter(
                  child: Container(),
                ),
          mostrarTodo
              ? FutureBuilder(
                  future: _futureComidas,
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
                      return SliverList(
                        delegate: SliverChildListDelegate(
                          getContenedores(),
                        ),
                      );
                    }
                  },
                )
              : SliverToBoxAdapter(
                  child: Container(),
                ),
        ],
      ),
    );
  }

  List<Widget> getContenedores() {
    List<Widget> listaContenedores = new List<Widget>();
    for (int i = 0; i < listaComidasBusqueda.length; i++) {
      listaContenedores.add(ContenedorComida(i, listaComidasBusqueda));
    }
    return listaContenedores;
  }

  _searchBar() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
                hintText: "Buscar comida",
                border: InputBorder.none,
              ),
              style: Theme.of(context).textTheme.headline2,
              onChanged: (text) {
                text = text.toLowerCase();
                if (this.mounted) {
                  setState(() {
                    listaComidasBusqueda = listaComidas.where((comidaBusqueda) {
                      var tituloComida =
                          comidaBusqueda.nombreComida.toLowerCase();
                      return tituloComida.contains(text);
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

  mostrarMenu(context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Wrap(
          alignment: WrapAlignment.center,
          children: [
            Container(
              width: 45,
              height: 4,
              margin: EdgeInsets.only(bottom: 9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                color: Colors.grey[300].withOpacity(.5),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18)),
              ),
              child: AnimationLimiter(
                child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 600),
                    delay: Duration(milliseconds: 0),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      Text("Elige una sección",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline3),
                      Divider(height: 20, color: Colors.transparent),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Theme.of(context).buttonColor,
                            Color(0xFF038DB2),
                          ]),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 6,
                              color: Theme.of(context).shadowColor,
                              offset: const Offset(0, 3),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              mostrarTodo = true;
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 30,
                            width: MediaQuery.of(context).size.width,
                            child: Text("Todas las comidas",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .copyWith(color: Colors.white)),
                          ),
                        ),
                      ),
                      Divider(height: 20, color: Colors.transparent),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Theme.of(context).buttonColor,
                            Color(0xFF038DB2),
                          ]),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 6,
                              color: Theme.of(context).shadowColor,
                              offset: const Offset(0, 3),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              mostrarTodo = false;
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 30,
                            width: MediaQuery.of(context).size.width,
                            child: Text("Recomendaciones",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .copyWith(color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ).whenComplete(() {
      if (this.mounted) {
        setState(() {});
      }
    });
  }
}

class ContenedorComidaSugerida extends StatefulWidget {
  final int index;
  final Comida comidaSugerida;
  final String rutaHeroSugeridos;

  ContenedorComidaSugerida(
      this.index, this.comidaSugerida, this.rutaHeroSugeridos);

  @override
  _ContenedorComidaSugeridaState createState() =>
      _ContenedorComidaSugeridaState(index, comidaSugerida, rutaHeroSugeridos);
}

class _ContenedorComidaSugeridaState extends State<ContenedorComidaSugerida> {
  final int index;
  final Comida comidaSugerida;
  final String rutaHeroSugeridos;

  _ContenedorComidaSugeridaState(
      this.index, this.comidaSugerida, this.rutaHeroSugeridos);

  ComidaNotifier comidaNotifier = new ComidaNotifier();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Container(
            height: 234,
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 11,
                  color: Theme.of(context).shadowColor,
                  offset: const Offset(0, 5),
                  spreadRadius: -2,
                ),
              ],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (context) => DetallesComida(
                              comidaSugerida, index, rutaHeroSugeridos),
                        ),
                      )
                          .then((value) {
                        if (this.mounted) {
                          setState(() {});
                        }
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 140,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            height: 60,
                            width: 60,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Hero(
                                tag: '$rutaHeroSugeridos',
                                child: FadeInImage(
                                  placeholder: AssetImage(
                                      'assets/images/comidaCargando.jpg'),
                                  image: NetworkImage(
                                    '${comidaSugerida.rutaImagen}',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${comidaSugerida.nombreComida}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    Divider(height: 3),
                                    Row(
                                      children: [
                                        Icon(MdiIcons.fire,
                                            color: Color(0xFFC63637)),
                                        Container(width: 5),
                                        Text(
                                            "${comidaSugerida.calorias} calorías",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                    Divider(
                                        height: 3, color: Colors.transparent),
                                    Row(
                                      children: [
                                        Icon(MdiIcons.clockTimeFive,
                                            color: Color(0xFF45AAB4)),
                                        Container(width: 5),
                                        Text(
                                            "${comidaSugerida.minutosPreparacion} minutos",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4, top: 10),
                                  child: Container(
                                    child: LikeButton(
                                      likeCountPadding: EdgeInsets.zero,
                                      animationDuration: Duration(seconds: 0),
                                      size: 28,
                                      likeBuilder: (bool isLiked) {
                                        return isLiked
                                            ? Icon(
                                                MdiIcons.plus,
                                                color: Color(0xFF038DB2),
                                                size: 21,
                                              )
                                            : Icon(
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
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 7),
                                  child: Container(
                                    color: Colors.transparent,
                                    child: LikeButton(
                                      likeCountPadding: EdgeInsets.zero,
                                      isLiked:
                                          comidaSugerida.favoritoComida == 1
                                              ? true
                                              : false,
                                      size: 28,
                                      circleColor: CircleColor(
                                          start: Color(0xFFFBB45C),
                                          end: Color(0xFFFBB45C)),
                                      bubblesColor: BubblesColor(
                                        dotPrimaryColor: Color(0xFFFBB45C),
                                        dotSecondaryColor: Color(0xFFF9637C),
                                      ),
                                      likeBuilder: (bool isLiked) {
                                        return isLiked
                                            ? Icon(
                                                MdiIcons.heart,
                                                color: Colors.red,
                                                size: 21,
                                              )
                                            : Icon(
                                                MdiIcons.heart,
                                                color: Color(0xFFB9B9B9),
                                                size: 21,
                                              );
                                      },
                                      onTap: (favoritoSeleccionado) async {
                                        if (comidaSugerida.favoritoComida ==
                                            0) {
                                          await DatabaseProvider.db
                                              .setComidaFavorita(
                                                  comidaSugerida.idComida, 1);

                                          comidaSugerida.favoritoComida = 1;
                                          return !favoritoSeleccionado;
                                        } else {
                                          await DatabaseProvider.db
                                              .setComidaFavorita(
                                                  comidaSugerida.idComida, 0);
                                          comidaSugerida.favoritoComida = 0;
                                          return !favoritoSeleccionado;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  mostrarOpcionesHorario(context, int indexComida) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setLocalState) {
            return OpcionesComida(
                context, comidaSugerida, index, comidaNotifier);
          },
        );
      },
    ).whenComplete(() {
      if (comidaNotifier.comidaGuardada) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            margin: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
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

class ContenedorComida extends StatelessWidget {
  final int index;
  final List<Comida> listaComidas;

  ContenedorComida(this.index, this.listaComidas);

  ComidaNotifier comidaNotifier = new ComidaNotifier();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 11,
            color: Theme.of(context).shadowColor,
            offset: const Offset(0, 5),
            spreadRadius: -2,
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetallesComida(
                        listaComidas[index], index, 'heroImagen$index'),
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    height: 85,
                    width: 100,
                    child: Container(
                      height: 60,
                      width: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Hero(
                          tag: 'heroImagen$index',
                          child: FadeInImage(
                            placeholder:
                                AssetImage('assets/images/comidaCargando.jpg'),
                            image: NetworkImage(
                              '${listaComidas[index].rutaImagen}',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${listaComidas[index].nombreComida}",
                              style: Theme.of(context).textTheme.headline2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          Divider(height: 5),
                          Text("${listaComidas[index].calorias} calorías",
                              style: Theme.of(context).textTheme.headline4,
                              textScaleFactor: .84,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          Divider(height: 8, color: Colors.transparent),
                          Text(
                              "${listaComidas[index].minutosPreparacion} minutos",
                              textScaleFactor: .84,
                              style: Theme.of(context).textTheme.headline4,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 7),
                child: LikeButton(
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
              ),
              Padding(
                padding: EdgeInsets.only(right: 7),
                child: LikeButton(
                  isLiked:
                      listaComidas[index].favoritoComida == 1 ? true : false,
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
                            MdiIcons.heart,
                            color: Colors.red,
                            size: 21,
                          )
                        : Icon(
                            MdiIcons.heart,
                            color: Color(0xFFB9B9B9),
                            size: 21,
                          );
                  },
                  onTap: (favoritoSeleccionado) async {
                    if (listaComidas[index].favoritoComida == 0) {
                      await DatabaseProvider.db
                          .setComidaFavorita(listaComidas[index].idComida, 1);

                      listaComidas[index].favoritoComida = 1;
                      return !favoritoSeleccionado;
                    } else {
                      await DatabaseProvider.db
                          .setComidaFavorita(listaComidas[index].idComida, 0);
                      listaComidas[index].favoritoComida = 0;
                      return !favoritoSeleccionado;
                    }
                  },
                ),
              ),
            ],
          ),
        ],
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
            return OpcionesComida(
                context, listaComidas[index], index, comidaNotifier);
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
