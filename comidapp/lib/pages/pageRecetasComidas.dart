import 'dart:convert';

import 'package:comidapp/DB/dataBaseProvider.dart';
import 'package:comidapp/models/comida.dart';
import 'package:dio/dio.dart';
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
  Future _futureComidas;
  List<Comida> listaComidas = new List<Comida>();
  String rutaImagenComida;

  @override
  void initState() {
    super.initState();
    _futureComidas = _getComidas();
    getComidasHttps();
  }

  Future _getComidas() async {
    await DatabaseProvider.db.getComidas().then(
      (lComidas) {
        setState(() {
          listaComidas = lComidas;
        });
      },
    );
    return Future.delayed(Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 35,
        title: Center(
          child: Text("Comidas", style: Theme.of(context).textTheme.headline1),
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
          child: FutureBuilder(
            future: _futureComidas,
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
                return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: ListaContenedoresComidas(listaComidas),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class ListaContenedoresComidas extends StatelessWidget {
  final List<Comida> listaComidas;

  ListaContenedoresComidas(this.listaComidas);

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: listaComidas.length + 1,
          itemBuilder: (BuildContext ctxt, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 450),
              delay: const Duration(milliseconds: 120),
              child: SlideAnimation(
                verticalOffset: 60.0,
                child: FadeInAnimation(
                  child: ContenedorComida(index, listaComidas),
                ),
              ),
            );
          }),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AnimatedContainer(
            alignment: Alignment.topLeft,
            duration: Duration(milliseconds: 350),
            curve: Curves.ease,
            width: MediaQuery.of(context).size.width - 15,
            height: 45,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
            decoration: BoxDecoration(
              color: Color(0xFFF0F4F7),
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              cursorColor: Theme.of(context).iconTheme.color,
              decoration: InputDecoration(
                hintStyle: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontWeight: FontWeight.w500),
                icon: Icon(Icons.search),
                hintText: "Buscar recetas",
                border: InputBorder.none,
              ),
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class ContenedorComida extends StatelessWidget {
  final int index;
  final List<Comida> listaComidas;
  String rutaImagenComida;

  ContenedorComida(this.index, this.listaComidas);

  @override
  Widget build(BuildContext context) {
    return index == 0
        ? SearchBar()
        : Container(
            height: 85,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 13,
                  color: Theme.of(context).shadowColor,
                  offset: const Offset(0, 4),
                  spreadRadius: -10,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).cardColor,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: Row(
              children: [
                Container(
                  height: 85,
                  width: 100,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 13,
                        color: Theme.of(context).shadowColor,
                        offset: const Offset(-3, 0),
                        spreadRadius: -5,
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                  child: FutureBuilder(
                    future: getComidasHttps()
                        .then((value) => rutaImagenComida = value),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 13,
                                color: Theme.of(context).shadowColor,
                                offset: const Offset(-3, 0),
                                spreadRadius: -5,
                              ),
                            ],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              topLeft: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: AssetImage('assets/images/platoVacio.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 13,
                                color: Theme.of(context).shadowColor,
                                offset: const Offset(-3, 0),
                                spreadRadius: -5,
                              ),
                            ],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              topLeft: Radius.circular(10),
                            ),
                          ),
                          child: FadeInImage(
                            fit: BoxFit.cover,
                            image: NetworkImage('$rutaImagenComida'),
                            placeholder:
                                AssetImage('assets/images/platoVacio.jpg'),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${listaComidas[index - 1].nombreComida}",
                            style: Theme.of(context).textTheme.headline2,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        Divider(height: 3),
                        Text("6 ingredientes",
                            style: Theme.of(context).textTheme.subtitle2,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        Divider(height: 3, color: Colors.transparent),
                        Text("${listaComidas[index - 1].calorias} calorías",
                            style: Theme.of(context).textTheme.subtitle2,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        Divider(height: 3, color: Colors.transparent),
                        Text(
                            "${listaComidas[index - 1].minutosPreparacion} minutos",
                            style: Theme.of(context).textTheme.subtitle2,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
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
                                  MdiIcons.clockCheck,
                                  size: 21,
                                )
                              : Icon(
                                  MdiIcons.clockTimeFourOutline,
                                  color: Colors.grey,
                                  size: 21,
                                );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 7),
                      child: LikeButton(
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
                                  MdiIcons.heartOutline,
                                  color: Colors.grey,
                                  size: 21,
                                );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}

Future<String> getComidasHttps() async {
  try {
    print("OBTENIENDO INFORMACIÓN...");
    var response = await Dio().get('https://foodish-api.herokuapp.com/api/');
    var responseDecoded = await json.decode('$response');

    return ("${responseDecoded['image']}");
  } catch (Exception) {
    print("ERROR AL CONSUMIR API");
    return ("https://foodish-api.herokuapp.com/images/burger/burger9.jpg");
  }
}
