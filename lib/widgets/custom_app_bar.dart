import 'package:flutter/material.dart';
import 'package:flutter_music/screens/all_songs_screen.dart';
import 'package:flutter_music/screens/player_screen.dart';
class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const AllSongsScreen()));
          }, icon:  NavBarItem(
            icon: Icons.arrow_back_ios,
          ),),
        const Text('Playing Now',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w500),),
          IconButton(onPressed: (){}, icon:  NavBarItem(
            icon: Icons.list,
          ),),
      ],),
    );
  }

}

class NavBarItem extends StatelessWidget {
  final IconData icon;

  NavBarItem({ required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(color: Color(0xFF004e92),
                offset: Offset(5, 10),
                spreadRadius: 3,
                blurRadius: 10
            ),
            BoxShadow(color:  Color(0xFF004e92),
                offset: Offset(-3, -4),
                spreadRadius: -2,
                blurRadius: 20
            )
          ],
          color:  const Color(0xFF004e92), borderRadius: BorderRadius.circular(10)),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
