import 'package:comidapp/DB/dataBaseProvider.dart';
import 'package:comidapp/sharedPreferences/SPHelper.dart';
import 'package:comidapp/utils/Tema.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class PantallaPrincipalCarga extends StatelessWidget {
  const PantallaPrincipalCarga({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: temaPrincipal(),
      home: PantallaCarga(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PantallaCarga extends StatefulWidget {
  PantallaCarga({Key key}) : super(key: key);

  @override
  _PantallaCargaState createState() => _PantallaCargaState();
}

class _PantallaCargaState extends State<PantallaCarga> {
  Future _futureCarga;

  @override
  void initState() {
    _futureCarga = cargarInformacion();
    super.initState();
  }

  Future cargarInformacion() async {
    return await DatabaseProvider.db.inicializarBase().then((value) {
      SharedPreferences.getInstance().then((SharedPreferences sp) {
        SPHelper.setPref(sp);
        sp.setBool('datosCargados', true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBB45C),
      body: Container(
        color: Color(0xFFFBB45C),
        child: FutureBuilder(
            future: _futureCarga,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SafeArea(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xFFFBB45C),
                          Color(0xFFFE7A66),
                        ],
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Espera un momento mientras obtenemos las recetas.",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  .copyWith(color: Colors.white),
                            ),
                            Divider(color: Colors.transparent),
                            CircularProgressIndicator(),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              child: FadeInImage(
                                placeholder: AssetImage(
                                    'assets/images/iconoPantallaPrincipal.png'),
                                image: AssetImage(
                                    'assets/images/iconoPantallaPrincipal.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return MyHomePage();
              }
            }),
      ),
    );
  }
}
