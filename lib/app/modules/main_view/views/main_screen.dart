import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kyzo/app/modules/main_view/controllers/main_screen_controller.dart';

import '../../add_post_view/views/add_post_screen.dart';
import '../../home_view/views/home_screen.dart';
import '../../profile_view/views/profile_screen.dart';
import '../../reels_view/views/reels_screen.dart';
import '../../search_view/views/search_screen.dart';

// ... imports

class MainScreen extends GetView<MainController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Content - takes full height
          Positioned.fill(
            child: Obx(
                  () => IndexedStack(
                index: controller.currentIndex.value,
                children: const [
                  HomeScreen(),
                  SearchScreen(),
                  AddPostScreen(),
                  ReelsScreen(),
                  ProfileScreen(),
                ],
              ),
            ),
          ),

          // Bottom Navigation Bar - positioned above content
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _buildCustomBottomNav(context),
          ),
        ],
      ),
    );
  }

  // Rest of the methods remain the same...
  Widget _buildCustomBottomNav(BuildContext context) {
    return Obx(
          () => Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(90),
          color: context.isDarkMode ? Colors.black : Colors.white,
          boxShadow: [
            BoxShadow(
              color: context.isDarkMode
                  ? Colors.white.withOpacity(0.2)
                  : Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, Icons.home, 0, context),
            _buildNavItem(Icons.search_outlined, Icons.search, 1, context),
            _buildAddButton(context),
            _buildNavItem(
              Icons.video_library_outlined,
              Icons.video_library,
              3,
              context,
            ),
            _buildNavItem(Icons.person_outlined, Icons.person, 4, context),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData outlineIcon,
      IconData filledIcon,
      int index,
      BuildContext context,
      ) {
    bool isSelected = controller.currentIndex.value == index;
    return GestureDetector(
      onTap: () => controller.changePage(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Icon(
          isSelected ? filledIcon : outlineIcon,
          size: 28,
          color: isSelected
              ? context.isDarkMode
              ? Colors.white
              : Colors.black
              : Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    bool isSelected = controller.currentIndex.value == 2;
    return GestureDetector(
      onTap: () => controller.changePage(2),
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.white : Colors.black,
          boxShadow: [
            BoxShadow(
              color: context.isDarkMode
                  ? Colors.white.withOpacity(0.3)
                  : Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.add,
          color: isSelected ? Colors.black : Colors.white,
          size: 30,
        ),
      ),
    );
  }
}







/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../add_post_view/views/add_post_screen.dart';
import '../../home_view/views/home_screen.dart';
import '../../profile_view/views/profile_screen.dart';
import '../../reels_view/views/reels_screen.dart';
import '../../search_view/views/search_screen.dart';
import '../controllers/main_screen_controller.dart';

class MainScreen extends GetView<MainController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => IndexedStack(
            index: controller.currentIndex.value,
            children: const [
              HomeScreen(),
              SearchScreen(),
              AddPostScreen(),
              ReelsScreen(),
              ProfileScreen(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildCustomBottomNav(context),
    );
  }

  Widget _buildCustomBottomNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
      child: Obx(
        () => Container(
          // height: 65,
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90),
            color: context.isDarkMode ? Colors.black : Colors.white,
            boxShadow: [
              BoxShadow(
                color: context.isDarkMode
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, Icons.home, 0, context),
              _buildNavItem(Icons.search_outlined, Icons.search, 1, context),
              _buildAddButton(context),
              _buildNavItem(
                Icons.video_library_outlined,
                Icons.video_library,
                3,
                context,
              ),
              _buildNavItem(Icons.person_outlined, Icons.person, 4, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData outlineIcon,
    IconData filledIcon,
    int index,
    BuildContext context,
  ) {
    bool isSelected = controller.currentIndex.value == index;
    return GestureDetector(
      onTap: () => controller.changePage(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Icon(
          isSelected ? filledIcon : outlineIcon,
          size: 28,
          color: isSelected
              ? context.isDarkMode
                    ? Colors.white
                    : Colors.black
              : Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    bool isSelected = controller.currentIndex.value == 2;
    return GestureDetector(
      onTap: () => controller.changePage(2),
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.white : Colors.black,
          boxShadow: [
            BoxShadow(
              color: context.isDarkMode
                  ? Colors.white.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.add,
          color: isSelected ? Colors.black : Colors.white,
          size: 30,
        ),
      ),
    );
  }
}

// Page Widgets
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home Page', style: TextStyle(fontSize: 24)),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Search Page', style: TextStyle(fontSize: 24)),
    );
  }
}

class AddPostPage extends StatelessWidget {
  const AddPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Add Post Page', style: TextStyle(fontSize: 24)),
    );
  }
}

class ReelsPage extends StatelessWidget {
  const ReelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Reels Page', style: TextStyle(fontSize: 24)),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Profile Page', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Get.find<MainController>().logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
*/
