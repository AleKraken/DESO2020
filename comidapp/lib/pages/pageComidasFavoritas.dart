import 'package:comidapp/DB/dataBaseProvider.dart';
import 'package:comidapp/models/comida.dart';
import 'package:comidapp/pages/pageVistaReceta.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:like_button/like_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ComidasFavoritas extends StatefulWidget {
  ComidasFavoritas({Key key}) : super(key: key);

  @override
  _ComidasFavoritasState createState() => _ComidasFavoritasState();
}

class _ComidasFavoritasState extends State<ComidasFavoritas> {
  Future _futureComidas;
  List<Comida> listaComidas = new List<Comida>();

  @override
  void initState() {
    super.initState();
    _futureComidas = _getComidas();
  }

  Future _getComidas() async {
    await DatabaseProvider.db.getComidasFavoritas().then(
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
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
                  return listaComidas.length > 0
                      ? ListaContenedoresComidas(listaComidas)
                      : Container();
                }
              }),
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
          itemCount: listaComidas.length,
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

class ContenedorComida extends StatelessWidget {
  final int index;
  final List<Comida> listaComidas;

  ContenedorComida(this.index, this.listaComidas);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      decoration: BoxDecoration(
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
                      decoration: BoxDecoration(
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
                          Divider(height: 3),
                          Text(
                              "${listaComidas[index].listaIngredientesEnComida.length} ingredientes",
                              style: Theme.of(context).textTheme.subtitle2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          Divider(height: 3, color: Colors.transparent),
                          Text("${listaComidas[index].calorias} calorías",
                              style: Theme.of(context).textTheme.subtitle2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          Divider(height: 3, color: Colors.transparent),
                          Text(
                              "${listaComidas[index].minutosPreparacion} minutos",
                              style: Theme.of(context).textTheme.subtitle2,
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
                            color: Theme.of(context).iconTheme.color,
                            size: 21,
                          )
                        : Icon(
                            MdiIcons.clockTimeFour,
                            color: Color(0xFFB9B9B9),
                            size: 21,
                          );
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
}
