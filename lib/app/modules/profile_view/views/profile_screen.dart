import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const avatarSize = 90.0;

    return DefaultTabController(
      length: 3, // All, Photos, Videos
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Obx(() => Text(controller.username.value)),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: controller.openSettings,
            ),
          ],
        ),

        /// full scroll + pinned tabs
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [

              /// -------- PROFILE HEADER (scrollable) --------
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// Top Row => Avatar left + counts right
                      Row(
                        children: [
                          // Avatar
                          Obx(() {
                            final avatar = controller.avatarUrl.value;
                            return CircleAvatar(
                              radius: avatarSize / 2.5,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage:
                              (avatar != null && avatar.isNotEmpty)
                                  ? NetworkImage(avatar)
                                  : null,
                              child: (avatar == null || avatar.isEmpty)
                                  ? Icon(Icons.person,
                                  size: 48, color: Colors.grey.shade700)
                                  : null,
                            );
                          }),

                          const SizedBox(width: 20),

                          // Counts
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _countColumn("Posts", controller.postsCount),
                                _countColumn("Followers", controller.followersCount),
                                _countColumn("Following", controller.followingCount),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      /// Name
                      Obx(() => Text(
                        controller.displayName.value,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )),

                      /// Bio (2 lines only)
                      Obx(() => Text(
                        controller.bio.value,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey.shade700),
                      )),

                      const SizedBox(height: 14),

                      /// Edit Profile button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: controller.editProfile,
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32)),
                          ),
                          child: const Text("Edit Profile",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),

                      const SizedBox(height: 14),
                    ],
                  ),
                ),
              ),

              /// -------- PINNED TAB BAR --------
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  TabBar(
                    labelColor: Theme.of(context).colorScheme.primary,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(text: "All"),
                      Tab(text: "Photos"),
                      Tab(text: "Videos"),
                    ],
                  ),
                ),
              ),
            ];
          },

          /// -------- TAB CONTENT --------
          body: TabBarView(
            children: [
              /// ALL (mixed)
              Obx(() => _buildStaggeredMixed(controller)),

              /// PHOTOS ONLY
              Obx(() => _buildStaggered(controller.photos, MediaType.photo)),

              /// VIDEOS ONLY
              Obx(() => _buildStaggered(controller.videos, MediaType.video)),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= HELPER WIDGETS =================

  Widget _countColumn(String label, RxInt count) {
    return Column(
      children: [
        Obx(() => Text(
          count.value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        )),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildStaggeredMixed(ProfileController c) {
    final items = <_MediaItem>[];

    final maxLen = c.photos.length > c.videos.length
        ? c.photos.length
        : c.videos.length;

    for (int i = 0; i < maxLen; i++) {
      if (i < c.photos.length) {
        items.add(_MediaItem(c.photos[i], MediaType.photo));
      }
      if (i < c.videos.length) {
        items.add(_MediaItem(c.videos[i], MediaType.video));
      }
    }

    if (items.isEmpty) {
      return const Center(child: Text("No posts yet"));
    }

    return _buildMasonry(items);
  }

  Widget _buildStaggered(RxList<String> list, MediaType type) {
    if (list.isEmpty) {
      return const Center(child: Text("No content yet"));
    }

    final items = list.map((e) => _MediaItem(e, type)).toList();
    return _buildMasonry(items);
  }

  Widget _buildMasonry(List<_MediaItem> items) {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return ClipRRect(
          child: Stack(
            children: [
              // Thumbnail
              item.url.isEmpty
                  ? Container(
                height: 120 + (index % 4) * 20,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: Icon(
                  item.type == MediaType.photo
                      ? Icons.image
                      : Icons.play_circle_outline,
                  size: 40,
                  color: Colors.grey,
                ),
              )
                  : Image.network(item.url, fit: BoxFit.cover),

              // Video overlay
              if (item.type == MediaType.video)
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.play_arrow,
                            size: 16, color: Colors.white),
                        SizedBox(width: 4),
                        Text("20s",
                            style:
                            TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// ---------- INTERNAL MODELS ----------

enum MediaType { photo, video }

class _MediaItem {
  final String url;
  final MediaType type;
  _MediaItem(this.url, this.type);
}

/// ---------- PIN TAB BAR ----------

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  Widget build(context, shrinkOffset, overlapsContent) =>
      Container(color: Theme.of(context).scaffoldBackgroundColor, child: tabBar);

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(old) => false;
}


/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // If you didn't bind controller via binding, you can put:
    // Get.put(ProfileController());
    const double avatarSize = 96;

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.username.value)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: controller.openSettings,
            tooltip: 'Settings',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Profile header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Column(
                children: [
                  Center(
                    child: Obx(() {
                      final avatar = controller.avatarUrl.value;
                      if (avatar == null || avatar.isEmpty) {
                        return CircleAvatar(
                          radius: avatarSize / 2,
                          backgroundColor: Colors.grey.shade200,
                          child: Icon(
                            Icons.person,
                            size: 46,
                            color: Colors.grey.shade700,
                          ),
                        );
                      } else {
                        return CircleAvatar(
                          radius: avatarSize / 2,
                          backgroundImage: NetworkImage(avatar),
                          backgroundColor: Colors.grey.shade200,
                        );
                      }
                    }),
                  ),

                  Text(controller.displayName.value, style: context.textTheme.headlineMedium,),
                  Text(controller.bio.value, style: context.textTheme.labelMedium,),

                  const SizedBox(height: 12),

                  // counts row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCountItem('Posts', controller.postsCount),
                      _verticalDivider(),
                      _buildCountItem('Followers', controller.followersCount),
                      _verticalDivider(),
                      _buildCountItem('Following', controller.followingCount),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Edit profile button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: controller.editProfile,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: const Text(
                        'Edit profile',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tabs (Photos / Videos)
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: TabBar(
                        labelColor: Theme.of(context).colorScheme.primary,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Theme.of(context).colorScheme.primary,
                        tabs: const [
                          Tab(text: 'Photos', icon: Icon(Icons.grid_on)),
                          Tab(
                            text: 'Videos',
                            icon: Icon(Icons.video_collection),
                          ),
                        ],
                      ),
                    ),

                    // Tab views
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Photos grid
                          Obx(() {
                            final photos = controller.photos;
                            if (photos.isEmpty) {
                              return Center(
                                child: Text(
                                  'No photos yet',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              );
                            }
                            return GridView.builder(
                              padding: const EdgeInsets.all(8),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 6,
                                    mainAxisSpacing: 6,
                                    childAspectRatio: 1,
                                  ),
                              itemCount: photos.length,
                              itemBuilder: (context, index) {
                                final url = photos[index];
                                if (url.isEmpty) {
                                  // placeholder box
                                  return Container(
                                    color: Colors.grey.shade200,
                                    child: const Center(
                                      child: Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                }
                                return Image.network(url, fit: BoxFit.cover);
                              },
                            );
                          }),

                          // Videos list / grid
                          Obx(() {
                            final videos = controller.videos;
                            if (videos.isEmpty) {
                              return Center(
                                child: Text(
                                  'No videos yet',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              );
                            }
                            return ListView.separated(
                              padding: const EdgeInsets.all(12),
                              itemBuilder: (context, index) {
                                final thumb = videos[index];
                                return Row(
                                  children: [
                                    Container(
                                      width: 140,
                                      height: 80,
                                      color: thumb.isEmpty
                                          ? Colors.grey.shade200
                                          : null,
                                      child: thumb.isEmpty
                                          ? const Icon(
                                              Icons.play_circle_outline,
                                              size: 48,
                                              color: Colors.grey,
                                            )
                                          : Image.network(
                                              thumb,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Video Title #${index + 1}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Short description for video',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemCount: videos.length,
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // helper widgets
  Widget _buildCountItem(String label, RxInt count) {
    return Expanded(
      child: Column(
        children: [
          Obx(
            () => Text(
              count.value.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return const SizedBox(
      height: 36,
      child: VerticalDivider(width: 1, thickness: 1, color: Colors.transparent),
    );
  }
}
*/
