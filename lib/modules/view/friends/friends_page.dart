import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tophotels/modules/resources/app_colors.dart';
import 'package:tophotels/modules/view/chip/chip.dart';
import 'package:tophotels/modules/viewmodel/friends_logic.dart';


class FriendsPage extends StatelessWidget {
  FriendsPage({super.key});
  final controller = Get.put(FriendsLogic());

  // Track selected section for dynamic color change
  var selectedSection = Rx<String>(''); // This will store the selected section

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FriendsLogic>(builder: (controller) {
      return Scaffold(
        backgroundColor: AppColors.primaryBlue.withOpacity(0.08),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: controller.pending.value == false
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Get.height * .02,
                          ),
                          const Row(
                            children: [
                              Text(
                                'Friends',
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              )
                            ],
                          ),
                          SizedBox(height: Get.height * .02),
                          Row(
                            children: [
                              Expanded(
                                child: CupertinoSearchTextField(
                                  suffixMode: OverlayVisibilityMode.always,
                                  suffixIcon: const Icon(
                                    CupertinoIcons.mic_fill,
                                    color: AppColors.grey,
                                  ),
                                  onChanged: (value) {
                                    controller.searchQuery.value = value;
                                  },
                                ),
                              ),
                              Obx(() {
                                return controller.searchQuery.value.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          // Clear the search query
                                          controller.searchQuery.value = '';
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: AppColors.primaryBlue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container();
                              }),
                            ],
                          ),
                          Obx(() {
                            if (controller.searchQuery.value.isNotEmpty) {
                              int totalCount =
                                  controller.filteredFriends.length +
                                      controller.filteredContacts.length +
                                      controller.filteredAllContacts.length;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Results for "${controller.searchQuery.value}"',
                                      style: const TextStyle(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(width: Get.width * .02),
                                    Text(
                                      '$totalCount',
                                      style: const TextStyle(
                                        color: AppColors.primaryBlue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Container();
                          }),

                          SizedBox(height: Get.height * .02),
                          GestureDetector(
                            onTap: () {
                              controller.pending.value = true;
                              controller.update();
                            },
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: AppColors.primaryBlue
                                            .withOpacity(0.3),
                                      )),
                                  child: ListTile(
                                    leading: SvgPicture.asset(
                                        'assets/svg/add_firend.svg'),
                                    title: const Text(
                                      'Pending friend requests',
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: const Text(
                                      'view pending requests',
                                      style: TextStyle(
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Get.height * .01,
                                ),
                              ],
                            ),
                          ),
                          // Using the dynamic section color change
                          Obx(() {
                            List<Contact> filteredContacts = controller
                                    .searchQuery.value.isNotEmpty
                                ? controller.filteredAllContacts
                                    .where((contact) {
                                    return contact.displayName
                                        .toString()
                                        .toLowerCase()
                                        .contains(controller.searchQuery.value
                                            .toLowerCase());
                                  }).toList()
                                : controller.filteredAllContacts;
                            return Column(
                              children: [
                                if (controller.filteredFriends.isNotEmpty) ...[
                                  GestureDetector(
                                    onTap: () {
                                      selectedSection.value =
                                          'Friends'; // Update selected section on tap
                                    },
                                    child: _buildSectionTitle(
                                      'Friends',
                                      controller.filteredFriends.length
                                          .toString(),
                                      selectedSection.value ==
                                          'Friends', // Check if this is the selected section
                                    ),
                                  ),
                                  SizedBox(height: Get.height * .02),
                                  _buildFriendsList(controller.filteredFriends,
                                      AppColors.black),
                                  SizedBox(height: Get.height * .02),
                                ],
                                if (controller.filteredContacts.isNotEmpty) ...[
                                  GestureDetector(
                                    onTap: () {
                                      selectedSection.value =
                                          'Contacts using Chiip'; // Update selected section on tap
                                    },
                                    child: _buildSectionTitle(
                                      'Contacts using Chiip',
                                      controller.filteredContacts.length
                                          .toString(),
                                      selectedSection.value ==
                                          'Contacts using Chiip', // Check if this is the selected section
                                    ),
                                  ),
                                  SizedBox(height: Get.height * .02),
                                  _buildFriendsList(controller.filteredContacts,
                                      AppColors.primaryBlue),
                                  SizedBox(height: Get.height * .02),
                                ],
                                if (controller
                                    .filteredAllContacts.isNotEmpty) ...[
                                  GestureDetector(
                                    onTap: () {
                                      selectedSection.value =
                                          'Contacts'; // Update selected section on tap
                                    },
                                    child: _buildSectionTitle(
                                      'Contacts',
                                      filteredContacts.length
                                          .toString(),
                                      selectedSection.value ==
                                          'Contacts', // Check if this is the selected section
                                    ),
                                  ),
                                  SizedBox(height: Get.height * .02),
                                  _buildContactList(
                            filteredContacts, AppColors.primaryBlue),
                                  SizedBox(height: Get.height * .02),
                                ],
                                if (controller.filteredFriends.isEmpty &&
                                    controller.filteredContacts.isEmpty &&
                                    controller.filteredAllContacts.isEmpty)
                                  const Text(
                                    'No matches found',
                                    style: TextStyle(color: AppColors.grey),
                                  ),
                              ],
                            );
                          }),
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: Get.height * .03,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    controller.pending.value = false;
                                    controller.update();
                                  },
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: AppColors.primaryBlue,
                                  )),
                              SizedBox(
                                width: Get.width * .02,
                              ),
                              const Text(
                                'Pending requests',
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              )
                            ],
                          ),
                          SizedBox(
                            height: Get.height * .03,
                          ),
                          const Row(
                            children: [
                              Text(
                                'Pending',
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '5',
                                style: TextStyle(
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * .01,
                          ),
                          pending(),
                        ],
                      )),
          ),
        ),
      );
    });
  }

  Widget _buildSectionTitle(String title, String count, bool isSelected) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: isSelected
                ? AppColors.primaryBlue
                : AppColors.black, // Change color based on selection
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(width: Get.width * .02),
        Text(
          count,
          style: const TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildContactList(List<Contact> contacts, Color trailingColor) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        final photo = contact.photo;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.white,
            ),
            child: ListTile(
              leading: photo != null
                  ? Image.memory(photo) // Display the photo if available
                  : Icon(Icons.account_circle,
                      size: 40, color: AppColors.grey.withOpacity(0.3)),
              title: Text(
                contact.displayName.toString(),
                style: const TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              trailing: Text(
                'Invite',
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget pending() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: controller.pendingrequest.length,
      itemBuilder: (BuildContext context, int index) {
        final data = controller.pendingrequest[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.white),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.asset(data['image'].toString()),
                  SizedBox(width: Get.width * .02),
                  Text(
                    data['title'].toString(),
                    style: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    data['tralling'].toString(),
                    style: const TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    width: Get.width * .02,
                  ),
                  Text(
                    data['decline'].toString(),
                    style: const TextStyle(
                      color: AppColors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFriendsList(
      List<Map<String, dynamic>> friendsList, Color tarllingColor) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: friendsList.length,
      itemBuilder: (BuildContext context, int index) {
        final data = friendsList[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.white),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.asset(data['image'].toString()),
                  SizedBox(width: Get.width * .02),
                  Text(
                    data['title'].toString(),
                    style: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      data['tralling'] == 'Send Chiip'
                          ? Get.to(() => ChipPage())
                          : null;
                    },
                    child: Text(
                      data['tralling'].toString(),
                      style: TextStyle(
                        color: tarllingColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
