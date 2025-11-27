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

    /*if (isFollowBack && isFollowing) {
      text = "message";
      color = Colors.grey.shade400;
    } else*/ if (isFollowing) {
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
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      focusColor: Colors.red,
      child: Container(
        margin: EdgeInsets.all(2),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
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
