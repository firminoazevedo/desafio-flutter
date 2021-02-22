import 'package:flutter/material.dart';
import 'package:starwiki/app/models/character_model.dart';
import 'package:starwiki/app/repository/db_util.dart';
import 'package:starwiki/app/views/character_details.dart';

class CardCharacter extends StatefulWidget {
  final CharacterModel characterModel;

  const CardCharacter({Key key, this.characterModel}) : super(key: key);

  @override
  _CardCharacterState createState() => _CardCharacterState();
}

class _CardCharacterState extends State<CardCharacter> {
  @override
  Widget build(BuildContext context) {
    //final CharacterModel characterModel = Provider.of<CharacterModel>(context);
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CharacterDetailsPage(characterModel: widget.characterModel,)));
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
                        Text(widget.characterModel.name),
                        IconButton(icon: Icon(
                          widget.characterModel.isFav ? Icons.favorite :
                          Icons.favorite_border,
                          color: Colors.amber,
                        ), onPressed: (){
                          DBUtil.favoriteUpdate('characters', widget.characterModel.url, !widget.characterModel.isFav);
                          widget.characterModel.toggleIsFav();
                          setState(() {});
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
                        Text('Height: ' + widget.characterModel.height),
                        Text('Mass: ' + widget.characterModel.mass),
                        Text('Gender: ' + widget.characterModel.gender),
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
