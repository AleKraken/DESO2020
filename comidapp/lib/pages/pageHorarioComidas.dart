import 'package:animate_do/animate_do.dart';
import 'package:comidapp/DB/dataBaseProvider.dart';
import 'package:comidapp/models/comida.dart';
import 'package:comidapp/models/comidaDelDia.dart';
import 'package:comidapp/models/horarioComidas.dart';
import 'package:comidapp/pages/pageVistaReceta.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:like_button/like_button.dart';
import 'package:loop_page_view/loop_page_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HorarioComidas extends StatefulWidget {
  HorarioComidas({Key key}) : super(key: key);

  @override
  _HorarioComidasState createState() => _HorarioComidasState();
}

class _HorarioComidasState extends State<HorarioComidas> {
  int _indicePagina = DateTime.now().weekday - 1;
  var _diasSemana = [
    "Lunes",
    "Martes",
    "Miércoles",
    "Jueves",
    "Viernes",
    "Sábado",
    "Domingo"
  ];
  List<Comida> listaComidas = new List<Comida>();
  LoopPageController pageController = new LoopPageController(
    initialPage: DateTime.now().weekday - 1,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        toolbarHeight: 35,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(MdiIcons.chevronLeft, color: Colors.black),
              Text("${_diasSemana[_indicePagina]}",
                  style: Theme.of(context).textTheme.headline1),
              Icon(MdiIcons.chevronRight, color: Colors.black),
            ],
          ),
        ),
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
        ),
      ),
      body: Center(
        child: Container(
          child: LoopPageView.builder(
            controller: pageController,
            onPageChanged: (index) {
              _indicePagina = index;

              setState(() {});
            },
            itemCount: 7,
            itemBuilder: (_, index) {
              return PaginaHorario(listaComidas, index + 1);
            },
          ),
        ),
      ),
    );
  }
}

class PaginaHorario extends StatefulWidget {
  final List<Comida> listaComidas;
  final indexDia;

  const PaginaHorario(this.listaComidas, this.indexDia);

  @override
  _PaginaHorarioState createState() =>
      _PaginaHorarioState(listaComidas, indexDia);
}

class _PaginaHorarioState extends State<PaginaHorario> {
  List<Comida> listaComidas;
  int indexDia;
  _PaginaHorarioState(this.listaComidas, this.indexDia);

  Future _futureComidas;
  List<HorarioComida> listaHorario = new List<HorarioComida>();
  List<ComidaDelDia> listaComidasDelDia = new List<ComidaDelDia>();

  @override
  void initState() {
    super.initState();
    _futureComidas = _getComidas(indexDia);
  }

  Future _getComidas(int indexDia) async {
    await DatabaseProvider.db
        .getHorario(indexDia)
        .then((lHorario) => listaHorario = lHorario);
    await DatabaseProvider.db
        .getComidasDelDia()
        .then((lComidasDelDia) => listaComidasDelDia = lComidasDelDia);
    await DatabaseProvider.db.getComidasDeHorario(indexDia).then(
      (lComidas) {
        if (this.mounted) {
          setState(() {
            listaComidas = lComidas;
          });
        }
      },
    );

    return Future.delayed(Duration.zero);
  }

  Widget columnaComidas() {
    List<Comida> listaComidasOrdenada = new List<Comida>();
    List<HorarioComida> listaHorarioOrdenado = new List<HorarioComida>();

    for (int y = 0; y < listaComidasDelDia.length; y++) {
      for (int i = 0; i < listaComidas.length; i++) {
        if (listaHorario[i].foreignIdComidaDelDia ==
            listaComidasDelDia[y].idComidaDelDia) {
          listaComidasOrdenada.add(listaComidas[i]);
          listaHorarioOrdenado.add(listaHorario[i]);
        }
      }
    }

    return FutureBuilder(
        future: _futureComidas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else {
            return Container(
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: listaComidas.length > 0
                      ? Column(
                          children: [
                            indexDia == DateTime.now().weekday
                                ? SlideInDown(
                                    from: 30,
                                    duration: Duration(milliseconds: 600),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(0xFFFBB45C),
                                            Color(0xFFFE7A66),
                                          ],
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Text(
                                        "Bienvenido. Estas son las comidas que tienes para el día de hoy.",
                                        textScaleFactor: 1.12,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2
                                            .copyWith(
                                              color: Colors.white,
                                            ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            ListaContenedoresComidas(listaComidasOrdenada,
                                listaHorarioOrdenado, listaComidasDelDia)
                          ],
                        )
                      : Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 3),
                          child: Center(
                            child: Text("No tienes comidas en este día",
                                style: Theme.of(context).textTheme.headline2),
                          ),
                        ),
                ),
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: columnaComidas(),
    );
  }
}

class ListaContenedoresComidas extends StatelessWidget {
  final List<ComidaDelDia> listaComidasDelDia;
  final List<HorarioComida> listaHorario;
  final List<Comida> listaComidas;

  ListaContenedoresComidas(
      this.listaComidas, this.listaHorario, this.listaComidasDelDia);

  @override
  Widget build(BuildContext context) {
    List<Widget> listaChildren = new List<Widget>();
    List<int> listaCantidadesComidas = new List<int>();

    for (int i = 0; i < listaComidas.length; i++) {
      listaChildren.add(ContenedorComida(i, listaComidas, listaHorario));
    }

    for (int i = 0; i < listaComidasDelDia.length; i++) {
      listaCantidadesComidas.add(0);
      for (int y = 0; y < listaHorario.length; y++) {
        if (listaHorario[y].foreignIdComidaDelDia ==
            listaComidasDelDia[i].idComidaDelDia) {
          listaCantidadesComidas[i]++;
        }
      }
    }

    int conteo = 0;
    for (int i = 0; i < listaComidasDelDia.length; i++) {
      if (i > 0) {
        conteo += listaCantidadesComidas[i - 1] + 1;
      }
      listaChildren.insert(
        conteo,
        Container(
          padding: EdgeInsets.only(top: 25, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${listaComidasDelDia[i].nombre}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline2),
              Text("${listaComidasDelDia[i].hora}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle1),
              Container(
                color: Colors.grey,
                height: .3,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 5),
              ),
              listaCantidadesComidas[i] < 1
                  ? Text("Nada en ${listaComidasDelDia[i].nombre}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle1)
                  : Container(),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: AnimationLimiter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 450),
            delay: const Duration(milliseconds: 120),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 60.0,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: listaChildren,
          ),
        ),
      ),
    );
  }
}

class ContenedorComida extends StatefulWidget {
  final int index;
  final List<Comida> listaComidas;
  final List<HorarioComida> listaHorario;

  ContenedorComida(this.index, this.listaComidas, this.listaHorario);

  @override
  _ContenedorComidaState createState() =>
      _ContenedorComidaState(index, listaComidas, listaHorario);
}

class _ContenedorComidaState extends State<ContenedorComida> {
  final int index;
  final List<Comida> listaComidas;
  final List<HorarioComida> listaHorario;

  _ContenedorComidaState(this.index, this.listaComidas, this.listaHorario);

  bool eliminado = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 250),
        height: eliminado ? 0 : 85,
        margin: eliminado
            ? const EdgeInsets.symmetric(horizontal: 15)
            : const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        decoration: eliminado
            ? BoxDecoration(color: Theme.of(context).cardColor)
            : BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 13,
                    color: Theme.of(context).shadowColor,
                    offset: const Offset(-3, 0),
                    spreadRadius: -5,
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
              ),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            alignment: Alignment.topCenter,
            child: Row(
              children: [
                Expanded(
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              DetallesComida(listaComidas[index], index),
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
                            decoration: eliminado
                                ? BoxDecoration(
                                    color: Theme.of(context).backgroundColor)
                                : BoxDecoration(
                                    color: Theme.of(context).backgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 13,
                                        color: Theme.of(context).shadowColor,
                                        offset: const Offset(-1, 0),
                                        spreadRadius: -1,
                                      ),
                                    ],
                                  ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Hero(
                                tag: 'heroImagen$index',
                                child: FadeInImage(
                                  placeholder: AssetImage(
                                      'assets/images/comidaCargando.jpg'),
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
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                Divider(height: 3),
                                Text(
                                    "${listaComidas[index].listaIngredientesEnComida.length} ingredientes",
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                Divider(height: 3, color: Colors.transparent),
                                Text("${listaComidas[index].calorias} calorías",
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                Divider(height: 3, color: Colors.transparent),
                                Text(
                                    "${listaComidas[index].minutosPreparacion} minutos",
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
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
                      padding: EdgeInsets.only(right: 7, bottom: 6),
                      child: LikeButton(
                        animationDuration: Duration.zero,
                        size: 28,
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            MdiIcons.close,
                            color: Color(0xFFC63637),
                            size: 21,
                          );
                        },
                        onTap: (modificarSeleccionado) async {
                          await DatabaseProvider.db.deleteComidaDelHorario(
                              listaHorario[index].idComidaHorario);

                          eliminado = true;
                          setState(() {});
                          return !modificarSeleccionado;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 7, top: 6),
                      child: LikeButton(
                        isLiked: listaComidas[index].favoritoComida == 1
                            ? true
                            : false,
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
                            await DatabaseProvider.db.setComidaFavorita(
                                listaComidas[index].idComida, 1);

                            listaComidas[index].favoritoComida = 1;
                            return !favoritoSeleccionado;
                          } else {
                            await DatabaseProvider.db.setComidaFavorita(
                                listaComidas[index].idComida, 0);
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
          ),
        ));
  }
}
