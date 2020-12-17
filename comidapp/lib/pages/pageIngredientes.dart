import 'package:comidapp/DB/dataBaseProvider.dart';
import 'package:comidapp/models/ingrediente.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:like_button/like_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progressive_image/progressive_image.dart';

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
        setState(() {
          listaIngredientes = lIngredientes;
        });
      },
    );
    return Future.delayed(Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        toolbarHeight: 35,
        title: Center(
          child: Text("Ingredientes",
              style: Theme.of(context).textTheme.headline1),
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
                return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: ListaContenedoresIngredientes(listaIngredientes),
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
            blurRadius: 13,
            color: Theme.of(context).shadowColor,
            offset: const Offset(0, 4),
            spreadRadius: -6,
          ),
        ],
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).cardColor,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
            child: Text("${listaIngredientes[index].nombreIngrediente}",
                style: Theme.of(context).textTheme.headline2,
                textScaleFactor: .8,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            height: 50,
            width: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ProgressiveImage(
                placeholder:
                    AssetImage('assets/images/ingredienteCargando.png'),
                thumbnail: AssetImage('assets/images/ingredienteCargando.png'),
                image: NetworkImage(
                    '${listaIngredientes[index].rutaImagenIngrediente}'),
                height: 300,
                width: 500,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.05),
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
                        ? Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 6,
                                  color: Theme.of(context).shadowColor,
                                  spreadRadius: -2,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              MdiIcons.clockCheck,
                              color: Theme.of(context).iconTheme.color,
                              size: 21,
                            ),
                          )
                        : Icon(
                            MdiIcons.clockTimeFourOutline,
                            color: Colors.grey,
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
                        ? Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 6,
                                  color: Theme.of(context).shadowColor,
                                  spreadRadius: -2,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              MdiIcons.heart,
                              color: Colors.red,
                              size: 21,
                            ),
                          )
                        : Icon(
                            MdiIcons.heartOutline,
                            color: Colors.grey,
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
