import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_permisos/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum PhotoMode { gallery, contacts }

class PhotosShowcase extends StatefulWidget {
  final PhotoMode mode;
  const PhotosShowcase({super.key, required this.mode});

  @override
  State<PhotosShowcase> createState() => _PhotosShowcaseState();
}

class _PhotosShowcaseState extends State<PhotosShowcase> {
  // Photos State
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Contacts State
  List<Contact> _contacts = [];
  bool _isLoadingContacts = false;

  @override
  void initState() {
    super.initState();
    if (widget.mode == PhotoMode.contacts) {
      _loadContacts();
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error picking image: $e")));
    }
  }

  Future<void> _loadContacts() async {
    setState(() => _isLoadingContacts = true);
    try {
      final contacts = await ContactsService.getContacts(withThumbnails: false);
      setState(() {
        _contacts = contacts.toList();
        _isLoadingContacts = false;
      });
    } catch (e) {
      setState(() => _isLoadingContacts = false);
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error loading contacts: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.mode == PhotoMode.gallery
        ? 'Photos Showcase'
        : 'Contacts Showcase';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: widget.mode == PhotoMode.gallery
          ? _buildPhotosBody()
          : _buildContactsBody(),
    );
  }

  Widget _buildPhotosBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300,
            height: 400,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
              image: _selectedImage != null
                  ? DecorationImage(
                      image: FileImage(_selectedImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _selectedImage == null
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FontAwesomeIcons.image,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "No Image Selected",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : null,
          ).animate().fadeIn().scale(),

          const SizedBox(height: 40),

          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.photo_library),
            label: const Text("SELECT FROM GALLERY"),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsBody() {
    if (_isLoadingContacts) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_contacts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              FontAwesomeIcons.addressBook,
              size: 60,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text("No Contacts Found or Permission Denied"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadContacts,
              child: const Text("RETRY"),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _contacts.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final contact = _contacts[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primary,
              child: Text(
                (contact.displayName ?? contact.givenName ?? "?")
                    .characters
                    .first
                    .toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              contact.displayName ?? "Unknown",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              contact.phones?.isNotEmpty == true
                  ? contact.phones!.first.value ?? "No number"
                  : "No number",
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: index * 50)).slideX();
      },
    );
  }
}
