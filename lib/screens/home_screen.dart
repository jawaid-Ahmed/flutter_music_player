import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade700,
                      ),
                      child: const Icon(
                        Icons.play_circle_outline,
                        size: 32,
                        color: Colors.white,
                      )),
                  const Expanded(
                    child: Text(
                      'Ui Design this is the song name which was playing last time',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
              background: const Image(
                image: AssetImage('assets/images/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            pinned: false,
            expandedHeight: MediaQuery.of(context).size.height * 0.3,
            backgroundColor: Colors.black,
            elevation: 0.0,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.list,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ],

          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                            Color(0xFF360603),
                            Color(0xFF210908),
                            Color(0xFF0d0504)
                          ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          itemCount: 25,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                height: 50,
                                decoration:
                                    const BoxDecoration(color: Colors.purple),
                                margin: const EdgeInsets.all(5));
                          })),
                ],
              ),
            )
          ])),
        ],
      ),
    );
  }
}
