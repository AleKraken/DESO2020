import 'package:comidapp/DB/dataBaseProvider.dart';
import 'package:comidapp/models/ingrediente.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:like_button/like_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class IngredientesFavoritos extends StatefulWidget {
  IngredientesFavoritos({Key key}) : super(key: key);

  @override
  _IngredientesFavoritosState createState() => _IngredientesFavoritosState();
}

class _IngredientesFavoritosState extends State<IngredientesFavoritos> {
  Future _futureIngredientes;
  List<Ingrediente> listaIngredientes = new List<Ingrediente>();

  @override
  void initState() {
    super.initState();
    _futureIngredientes = _getIngredientes();
  }

  Future _getIngredientes() async {
    await DatabaseProvider.db.getIngredientesFavoritos().then(
      (lIngredientes) {
        if (this.mounted) {
          setState(() {
            listaIngredientes = lIngredientes;
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
                  return listaIngredientes.length > 0
                      ? ListaContenedoresIngredientes(listaIngredientes)
                      : Container();
                }
              }),
        ),
      ),
    );
  }
}

class ListaContenedoresIngredientes extends StatelessWidget {
  final List<Ingrediente> listaIngredientes;

  ListaContenedoresIngredientes(this.listaIngredientes);

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 30, crossAxisCount: 3),
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: listaIngredientes.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 550),
              delay: const Duration(milliseconds: 80),
              child: SlideAnimation(
                verticalOffset: 60.0,
                child: FadeInAnimation(
                  child: ContenedorIngrediente(index, listaIngredientes),
                ),
              ),
            );
          }),
    );
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

  @override
  Widget build(BuildContext context) {
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
                image: index > 534
                    ? AssetImage('assets/images/ingredienteCargando.png')
                    : NetworkImage(
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
                            MdiIcons.thumbDown,
                            color: Theme.of(context).iconTheme.color,
                            size: 21,
                          )
                        : Icon(
                            MdiIcons.thumbDownOutline,
                            color: Colors.white,
                            size: 21,
                          );
                  },
                ),
                LikeButton(
                  isLiked: listaIngredientes[index].favoritoIngrediente == 1
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
                            MdiIcons.heartOutline,
                            color: Colors.white,
                            size: 21,
                          );
                  },
                  onTap: (favoritoSeleccionado) async {
                    if (listaIngredientes[index].favoritoIngrediente == 0) {
                      await DatabaseProvider.db.setIngredienteFavorito(
                          listaIngredientes[index].idIngrediente, 1);

                      listaIngredientes[index].favoritoIngrediente = 1;
                      print("ISERTANDO ELEMENTO");
                      return !favoritoSeleccionado;
                    } else {
                      await DatabaseProvider.db.setIngredienteFavorito(
                          listaIngredientes[index].idIngrediente, 0);
                      listaIngredientes[index].favoritoIngrediente = 0;
                      print("ELIMINANDO ELEMENTO");
                      return !favoritoSeleccionado;
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
