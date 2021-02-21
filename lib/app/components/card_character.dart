import 'package:flutter/material.dart';
import 'package:starwiki/app/models/character_model.dart';
import 'package:starwiki/app/repository/db_util.dart';
import 'package:starwiki/app/views/character_details.dart';

class CardCharacter extends StatelessWidget {
  final CharacterModel characterModel;

  const CardCharacter({Key key, this.characterModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CharacterDetailsPage(characterModel: characterModel,)));
      },
      child: Card(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(40),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          topLeft: Radius.circular(20),
          ),
          ),
        elevation: 10,
        color: Colors.grey[700],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey[800], shape: BoxShape.rectangle),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(characterModel.name),
                        IconButton(icon: Icon(
                          characterModel.isFav ? Icons.favorite :
                          Icons.favorite_border,
                          color: Colors.amber,
                        ), onPressed: (){
                          DBUtil.isFavDB('characters', characterModel.url, !characterModel.isFav);
                        })
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical:5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Height: ' + characterModel.height),
                        Text('Mass: ' + characterModel.mass),
                        Text('Gender: ' + characterModel.gender),
                      ],
                      
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
