import 'package:peliculasrdr/src/providers/peliculas_providers.dart';
import 'package:peliculasrdr/src/widgets/card_swiper_widget.dart';
import 'package:peliculasrdr/src/widgets/movie_horizontal.dart';
import 'package:peliculasrdr/src/search/search_delegate.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopulares();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Peliculas en Cartelera'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              }),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _swiperTarjetas(),
            SizedBox(
              height: 10.0,
            ),
            _footer(context),
          ],
        ),
      ),

      // _lista(),
    );
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwipper(
            peliculas: snapshot.data,
          );
        } else {
          return Container(
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 10.0),
              child: Text('Populares',
                  style: Theme.of(context).textTheme.headline6)),
          SizedBox(
            height: 10.0,
          ),
          //FutureBuilder( ---> Se ejecuta una sola vez
          StreamBuilder(
            // --- Se ejecuta cada vez que se emita un valor en el stream
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares,
                );
              } else {
                return Container(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
