import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;
final Uuid uuid = Uuid();

// Collection refs
CollectionReference usersRef = firestore.collection('users');
CollectionReference postRef = firestore.collection('posts');
CollectionReference likeRef = firestore.collection('likes');
CollectionReference commentRef = firestore.collection('comments');
CollectionReference commentLikeRef = firestore.collection('commentLikes');
CollectionReference shareRef = firestore.collection('shares');
CollectionReference followingRef = firestore.collection('followings');
CollectionReference followerRef = firestore.collection('followers');

// Storage refs
Reference profilePic = storage.ref().child('profilePic');
Reference posts = storage.ref().child('posts');
Reference prevImage = storage.ref().child('previewImage');
