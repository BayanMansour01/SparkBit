import 'package:flutter/material.dart';

enum ContactType {
  facebook,
  instagram,
  phoneNumber,
  whatsapp,
  telegram,
  email,
  unknown,
}

class ContactMethodModel {
  final int id;
  final String name;
  final String? description;
  final String typeString;
  final String identifier;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ContactMethodModel({
    required this.id,
    required this.name,
    this.description,
    required this.typeString,
    required this.identifier,
    this.createdAt,
    this.updatedAt,
  });

  factory ContactMethodModel.fromJson(Map<String, dynamic> json) {
    return ContactMethodModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      typeString: json['type'] as String,
      identifier: json['identifier'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  ContactType get type {
    switch (typeString) {
      case 'facebook':
        return ContactType.facebook;
      case 'instagram':
        return ContactType.instagram;
      case 'phone_number':
        return ContactType.phoneNumber;
      case 'whatsapp':
        return ContactType.whatsapp;
      case 'telegram':
        return ContactType.telegram;
      case 'email':
        return ContactType.email;
      default:
        return ContactType.unknown;
    }
  }

  IconData get icon {
    switch (type) {
      case ContactType.facebook:
        return Icons.facebook;
      case ContactType.instagram:
        return Icons.camera_alt; // Or use FontAwesome if available
      case ContactType.phoneNumber:
        return Icons.phone;
      case ContactType.whatsapp:
        return Icons.chat; // Or FontAwesome
      case ContactType.telegram:
        return Icons.send; // Or FontAwesome
      case ContactType.email:
        return Icons.email;
      default:
        return Icons.link;
    }
  }

  Color get color {
    switch (type) {
      case ContactType.facebook:
        return const Color(0xFF1877F2);
      case ContactType.instagram:
        return const Color(0xFFE4405F);
      case ContactType.phoneNumber:
        return Colors.green;
      case ContactType.whatsapp:
        return const Color(0xFF25D366);
      case ContactType.telegram:
        return const Color(0xFF0088CC);
      case ContactType.email:
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}
