import 'package:comidapp/pages/pageFavoritos.dart';
import 'package:comidapp/pages/pageHorarioComidas.dart';
import 'package:comidapp/pages/pageIngredientes.dart';
import 'package:comidapp/pages/pageRecetas.dart';
import 'package:comidapp/utils/Tema.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: temaPrincipal(),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _indicePagina = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _indicePagina);
  }

  var _paginas = [
    HorarioComidas(),
    RecetasComidas(),
    Ingredientes(),
    Favoritos(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: _indicePagina,
      child: new Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        bottomNavigationBar: AnimatedContainer(
          duration: Duration(milliseconds: 350),
          height: 50,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 30),
            physics: NeverScrollableScrollPhysics(),
            child: BottomNavigationBar(
              fixedColor: Colors.black,
              type: BottomNavigationBarType.fixed,
              currentIndex: _indicePagina,
              iconSize: Theme.of(context).iconTheme.size,
              unselectedFontSize: 9,
              selectedFontSize: 12,
              selectedIconTheme: Theme.of(context).iconTheme.copyWith(size: 25),
              items: [
                BottomNavigationBarItem(
                    label: "Horario",
                    activeIcon: Icon(
                      MdiIcons.clockTimeEight,
                    ),
                    icon: Icon(
                      MdiIcons.clockTimeEightOutline,
                    )),
                BottomNavigationBarItem(
                    label: "Comidas",
                    activeIcon: Icon(
                      MdiIcons.noodles,
                    ),
                    icon: Icon(
                      MdiIcons.noodles,
                    )),
                BottomNavigationBarItem(
                    label: "Ingredientes",
                    activeIcon: Icon(
                      MdiIcons.shaker,
                    ),
                    icon: Icon(
                      MdiIcons.shakerOutline,
                    )),
                BottomNavigationBarItem(
                    label: "Favoritos",
                    activeIcon: Icon(
                      MdiIcons.heart,
                    ),
                    icon: Icon(
                      MdiIcons.heartOutline,
                    )),
              ],
              onTap: (index) {
                setState(() {
                  _indicePagina = index;
                  _pageController.jumpToPage(_indicePagina);
                });
              },
            ),
          ),
        ),
        body: PageView(
            pageSnapping: true,
            controller: _pageController,
            children: _paginas,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _indicePagina = index;
              });
            }),
      ),
    );
  }
}
