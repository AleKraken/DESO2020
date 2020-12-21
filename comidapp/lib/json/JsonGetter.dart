import 'dart:convert';

import 'package:comidapp/json/ingredientFromJson.dart';
import 'package:comidapp/json/mealsFromJson.dart';
import 'package:flutter/services.dart';

class JsonGetter {
  static Future<Ingredient> getIngredientes() async {
    Ingredient ingredientes = new Ingredient();

    try {
      final jsonString =
          await rootBundle.loadString("assets/jsons/ingredienteJson.json");

      Map<String, dynamic> ingredienteMap = await jsonDecode(jsonString);
      Ingredient ingrediente = Ingredient.fromJson(ingredienteMap);

      ingredientes = ingrediente;
    } catch (Exception) {
      print("ERROR AL CONSUMIR API EN INGREDIENTE");
      return new Ingredient();
    }

    return ingredientes;
  }

  static Future<Meal> getComidas() async {
    Meal listaComidas = new Meal();
    try {
      print("INTENTANDO CARGAR JSON");
      final jsonString =
          await rootBundle.loadString("assets/jsons/comidaJson.json");
      print("JSON CARGADO E INTENTANDO MAPEAR");

      Map<String, dynamic> comidaMap = await jsonDecode(jsonString);
      print("MAPEADO LISTO");
      Meal comidas = Meal.fromJson(comidaMap);
      print("LISTA LISTA");

      listaComidas = comidas;
    } catch (Exception) {
      print("ERROR AL CONSUMIR API EN COMIDA");
      return new Meal();
    }

    return listaComidas;
  }
}
