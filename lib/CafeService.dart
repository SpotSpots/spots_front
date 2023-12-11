import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Cafe {
  Cafe({
    this.name,
    this.amenNum,
    this.congestion,
    this.detail,
    this.image,
    this.rating,
    this.reference,
  });

  String? name;
  String? amenNum;
  String? category;
  String? congestion;
  String? detail;
  String? image;
  String? rating;
  DocumentReference? reference;

  Cafe.fromJson(dynamic json,this.reference){
    name = json['name'];
    amenNum = json['amenNum'];
    category = json['category'];
    congestion = json['congestion'];
    detail = json['detail'];
    image = json['image'];
    rating = json['rating'];
  }
  Cafe.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(),snapshot.reference);

  Cafe.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(),snapshot.reference);
}

class CafeService {
  final CollectionReference<Map<String, dynamic>> _collectionReference
  = FirebaseFirestore.instance.collection('cafe');

  Future<List<Cafe>> getCafesBySearchKeyword(String searchKeyword) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await _collectionReference.where('name', isGreaterThanOrEqualTo: searchKeyword)
        .where('name', isLessThanOrEqualTo: '$searchKeyword\uf8ff').get();
    List<Cafe> cafes = [];
    for (var doc in querySnapshot.docs) {
      Cafe cafe = Cafe.fromQuerySnapshot(doc);
      cafes.add(cafe);
    }
    return cafes;
  }

  Future<List<Cafe>> getCafesByCategory(String category) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await _collectionReference.where('category', isEqualTo: category).get();
    List<Cafe> cafes = [];

    for (var doc in querySnapshot.docs) {
      Cafe cafe = Cafe.fromQuerySnapshot(doc);
      cafes.add(cafe);
      print(cafe.name);
    }
    return cafes;
  }

  Future<List<Cafe>> getAllCafes() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await _collectionReference.get();
    List<Cafe> cafes = [];
    for (var doc in querySnapshot.docs) {
      Cafe cafe = Cafe.fromQuerySnapshot(doc);
      cafes.add(cafe);
    }
    return cafes;
  }
}