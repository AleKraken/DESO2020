import 'package:cached_network_image/cached_network_image.dart';
import 'package:comidapp/DB/dataBaseProvider.dart';
import 'package:comidapp/models/ingrediente.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:like_button/like_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:octo_image/octo_image.dart';

class Ingredientes extends StatefulWidget {
  Ingredientes({Key key}) : super(key: key);

  @override
  _IngredientesState createState() => _IngredientesState();
}

class _IngredientesState extends State<Ingredientes> {
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
      body: Center(
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
                return SliverSuperior(listaIngredientes);
              }
            },
          ),
        ),
      ),
    );
  }
}

class SliverSuperior extends StatelessWidget {
  final List<Ingrediente> listaIngredientes;

  const SliverSuperior(this.listaIngredientes);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 180.0,
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
            child: FlexibleSpaceBar(
              centerTitle: true,
              title: Container(
                alignment: Alignment.bottomCenter,
                child: Text("Ingredientes recomendados",
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
                            'assets/images/ingredientesPortada.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Divider(color: Colors.transparent, height: 35),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 0, mainAxisSpacing: 45, crossAxisCount: 3),
          delegate: SliverChildListDelegate(
            getContenedores(listaIngredientes),
          ),
        ),
      ],
    );
  }
}

getContenedores(List<Ingrediente> listaIngredientes) {
  List<Widget> listaContenedores = new List<Widget>();

  for (int i = 0; i < listaIngredientes.length; i++) {
    listaContenedores.add(ContenedorIngrediente(i, listaIngredientes));
  }

  return listaContenedores;
}

class ListaContenedoresIngredientes extends StatelessWidget {
  final List<Ingrediente> listaIngredientes;

  ListaContenedoresIngredientes(this.listaIngredientes);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height) / 3.8;
    final double itemWidth = size.width / 2;

    return AnimationLimiter(
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: (itemWidth / itemHeight),
              mainAxisSpacing: 30,
              crossAxisCount: 3),
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

class SearchBar extends StatelessWidget {
  const SearchBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      alignment: Alignment.topCenter,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImagenIngrediente extends StatelessWidget {
  final String rutaImagen;
  const ImagenIngrediente(this.rutaImagen);

  @override
  Widget build(BuildContext context) {
    try {
      return CachedNetworkImage(
        useOldImageOnUrlChange: true,
        imageUrl: rutaImagen,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) {
          return Image(
            image: AssetImage("assets/images/ingredienteCargando.png"),
          );
        },
      );
    } catch (e) {
      return Image(
        image: AssetImage("assets/images/ingredienteCargando.png"),
      );
    }
  }
}
