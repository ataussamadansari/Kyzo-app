import 'package:flutter/material.dart';

class FollowBtn extends StatelessWidget {
  final bool isFollowing;
  final bool isFollowBack;
  final VoidCallback onTap;

  const FollowBtn({
    super.key,
    required this.isFollowing,
    required this.isFollowBack,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;

    if (isFollowing) {
      text = "Unfollow";
      color = Colors.red;
    } else if (isFollowBack) {
      text = "Follow Back";
      color = Colors.blue;
    } else {
      text = "Follow";
      color = Colors.blue;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
