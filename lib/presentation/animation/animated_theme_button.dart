import 'package:flutter/material.dart';

class AnimationRotateWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback callback;

  const AnimationRotateWrapper(
      {super.key, required this.child, required this.callback});

  @override
  State<AnimationRotateWrapper> createState() => _AnimationRotateWrapperState();
}

class _AnimationRotateWrapperState extends State<AnimationRotateWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    animation = Tween<double>(begin: 0.0, end: 1).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () => {controller.forward(from: 0.0), widget.callback()},
        child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: RotationTransition(turns: animation, child: widget.child)));
  }
}
