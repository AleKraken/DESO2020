import 'package:bordered_text/bordered_text.dart';
import 'package:comidapp/models/comida.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DetallesComida extends StatefulWidget {
  final Comida comida;
  final int index;

  DetallesComida(this.comida, this.index);

  @override
  _DetallesComidaState createState() => _DetallesComidaState(comida, index);
}

class _DetallesComidaState extends State<DetallesComida> {
  final Comida comida;
  final int index;

  _DetallesComidaState(this.comida, this.index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
                title: BorderedText(
                  strokeWidth: 1.5,
                  child: Text(
                    "${comida.nombreComida}",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(color: Colors.white),
                  ),
                ),
                background: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Hero(
                        tag: 'heroImagen$index',
                        child:
                            Image.network(comida.rutaImagen, fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
