import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp( DonutChart());
}
class DataItem{
  final double value;
  final String label;
  final Color color;
  DataItem(this.value,this.label,this.color);

}
const pal=[0xFFF2387C,0xdff05c7f2,0xff04d9c4,0xfff2b705,0xfff26241];
class DonutChart extends StatelessWidget {
  
  final List<DataItem> dataset=[
    DataItem(0.2, "Comedy",Color(pal[0])),
 
  DataItem(0.25, "Action", Color(pal[1])),
  DataItem(0.3, "Romance", Color(pal[2])),
  DataItem(0.05, "Drama",Color(pal[3])),
  DataItem(0.2, "SciFi", Color(pal[4])),
  
];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Container(child: DonutChartWidget(dataset),),
    );
  }
}

class DonutChartWidget extends StatefulWidget {

  final List<DataItem> dataset;
  DonutChartWidget(this.dataset);

  @override
  State<DonutChartWidget> createState() => _DonutChartWidgetState();
}

class _DonutChartWidgetState extends State<DonutChartWidget> {
  late Timer timer;
  double fullAngle=0.0;
  double secondToComplete=5.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer=Timer.periodic(Duration(milliseconds: 100~/60), (timer) { 
setState(() {
  fullAngle+=360.0/(secondToComplete*1000~/60);
  if(fullAngle>=360){
    fullAngle=360.0;
    timer.cancel();
  }
});
    });
  }
@override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(child: Container(),
      painter: DonutCharPainter(widget.dataset,fullAngle)),
    );
  }
}
final linePaint=Paint()..color=Colors.white..strokeWidth=2.0..style=PaintingStyle.stroke;

final midPaint=Paint()..color=Colors.white..style=PaintingStyle.fill;
const textFieldTextBigStyle=TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 30.0);
const labelStyle=TextStyle(color: Colors.black,fontSize: 12.0);
class DonutCharPainter extends CustomPainter {
  final List<DataItem> dataset;
  final double fullAngle;
  DonutCharPainter(this.dataset,this.fullAngle);
  @override
  void paint(Canvas canvas, Size size) {

  final c=Offset(size.width/2.0, size.height/2.0);final radius=size.width*0.9;

final rect=Rect.fromCenter(center: c, width: radius, height: radius);

var startAngle=0.0;

dataset.forEach((di) {
  final sweepAngle=di.value*fullAngle*pi/180.0;
   drawSector(canvas, di, rect, startAngle,sweepAngle);  
    startAngle+=sweepAngle;
    });

   startAngle=0.0;
    dataset.forEach((di) {
      final sweepAngle=di.value*fullAngle*pi/180.0;
       drawLines(canvas, c, radius, startAngle);
       startAngle+=sweepAngle;
    });
     startAngle=0.0;
    dataset.forEach((di) {
      final sweepAngle=di.value*fullAngle*pi/180.0;
       drawLabels(canvas, c, radius, startAngle,sweepAngle,di.label);
       startAngle+=sweepAngle;
    });
    
    canvas.drawCircle(c, radius*0.3, midPaint);
    drawTextCentered(canvas, c, "Favourite\n Games\n Movies", textFieldTextBigStyle, radius*0.6,(Size sz){});
  }
    void drawLabels(Canvas canvas, Offset c, double radius, double startAngle, double sweepAngle, String label) {
      final r=radius*0.4;
      final dx=r*cos(startAngle+sweepAngle/2.0);
            final dy=r*sin(startAngle+sweepAngle/2.0);
            final position=c+Offset(dx,dy);
            drawTextCentered(canvas, position, label, labelStyle, 100.0,(Size sz){
              final rect=Rect.fromCenter(center: position, width: sz.width+5, height: sz.height+5);
              final rrect=RRect.fromRectAndRadius(rect, Radius.circular(5));
              canvas.drawRRect(rrect,midPaint);
            });

    }
  
  TextPainter measureText(String s,TextStyle style,double maxWidth,TextAlign align){
    final span=TextSpan(text:s,style:style);
    final tp=TextPainter(text: span,textAlign:align,textDirection: TextDirection.ltr);
    tp.layout(minWidth: 0,maxWidth: maxWidth);
    return tp;
  }
  
 Size drawTextCentered(Canvas canvas,Offset position,String text,TextStyle style,double maxWidth,Function(Size sz) bgCb){
  final tp=measureText(text, style, maxWidth, TextAlign.center);
  final pos=position+Offset(-tp.width/2.0,-tp.height/2.0);
  bgCb(tp.size);

  tp.paint(canvas, pos);
  return tp.size;
 }


  void drawLines(Canvas canvas, Offset c,double radius ,double startAngle ) {
    final dx=radius/2.0*cos(startAngle);
    final dy=radius/2.0*sin(startAngle);
    final p2=c+Offset(dx, dy);
    canvas.drawLine(c, p2, linePaint);
  }

  void drawSector(Canvas canvas, DataItem di, Rect rect, double startAngle,double sweepAngle) {
   
    final paint=Paint()..style=PaintingStyle.fill..color=di.color;
    canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>true;
  
  
}