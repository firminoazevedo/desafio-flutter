class CharacterModel {
  String name = '';
  String height = '';
  String mass = '';
  String hairColor = '';
  String skinColor = '';
  String eyeColor = '';
  String birthYear = '';
  String gender = '';
  String homeworld = '';
  ///String planetName = '';
  //String specieName = '';
  String url = '';
  bool isFav = true;
  //List<String> species;

  CharacterModel(
      {this.name,
      this.height,
      this.mass,
      this.hairColor,
      this.skinColor,
      this.eyeColor,
      this.birthYear,
      this.gender,
      this.homeworld,
      this.isFav,
      //this.planetName,
      //this.specieName,
      this.url,
      //this.species
      });

  CharacterModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    height = json['height'];
    mass = json['mass'];
    hairColor = json['hair_color'];
    skinColor = json['skin_color'];
    eyeColor = json['eye_color'];
    birthYear = json['birth_year'];
    gender = json['gender'];
    homeworld = json['homeworld'];
    //planetName = json['planetName'] ?? '';
    //specieName = json['specieName'] ?? '';
    url = json['url'];
    //species = json['species'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['height'] = this.height;
    data['mass'] = this.mass;
    data['hair_color'] = this.hairColor;
    data['skin_color'] = this.skinColor;
    data['eye_color'] = this.eyeColor;
    data['birth_year'] = this.birthYear;
    data['gender'] = this.gender;
    data['homeworld'] = this.homeworld;
    data['isFav'] = this.isFav;
    //data['planetName'] = this.planetName;
    //data['specieName'] = this.specieName;
    //data['species'] = this.species;
    data['url'] = this.url;
    return data;
  }
}
