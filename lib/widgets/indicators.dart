import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

Center circularProgress(context) {
  return Center(
    child: SpinKitFadingCircle(
      size: 40.0,
      color: Color(0xfff84646),
    ),
  );
}

Container linearProgress(context) {
  return Container(
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Color(0xfff84646)),
    ),
  );
}
