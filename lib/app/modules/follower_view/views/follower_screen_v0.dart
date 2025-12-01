import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../globle_widgets/follow/follow_btn.dart';
import '../controllers/follower_controller.dart';

class FollowerScreen extends GetView<FollowerController> {
  const FollowerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Followers'),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Obx(() {
        // 1. Loading State
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. Error State
        if (controller.isError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: controller.fetchFollowers,
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        // 3. Empty State
        if (controller.followersList.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.fetchFollowers,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: Get.height * 0.7,
                  child: Center(
                    child: Text(
                      "No followers yet",
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // 4. List State
        return RefreshIndicator(
          onRefresh: controller.fetchFollowers,
          child: ListView.builder(
            controller: controller.scrollController,
            padding: const EdgeInsets.only(
              left: 16,
              right: 4,
              top: 4,
              bottom: 4,
            ),
            itemCount: controller.followersList.length,
            // separatorBuilder: (_, __) =>
            //     const Divider(height: 20, thickness: 0.5),
            itemBuilder: (context, index) {
              final item = controller.followersList[index];
              final user = item.follower;

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                      (user?.avatar != null && user!.avatar!.isNotEmpty)
                      ? NetworkImage(user.avatar!)
                      : null,
                  child: (user?.avatar == null || user!.avatar!.isEmpty)
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                ),
                title: Text(
                  user?.name ?? "Unknown User",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "@${user?.username ?? "username"}",
                  style: context.textTheme.labelSmall,
                ),
                trailing: FollowBtn(
                  isFollowing: user?.isFollowing ?? false,
                  isFollowBack: user?.isFollowBack ?? false,
                  onTap: () {
                    final isFollowing = user?.isFollowing ?? false;
                    final isFollowBack = user?.isFollowBack ?? false;
                    /*if (isFollowing && isFollowBack) {
                      debugPrint("Id: ${user!.id}");
                      debugPrint("Message");
                    } else */if (isFollowing) {
                      controller.unFollow(user!.id!);
                    } else {
                      controller.follow(user!.id!);
                    }
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
