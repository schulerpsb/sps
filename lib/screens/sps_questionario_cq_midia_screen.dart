import 'package:flutter/material.dart';
import 'package:sps/components/centered_message.dart';
import 'package:sps/components/progress.dart';
import 'package:sps/models/sps_questionario_cq_midia.dart';
import 'sps_questionario_cq_screen.dart';

class sps_questionario_cq_midia_screen extends StatefulWidget {
  @override
  _sps_questionario_midia_screen createState() => _sps_questionario_midia_screen();
}

class _sps_questionario_midia_screen extends State<sps_questionario_cq_midia_screen> {
  final SpsQuestionarioCqMidia spsquestionariocqmidia = SpsQuestionarioCqMidia();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: new Scaffold(
          backgroundColor: Color(0xFFe9eef7), // Cinza Azulado
          appBar: AppBar(
            backgroundColor: Color(0xFF004077),
            title: Text(
              'QUESTIONÁRIO - MÍDIA',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            bottom: TabBar(
                tabs:
                [
                  Tab(icon: Icon(Icons.photo),),
                  Tab(icon: Icon(Icons.video_library),),
                  Tab(icon: Icon(Icons.audiotrack),),
                ]

            ),
          ),
          body: TabBarView(children:
          [
//             any widget can work very well here <3

            new Container(
              color: Color(0xFFe9eef7),
              child: Center(child: Text('Hi from School', style: TextStyle(color: Colors.white),),),
            ),
            new Container(
              color: Color(0xFFe9eef7),
              child: Center(child: Text('Hi from home', style: TextStyle(color: Colors.white),),),
            ),   new Container(
            color: Color(0xFFe9eef7),
            child: Center(child: Text('Hi from Hospital', style: TextStyle(color: Colors.white),),),
          ),

          ]),
        ));
  }
}
