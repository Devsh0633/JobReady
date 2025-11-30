import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/community_post_model.dart';
import 'community_theme.dart';

import '../logic/community_store.dart';

class NewThreadScreen extends StatefulWidget {
  final String? initialTitle;
  final String? initialBody;
  final CommunityPostType? initialType;
  final List<String>? initialTags;

  const NewThreadScreen({
    super.key,
    this.initialTitle,
    this.initialBody,
    this.initialType,
    this.initialTags,
  });

  @override
  State<NewThreadScreen> createState() => _NewThreadScreenState();
}

class _NewThreadScreenState extends State<NewThreadScreen> {
  final CommunityStore _store = CommunityStore.instance;
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  CommunityPostType _selectedType = CommunityPostType.question;
  final List<String> _selectedTags = [];

  final List<String> _suggestedTags = [
    "Interview Story",
    "DSA",
    "HR Round",
    "Resume",
    "System Design",
    "Salary Negotiation",
    "Mock Interview",
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _bodyController = TextEditingController(text: widget.initialBody);
    if (widget.initialType != null) {
      _selectedType = widget.initialType!;
    }
    if (widget.initialTags != null) {
      _selectedTags.addAll(widget.initialTags!);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              CommunityTheme.backgroundTop,
              CommunityTheme.backgroundBottom,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      color: Colors.black87,
                    ),
                    Text(
                      "New Post",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 2,
                    shadowColor: Colors.black.withValues(alpha: 0.05),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title Input
                          TextField(
                            controller: _titleController,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              hintText: "Title (e.g. Amazon Interview Experience)",
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.normal,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 16),

                          // Type Selector
                          Text(
                            "Post Type",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: CommunityPostType.values.map((type) {
                              final isSelected = _selectedType == type;
                              return ChoiceChip(
                                label: Text(type.name.toUpperCase()),
                                labelStyle: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : Colors.black87,
                                ),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() => _selectedType = type);
                                  }
                                },
                                selectedColor: CommunityTheme.accentPurple,
                                backgroundColor: Colors.grey.shade100,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: isSelected ? Colors.transparent : Colors.grey.shade300,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),

                          // Body Input
                          TextField(
                            controller: _bodyController,
                            maxLines: 8,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              height: 1.5,
                            ),
                            decoration: InputDecoration(
                              hintText: "Share your thoughts, questions, or experience...",
                              hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
                              border: InputBorder.none,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Tags
                          Text(
                            "Add Tags",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _suggestedTags.map((tag) {
                              final isSelected = _selectedTags.contains(tag);
                              return FilterChip(
                                label: Text(tag),
                                labelStyle: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: isSelected ? CommunityTheme.accentPurple : Colors.black87,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                ),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedTags.add(tag);
                                    } else {
                                      _selectedTags.remove(tag);
                                    }
                                  });
                                },
                                backgroundColor: Colors.white,
                                selectedColor: CommunityTheme.accentPurple.withValues(alpha: 0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: isSelected ? CommunityTheme.accentPurple : Colors.grey.shade300,
                                  ),
                                ),
                                showCheckmark: false,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_titleController.text.trim().isEmpty || _bodyController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please enter title and body")),
                        );
                        return;
                      }

                      _store.createPost(
                        title: _titleController.text,
                        body: _bodyController.text,
                        type: _selectedType,
                        tags: _selectedTags,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Post created in Community")),
                      );
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CommunityTheme.accentPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Post to Community",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
