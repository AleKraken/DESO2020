import 'dart:convert';

import 'package:comidapp/models/mealsFromJson.dart';
import 'package:http/http.dart' as http;

class ApiExterna {
  static Future<List<Meal>> getComidasDeApi() async {
    List<Meal> listaComidas = new List<Meal>();
    int idMeal = 52772;

    for (int i = 0; i < 250; i++) {
      try {
        final response = await http.get(
            'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$idMeal');

        Map<String, dynamic> comidaMap = await jsonDecode(response.body);
        Meal comida = Meal.fromJson(comidaMap);

        if (comida.meals[0] != null) {
          print("ELEMENTO $i, VALOR: ${comida.meals[0]}");
          listaComidas.add(comida);
        } else {
          print("$i ES NULO");
        }
      } catch (Exception) {
        print("ERROR AL CONSUMIR API");
      }
      idMeal++;
    }
    return listaComidas;
  }
}
