import 'dart:async';
import 'dart:convert' as convert;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gv_meta_clock/models/employee.dart';
import 'package:gv_meta_clock/models/record_employee.dart';
import 'package:gv_meta_clock/services/record_employee.service.dart';
import 'package:toast/toast.dart';


class CamWidget extends StatefulWidget {
  final CameraDescription cam;
  final RecordEmployee record;
  final Employee employee;


  const CamWidget({super.key, required this.cam, required this.record, required this.employee});

  @override
  State<CamWidget> createState() => _CamWidgetState();
}

class _CamWidgetState extends State<CamWidget> {
  late CameraController _controller;
  Duration timer = const Duration(seconds: 3);
  Timer? counter;

  BuildContext? ctx; 

  void startTimer() {
    counter =
        Timer.periodic(const Duration(seconds: 1), (_) => setCounterDown());
  }

  void setCounterDown(){
    const reduce = 1;
    setState(() {
      final seconds = timer.inSeconds - reduce;
      if (seconds < 0) {
        counter!.cancel();
        takePicture();
      } else {
        timer = Duration(seconds: seconds);
      }
    });
  }

  Future<void> takePicture() async {
    final photo = await _controller.takePicture();
    final photoAsBytes = await photo.readAsBytes();
    final photoBase64 = convert.base64Encode(photoAsBytes);
    widget.record.photo = photoBase64;
    final notify = await RecordEmployeeService().register(widget.record);    
    final bg = notify.status == 200 ? Colors.green : notify.status == 300 ? Colors.amber :  Colors.red;
    Toast.show(notify.message,backgroundColor: bg, duration: Toast.lengthLong, gravity: Toast.bottom );
    Navigator.pop(ctx!); 
  }

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.cam, ResolutionPreset.low);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });    
    startTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String strDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    
    ToastContext().init(context);

    if (!_controller!.value.isInitialized) {
      return Container();
    }

    ctx = context;

    final seconds = timer.inSeconds.remainder(60).toString(); //strDigits();
    
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          CameraPreview(_controller),

          Text(
            seconds,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 48),
          ),          
          Text(
            " \n\n\n${widget.employee.badge} - ${widget.employee.fullName}", 
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold, 
              fontSize: 32
            ),
          )
        ],
      ),
    );
// final seconds = strDigits(myDuration.inSeconds.remainder(60));
  }
}
