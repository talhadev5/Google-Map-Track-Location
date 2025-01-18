import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';


class FriendsLogic extends GetxController {
  final List<Map<String, String>> friendsData = [
    {
      'title': 'Billy McFarland',
      'image': 'assets/svg/Ellipse 8.png',
      'tralling': 'Send Chiip',
    },
    {
      'title': 'Mike Falb',
      'image': 'assets/svg/Ellipse 8-1.png',
      'tralling': 'Send Chiip',
    },
    {
      'title': 'Jacob Vermeulen',
      'image': 'assets/svg/Ellipse 8-2.png',
      'tralling': 'Send Chiip',
    },
    {
      'title': 'Henry De Jong',
      'image': 'assets/svg/Ellipse 8-3.png',
      'tralling': 'Send Chiip',
    },
  ];
// contact data list
  final List<Map<String, String>> contatData = [
    {
      'title': 'Billy McFarland',
      'image': 'assets/svg/Ellipse 8.png',
      'tralling': 'Add friend',
    },
    {
      'title': 'Mike Falb',
      'image': 'assets/svg/Ellipse 8-1.png',
      'tralling': 'Add friend',
    },
    {
      'title': 'Jacob Vermeulen',
      'image': 'assets/svg/Ellipse 8-2.png',
      'tralling': 'Add friend',
    },
    {
      'title': 'Henry De Jong',
      'image': 'assets/svg/Ellipse 8-3.png',
      'tralling': 'Add friend',
    },
  ];
  // contecs...........
  List<Contact>? contact;
  bool _permissionDenied = false;
  var isLoading = true.obs;
  // var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchContacts();
  }

  Future fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      _permissionDenied = true;
      update();
    } else {
      final contacts = await FlutterContacts.getContacts();
      contact = contacts;
      update();
    }
  }
  // final List<Map<String, String>> contacts = [
  //   {
  //     'title': 'Sarah Wandy',
  //     'image': 'assets/svg/Ellipse 8.png',
  //     'tralling': 'Invite',
  //   },
  //   {
  //     'title': 'Peter Vermenulem',
  //     'image': 'assets/svg/Ellipse 8-1.png',
  //     'tralling': 'Invite',
  //   },
  //   {
  //     'title': 'Jacob Vermeulen',
  //     'image': 'assets/svg/Ellipse 8-2.png',
  //     'tralling': 'Invite',
  //   },
  //   {
  //     'title': 'Henry De Jong',
  //     'image': 'assets/svg/Ellipse 8-3.png',
  //     'tralling': 'Invite',
  //   },
  // ];

  final List<Map<String, String>> pendingrequest = [
    {
      'title': 'Sarah Wandy',
      'image': 'assets/svg/Ellipse 8.png',
      'tralling': 'Accept',
      'decline': 'Decline',
    },
    {
      'title': 'Peter Vermenulem',
      'image': 'assets/svg/Ellipse 8-1.png',
      'tralling': 'Accept',
      'decline': 'Decline',
    },
    {
      'title': 'Jacob Vermeulen',
      'image': 'assets/svg/Ellipse 8-2.png',
      'tralling': 'Accept',
      'decline': 'Decline',
    },
    {
      'title': 'Henry De Jong',
      'image': 'assets/svg/Ellipse 8-3.png',
      'tralling': 'Accept',
      'decline': 'Decline',
    },
  ];

  // RxString to store search query
  var searchQuery = ''.obs;
  RxBool pending = false.obs;
// Function to filter data based on search query
  List<Map<String, String>> get filteredFriends {
    if (searchQuery.value.isEmpty) {
      return friendsData;
    } else {
      return friendsData.where((friend) {
        return friend['title']!
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase());
      }).toList();
    }
  }

  List<Map<String, String>> get filteredContacts {
    if (searchQuery.value.isEmpty) {
      return contatData;
    } else {
      return contatData.where((contact) {
        return contact['title']!
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase());
      }).toList();
    }
  }

 

   // Filter all contacts from the device
  List<Contact> get filteredAllContacts {
    if (searchQuery.value.isEmpty || contact == null) {
      return contact ?? [];
    } else {
      return contact!.where((contact) {
        return contact.displayName?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false;
      }).toList();
    }
  }

  // Function to check if permission is denied
  bool get permissionDenied => _permissionDenied;

  // Function to show loading indicator
  bool get isContactsLoading => isLoading.value;
}
