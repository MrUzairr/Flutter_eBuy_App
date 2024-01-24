import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
User? currentUser = auth.currentUser;

// collectins
const userCollection = 'users';
const productCollection = 'products';
const cartCollection = 'cart';
const chatCollection = 'chat';
const messageCollection = 'messages';
const orderCollection = 'orders';
