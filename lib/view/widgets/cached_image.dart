import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget cachedNetworkImage(String imgUrl) {
  return CachedNetworkImage(
    imageUrl: imgUrl,
    fit: BoxFit.cover,
    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
    errorWidget: (context, url, error) => Center(
      child: Text(
        'Unable to load',
        style: TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
