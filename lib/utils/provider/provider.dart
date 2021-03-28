import 'package:flutter_tiktok/view_model/auth/login_view_model.dart';
import 'package:flutter_tiktok/view_model/auth/register_view_model.dart';
import 'package:flutter_tiktok/view_model/post/create_post_view_model.dart';
import 'package:flutter_tiktok/view_model/profile/profileVM.dart';
import 'package:flutter_tiktok/view_model/search/search_view_model.dart';
import 'package:flutter_tiktok/view_model/user/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => RegisterViewModel()),
  ChangeNotifierProvider(create: (_) => LoginViewModel()),
  ChangeNotifierProvider(create: (_) => ProfileViewModel()),
  ChangeNotifierProvider(create: (_) => PostsViewModel()),
  ChangeNotifierProvider(create: (_) => SearchViewModel()),
  ChangeNotifierProvider(create: (_) => UserViewModel()),
];
