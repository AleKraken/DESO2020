import 'package:comidapp/pages/pageComidasFavoritas.dart';
import 'package:comidapp/pages/pageIngredientesFavoritos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Favoritos extends StatefulWidget {
  Favoritos({Key key}) : super(key: key);

  @override
  _FavoritosState createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {
  int _indicePagina = 0;

  var _pagesFavoritos = [
    ComidasFavoritas(),
    IngredientesFavoritos(),
  ];

  var _pagesFavoritosStr = [
    "Comidas",
    "Ingredientes",
  ];

  PageController pageController = new PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Color(0xFFFBB45C),
        toolbarHeight: 35,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: _indicePagina == 0
                        ? Color(0xFFFE7A66)
                        : Color(0xFFFBB45C),
                  ),
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    child: Text(
                      "${_pagesFavoritosStr[0]}",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          .copyWith(color: Colors.white),
                    ),
                    onPressed: () {
                      pageController.animateToPage(
                        0,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.linearToEaseOut,
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: _indicePagina == 1
                        ? Color(0xFFFE7A66)
                        : Color(0xFFFBB45C),
                  ),
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    child: Text(
                      "${_pagesFavoritosStr[1]}",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          .copyWith(color: Colors.white),
                    ),
                    onPressed: () {
                      pageController.animateToPage(
                        1,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.linearToEaseOut,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Container(
          child: PageView(
            children: _pagesFavoritos,
            controller: pageController,
            onPageChanged: (index) {
              _indicePagina = index;
              if (this.mounted) {
                setState(() {});
              }
            },
          ),
        ),
      ),
    );
  }
}
