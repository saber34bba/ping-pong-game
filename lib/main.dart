import 'dart:io';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Animation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

Animation<double> animation;
AnimationController controller;
double posX = 0;
double posY = 0;
int score = 0;
enum Direction { up, down, left, right }

class _HomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;
  double width;
  double height;

  double lineposition = 0;

  void screenedge() {
    if (posX <= -100 && hDir == Direction.left) {
      hDir = Direction.right;
    }
    if (width != null) if (posX >= width - 100 && hDir == Direction.right) {
      hDir = Direction.left;
    }

    if (posY >= height - 110 - 30 && vDir == Direction.down) {
      if (posX >= (lineposition) && posX <= (lineposition + 200)) {
        show = true;
        score++;
        vDir = Direction.up;
      } else {
        dialog();

        controller.stop();
      }
    }
    if (posY <= -100 && vDir == Direction.up) {
      vDir = Direction.down;
    }
  }

  @override
  void initState() {
    posX = 0;
    posY = 0;
    controller = AnimationController(
      duration: const Duration(seconds: 10000),
      vsync: this,
    );

    animation = Tween<double>(begin: 0, end: 0).animate(controller);

    animation.addListener(() {
      setState(() {
        (hDir == Direction.right) ? posX += 8 : posX -= 8;
        (vDir == Direction.down) ? posY += 8 : posY -= 8;
      });
      screenedge();
    });
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green,
              title: Text('Game'),
            ),
            body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              height = constraints.maxHeight;
              width = constraints.maxWidth;
              return Stack(
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.green,
                              height: 36,
                              thickness: 3,
                            ),
                          ),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.green, width: 3)),
                          ),
                              Expanded(
                            child: Divider(
                              color: Colors.green,
                              height: 36,
                              thickness: 3,
                            ),
                          ),
                        ],
                      )),
                  showScore(),
                  Positioned(
                      top: 10,
                      left: 10,
                      child: Text("Score:\t" + score.toString())),
               
                  /*for (int i=1;i<3;i++)
                    Positioned(
                    top:posY>0? posY-i*20:posY+i*20,
                    left:posX<0? posX-i*20:posX+i*20,
                    child: CustomPaint(
                      painter: Ballshadow(),
                    ),
                  ),*/
                     Positioned(
                    top: posY,
                    left: posX,
                    child: CustomPaint(
                      painter: Ball(),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: lineposition,
                    child: GestureDetector(
                      onHorizontalDragStart: (DragStartDetails e) {},
                      onHorizontalDragUpdate: (DragUpdateDetails details) {
                        setState(() {
                          /* if( details.delta.dx>=0.2 || details.delta.dx<=-0.2)
                          {

                          }
                          else*/
                          lineposition += details.delta.dx;
                        });
                      },
                      child: CustomPaint(
                        size: Size(300, MediaQuery.of(context).size.height),
                        painter: Line(start: lineposition),
                      ),
                    ),
                  )
                ],
              );
            })),
      ),
    );
  }

  bool show = false;
  Widget showScore() {
       return show
        ? Align(
            alignment: Alignment.center,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 300),
              duration: const Duration(seconds: 5),
              builder: (BuildContext context, double size, child) {
                 Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        show = false;
      });
    });
                return Text(
                  score.toString(),
                  style: TextStyle(fontSize: 30),
                );
              },
            ),
          )
        : Container();
  }

  void dialog() {
    score = 0;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('try again'),
          content: Container(
              height: 100,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Material(
                          child: InkWell(
                            highlightColor: Colors.green,
                            onTap: () {
                              setState(() {
                                controller.forward();
                                posX = 0;
                                posY = 0;
                              });
                              Navigator.pop(context);
                              //  controller.reverse();
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: Text("Restart"),
                            ),
                          ),
                        ),
                        Material(
                          child: InkWell(
                            highlightColor: Colors.green,
                            onTap: () {
                              exit(0);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(10),
                              child: Text("Exit"),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class Ball extends CustomPainter {


  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = new Paint()
      ..color =  Colors.green
      ..strokeWidth = 3;

    canvas.drawCircle(Offset(100, size.height + 100), 30, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class Ballshadow extends CustomPainter {


  @override
  void paint(Canvas canvas, Size size) {
    Paint _paint = new Paint()
      ..color =  Colors.red[200].withOpacity(0.8)
      ..strokeWidth = 3;

    canvas.drawCircle(Offset(100, size.height + 100), 30, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class Line extends CustomPainter {
  double start;
  Line({this.start});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.green[100]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    Path path = Path();
    path.moveTo(size.width / 2, size.height - 0);
    path.relativeLineTo(size.width / 3, 0);
    canvas.drawPath(path, paint);
/*var paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 30;
  Offset start = Offset(this.start+100, size.height );
    Offset end = Offset(size.width, size.height );

    canvas.drawLine(start, end, paint,);
*/
    /* Path path=Path()
   ..moveTo(0, size.height-100)
   ..lineTo(size.width, size.height/2);


canvas.drawPath(path, paint);
*/
  }
  /* @override
  bool hitTest(Offset position) {
    bool hit = path.contains(position);
    return hit;
  }*/

  /*  @override
    bool shouldRepaint(Line oldDelegate) {
    return oldDelegate.start!=start;
   
  }
*/
  @override
  bool shouldRepaint(Line oldDelegate) => oldDelegate.start != start;
}
