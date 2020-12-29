import 'package:comidapp/pages/creacionComida/pageCreacionComida.dart';
import 'package:comidapp/pages/pageCarga.dart';
import 'package:comidapp/pages/pageFavoritos.dart';
import 'package:comidapp/pages/pageHorarioComidas.dart';
import 'package:comidapp/pages/pageIngredientes.dart';
import 'package:comidapp/pages/pageRecetasComidas.dart';
import 'package:comidapp/sharedPreferences/SPHelper.dart';
import 'package:comidapp/utils/Tema.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      SPHelper.setPref(sp);
      final bool datosCargados = sp.getBool('datosCargados') ?? false;
      runApp(datosCargados ? MyApp() : PantallaPrincipalCarga());
    });
  });
}

class MyApp extends StatelessWidget {
  bool datosCargados = false;
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
  int _indicePagina = 1;
  PageController _pageController;
  int paginaObjetivo = 1;

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
        floatingActionButton: paginaObjetivo == 1
            ? FloatingActionButton(
                heroTag: 'FloatingHero',
                backgroundColor: Color(0xFF45AAB4),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreacionComida(),
                    ),
                  ).then((value) {
                    if (this.mounted) {
                      setState(() {});
                    }
                  });
                },
                child: Icon(MdiIcons.plus),
              )
            : null,
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          elevation: 10,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              bottomBNB(MdiIcons.clockOutline, MdiIcons.clock, 0, "Horario"),
              bottomBNB(MdiIcons.food, MdiIcons.food, 1, "Comidas"),
              bottomBNB(
                  MdiIcons.shakerOutline, MdiIcons.shaker, 2, "Ingredientes"),
              bottomBNB(MdiIcons.heartOutline, MdiIcons.heart, 3, "Favoritos"),
            ],
          ),
        ),
        body: PageView(
            physics: NeverScrollableScrollPhysics(),
            pageSnapping: true,
            controller: _pageController,
            children: _paginas,
            onPageChanged: (index) {
              setState(() {
                _indicePagina = index;
              });
            }),
      ),
    );
  }

  Widget bottomBNB(
      IconData icono, IconData iconoSeleccionado, int index, String texto) {
    return Expanded(
      child: SizedBox(
        height: 46,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              setState(() {
                _indicePagina = index;
                paginaObjetivo = index;
                _pageController.animateToPage(
                  _indicePagina,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  index == paginaObjetivo ? iconoSeleccionado : icono,
                  color: index == paginaObjetivo
                      ? Theme.of(context).iconTheme.color
                      : Colors.grey,
                  size: 22,
                ),
                AnimatedContainer(
                    alignment: Alignment.center,
                    duration: Duration(milliseconds: 350),
                    child: Text(
                      "$texto",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle2,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
