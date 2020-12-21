class Meal {
  List<Meals> meals;

  Meal({this.meals});

  Meal.fromJson(Map<String, dynamic> json) {
    if (json['meals'] != null) {
      meals = new List<Meals>();
      json['meals'].forEach((v) {
        meals.add(new Meals.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.meals != null) {
      data['meals'] = this.meals.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meals {
  String idMeal;
  String strMeal;
  String strDrinkAlternate;
  String strCategory;
  String strArea;
  String strInstructions;
  String strMealThumb;
  String strTags;
  String strYoutube;
  int idIngredient1;
  int idIngredient2;
  int idIngredient3;
  int idIngredient4;
  int idIngredient5;
  int idIngredient6;
  int idIngredient7;
  int idIngredient8;
  int idIngredient9;
  int idIngredient10;
  int idIngredient11;
  int idIngredient12;
  int idIngredient13;
  int idIngredient14;
  int idIngredient15;
  int idIngredient16;
  int idIngredient17;
  int idIngredient18;
  int idIngredient19;
  int idIngredient20;
  String strMeasure1;
  String strMeasure2;
  String strMeasure3;
  String strMeasure4;
  String strMeasure5;
  String strMeasure6;
  String strMeasure7;
  String strMeasure8;
  String strMeasure9;
  String strMeasure10;
  String strMeasure11;
  String strMeasure12;
  String strMeasure13;
  String strMeasure14;
  String strMeasure15;
  String strMeasure16;
  String strMeasure17;
  String strMeasure18;
  String strMeasure19;
  String strMeasure20;
  String strSource;
  Null dateModified;

  Meals(
      {this.idMeal,
      this.strMeal,
      this.strDrinkAlternate,
      this.strCategory,
      this.strArea,
      this.strInstructions,
      this.strMealThumb,
      this.strTags,
      this.strYoutube,
      this.idIngredient1,
      this.idIngredient2,
      this.idIngredient3,
      this.idIngredient4,
      this.idIngredient5,
      this.idIngredient6,
      this.idIngredient7,
      this.idIngredient8,
      this.idIngredient9,
      this.idIngredient10,
      this.idIngredient11,
      this.idIngredient12,
      this.idIngredient13,
      this.idIngredient14,
      this.idIngredient15,
      this.idIngredient16,
      this.idIngredient17,
      this.idIngredient18,
      this.idIngredient19,
      this.idIngredient20,
      this.strMeasure1,
      this.strMeasure2,
      this.strMeasure3,
      this.strMeasure4,
      this.strMeasure5,
      this.strMeasure6,
      this.strMeasure7,
      this.strMeasure8,
      this.strMeasure9,
      this.strMeasure10,
      this.strMeasure11,
      this.strMeasure12,
      this.strMeasure13,
      this.strMeasure14,
      this.strMeasure15,
      this.strMeasure16,
      this.strMeasure17,
      this.strMeasure18,
      this.strMeasure19,
      this.strMeasure20,
      this.strSource,
      this.dateModified});

  Meals.fromJson(Map<String, dynamic> json) {
    idMeal = json['idMeal'];
    strMeal = json['strMeal'];
    strDrinkAlternate = json['strDrinkAlternate'];
    strCategory = json['strCategory'];
    strArea = json['strArea'];
    strInstructions = json['strInstructions'];
    strMealThumb = json['strMealThumb'];
    strTags = json['strTags'];
    strYoutube = json['strYoutube'];
    idIngredient1 = json['idIngredient1'];
    idIngredient2 = json['idIngredient2'];
    idIngredient3 = json['idIngredient3'];
    idIngredient4 = json['idIngredient4'];
    idIngredient5 = json['idIngredient5'];
    idIngredient6 = json['idIngredient6'];
    idIngredient7 = json['idIngredient7'];
    idIngredient8 = json['idIngredient8'];
    idIngredient9 = json['idIngredient9'];
    idIngredient10 = json['idIngredient10'];
    idIngredient11 = json['idIngredient11'];
    idIngredient12 = json['idIngredient12'];
    idIngredient13 = json['idIngredient13'];
    idIngredient14 = json['idIngredient14'];
    idIngredient15 = json['idIngredient15'];
    idIngredient16 = json['idIngredient16'];
    idIngredient17 = json['idIngredient17'];
    idIngredient18 = json['idIngredient18'];
    idIngredient19 = json['idIngredient19'];
    idIngredient20 = json['idIngredient20'];
    strMeasure1 = json['strMeasure1'];
    strMeasure2 = json['strMeasure2'];
    strMeasure3 = json['strMeasure3'];
    strMeasure4 = json['strMeasure4'];
    strMeasure5 = json['strMeasure5'];
    strMeasure6 = json['strMeasure6'];
    strMeasure7 = json['strMeasure7'];
    strMeasure8 = json['strMeasure8'];
    strMeasure9 = json['strMeasure9'];
    strMeasure10 = json['strMeasure10'];
    strMeasure11 = json['strMeasure11'];
    strMeasure12 = json['strMeasure12'];
    strMeasure13 = json['strMeasure13'];
    strMeasure14 = json['strMeasure14'];
    strMeasure15 = json['strMeasure15'];
    strMeasure16 = json['strMeasure16'];
    strMeasure17 = json['strMeasure17'];
    strMeasure18 = json['strMeasure18'];
    strMeasure19 = json['strMeasure19'];
    strMeasure20 = json['strMeasure20'];
    strSource = json['strSource'];
    dateModified = json['dateModified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idMeal'] = this.idMeal;
    data['strMeal'] = this.strMeal;
    data['strDrinkAlternate'] = this.strDrinkAlternate;
    data['strCategory'] = this.strCategory;
    data['strArea'] = this.strArea;
    data['strInstructions'] = this.strInstructions;
    data['strMealThumb'] = this.strMealThumb;
    data['strTags'] = this.strTags;
    data['strYoutube'] = this.strYoutube;
    data['idIngredient1'] = this.idIngredient1;
    data['idIngredient2'] = this.idIngredient2;
    data['idIngredient3'] = this.idIngredient3;
    data['idIngredient4'] = this.idIngredient4;
    data['idIngredient5'] = this.idIngredient5;
    data['idIngredient6'] = this.idIngredient6;
    data['idIngredient7'] = this.idIngredient7;
    data['idIngredient8'] = this.idIngredient8;
    data['idIngredient9'] = this.idIngredient9;
    data['idIngredient10'] = this.idIngredient10;
    data['idIngredient11'] = this.idIngredient11;
    data['idIngredient12'] = this.idIngredient12;
    data['idIngredient13'] = this.idIngredient13;
    data['idIngredient14'] = this.idIngredient14;
    data['idIngredient15'] = this.idIngredient15;
    data['idIngredient16'] = this.idIngredient16;
    data['idIngredient17'] = this.idIngredient17;
    data['idIngredient18'] = this.idIngredient18;
    data['idIngredient19'] = this.idIngredient19;
    data['idIngredient20'] = this.idIngredient20;
    data['strMeasure1'] = this.strMeasure1;
    data['strMeasure2'] = this.strMeasure2;
    data['strMeasure3'] = this.strMeasure3;
    data['strMeasure4'] = this.strMeasure4;
    data['strMeasure5'] = this.strMeasure5;
    data['strMeasure6'] = this.strMeasure6;
    data['strMeasure7'] = this.strMeasure7;
    data['strMeasure8'] = this.strMeasure8;
    data['strMeasure9'] = this.strMeasure9;
    data['strMeasure10'] = this.strMeasure10;
    data['strMeasure11'] = this.strMeasure11;
    data['strMeasure12'] = this.strMeasure12;
    data['strMeasure13'] = this.strMeasure13;
    data['strMeasure14'] = this.strMeasure14;
    data['strMeasure15'] = this.strMeasure15;
    data['strMeasure16'] = this.strMeasure16;
    data['strMeasure17'] = this.strMeasure17;
    data['strMeasure18'] = this.strMeasure18;
    data['strMeasure19'] = this.strMeasure19;
    data['strMeasure20'] = this.strMeasure20;
    data['strSource'] = this.strSource;
    data['dateModified'] = this.dateModified;
    return data;
  }
}
