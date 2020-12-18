class Ingredient {
  List<Ingredients> ingredientes;

  Ingredient({this.ingredientes});

  Ingredient.fromJson(Map<String, dynamic> json) {
    if (json['meals'] != null) {
      ingredientes = new List<Ingredients>();
      json['meals'].forEach((v) {
        ingredientes.add(new Ingredients.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ingredientes != null) {
      data['meals'] = this.ingredientes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ingredients {
  String idIngredient;
  String strIngredient;
  String strDescription;
  String strType;

  Ingredients(
      {this.idIngredient,
      this.strIngredient,
      this.strDescription,
      this.strType});

  Ingredients.fromJson(Map<String, dynamic> json) {
    idIngredient = json['idIngredient'];
    strIngredient = json['strIngredient'];
    strDescription = json['strDescription'];
    strType = json['strType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idIngredient'] = this.idIngredient;
    data['strIngredient'] = this.strIngredient;
    data['strDescription'] = this.strDescription;
    data['strType'] = this.strType;
    return data;
  }
}
