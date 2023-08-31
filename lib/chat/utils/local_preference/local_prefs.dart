import 'dart:convert';

import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocalPreference {
  SharedPreferences? _sharedPreferences;

  static UserLocalPreference? _instance;
  static UserLocalPreference get instance =>
      _instance ??= UserLocalPreference._();

  UserLocalPreference._();

  Future initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future storeUserData(User user) async {
    UserEntity userEntity = user.toEntity();
    Map<String, dynamic> userData = userEntity.toJson();
    String userString = jsonEncode(userData);
    await _sharedPreferences!.setString("user", userString);
  }

  Future storeCommunityData(Community community) async {
    Map<String, dynamic> communityData = {
      "community_id": community.id,
      "community_name": community.name
    };
    String communityString = jsonEncode(communityData);
    await _sharedPreferences!.setString('community', communityString);
  }

  Map<String, dynamic> fetchCommunityData() {
    Map<String, dynamic> communityData =
        jsonDecode(_sharedPreferences!.getString('community')!);
    return communityData;
  }

  User fetchUserData() {
    Map<String, dynamic> userData =
        jsonDecode(_sharedPreferences!.getString("user")!);
    return User.fromEntity(UserEntity.fromJson(userData));
  }

  Future storeMemberRights(MemberStateResponse? response) async {
    if (response == null) {
      return;
    }
    final entity = response.toEntity();
    Map<String, dynamic> memberRights = entity.toJson();
    String memberRightsString = jsonEncode(memberRights);
    await _sharedPreferences!.setString('memberRights', memberRightsString);
  }

  MemberStateResponse fetchMemberRights() {
    Map<String, dynamic> memberRights =
        jsonDecode(_sharedPreferences!.getString('memberRights')!);
    MemberStateResponseEntity memberStateResponseEntity =
        MemberStateResponseEntity.fromJson(memberRights);
    return MemberStateResponse.fromEntity(memberStateResponseEntity);
  }

  bool fetchMemberRight(int id) {
    MemberStateResponse memberStateResponse = fetchMemberRights();
    final memberRights = memberStateResponse.memberRights;
    if (memberRights == null) {
      return false;
    } else {
      final right = memberRights.where((element) => element.state == id);
      if (right.isEmpty) {
        return false;
      } else {
        return right.first.isSelected;
      }
    }
  }
}
