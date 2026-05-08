import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../controllers/transaction_controller.dart';
import '../models/category.dart';
import '../utils/constants.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TransactionController _controller = Get.find<TransactionController>();
  final _uuid = const Uuid();

  // ─── Available icon options for custom categories ─────────────────────────

  final List<Map<String, dynamic>> _availableIcons = [
    {'icon': Icons.directions_car, 'label': 'Car'},
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.movie, 'label': 'Entertainment'},
    {'icon': Icons.fitness_center, 'label': 'Fitness'},
    {'icon': Icons.school, 'label': 'Education'},
    {'icon': Icons.pets, 'label': 'Pets'},
    {'icon': Icons.sports_esports, 'label': 'Gaming'},
    {'icon': Icons.local_cafe, 'label': 'Coffee'},
    {'icon': Icons.child_care, 'label': 'Kids'},
    {'icon': Icons.brush, 'label': 'Hobby'},
    {'icon': Icons.savings, 'label': 'Savings'},
    {'icon': Icons.card_giftcard, 'label': 'Gifts'},
  ];

  // ─── Available color options for custom categories ────────────────────────

  final List<Color> _availableColors = [
    const Color(0xFFE53935),
    const Color(0xFF8E24AA),
    const Color(0xFF1E88E5),
    const Color(0xFF00ACC1),
    const Color(0xFF43A047),
    const Color(0xFFFFB300),
    const Color(0xFFF4511E),
    const Color(0xFF6D4C41),
    const Color(0xFF546E7A),
    const Color(0xFF00897B),
  ];

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() => _buildBody()),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New Category'),
        onPressed: _showAddCategorySheet,
      ),
    );
  }

  // ─── Body ─────────────────────────────────────────────────────────────────

  Widget _buildBody() {
    final categories = _controller.categories;

    if (categories.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.category_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'No categories yet',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // ── Split into predefined and custom ────────────────────────────────────
    final predefined = categories.where((c) => !c.isCustom).toList();
    final custom = categories.where((c) => c.isCustom).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (predefined.isNotEmpty) ...[
          _buildSectionHeader('Default Categories', predefined.length),
          const SizedBox(height: 8),
          ...predefined.map((cat) => _buildCategoryTile(cat)),
        ],
        if (custom.isNotEmpty) ...[
          const SizedBox(height: 20),
          _buildSectionHeader('Custom Categories', custom.length),
          const SizedBox(height: 8),
          ...custom.map((cat) => _buildCategoryTile(cat)),
        ],
      ],
    );
  }

  // ─── Section Header ───────────────────────────────────────────────────────

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: AppConstants.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Category Tile ────────────────────────────────────────────────────────

  Widget _buildCategoryTile(Category category) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: category.color.withOpacity(0.15),
          child: Icon(
            category.icon,
            color: category.color,
            size: 22,
          ),
        ),
        title: Text(
          category.name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Text(
          category.isCustom ? 'Custom' : 'Default',
          style: TextStyle(
            fontSize: 12,
            color: category.isCustom
                ? AppConstants.primaryColor
                : Colors.grey.shade500,
          ),
        ),
        trailing: category.isCustom
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined,
                        color: AppConstants.primaryColor),
                    tooltip: 'Edit',
                    onPressed: () => _showEditCategorySheet(category),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    tooltip: 'Delete',
                    onPressed: () => _confirmDelete(category),
                  ),
                ],
              )
            : const Icon(Icons.lock_outline, color: Colors.grey, size: 18),
      ),
    );
  }

  // ─── Add Category Bottom Sheet ────────────────────────────────────────────

  void _showAddCategorySheet() {
    _showCategorySheet(existingCategory: null);
  }

  void _showEditCategorySheet(Category category) {
    _showCategorySheet(existingCategory: category);
  }

  void _showCategorySheet({Category? existingCategory}) {
    // Local state inside the sheet
    final nameController =
        TextEditingController(text: existingCategory?.name ?? '');
    final formKey = GlobalKey<FormState>();

    IconData selectedIcon = existingCategory != null
        ? existingCategory.icon
        : _availableIcons.first['icon'] as IconData;

    Color selectedColor = existingCategory != null
        ? existingCategory.color
        : _availableColors.first;

    final bool isEditing = existingCategory != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Title ─────────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEditing ? 'Edit Category' : 'New Category',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 12),

                    // ── Preview ───────────────────────────────────────────
                    Center(
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: selectedColor.withOpacity(0.15),
                        child:
                            Icon(selectedIcon, color: selectedColor, size: 32),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Name Field ────────────────────────────────────────
                    TextFormField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Category Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Category name is required';
                        }
                        if (v.trim().length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // ── Icon Picker ───────────────────────────────────────
                    const Text(
                      'Select Icon',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 60,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _availableIcons.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final item = _availableIcons[index];
                          final icon = item['icon'] as IconData;
                          final isSelected =
                              selectedIcon.codePoint == icon.codePoint;

                          return GestureDetector(
                            onTap: () =>
                                setSheetState(() => selectedIcon = icon),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 52,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? selectedColor.withOpacity(0.2)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? selectedColor
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(icon,
                                      color: isSelected
                                          ? selectedColor
                                          : Colors.grey,
                                      size: 22),
                                  const SizedBox(height: 2),
                                  Text(
                                    item['label'] as String,
                                    style: const TextStyle(fontSize: 8),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Color Picker ──────────────────────────────────────
                    const Text(
                      'Select Color',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 44,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _availableColors.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final color = _availableColors[index];
                          final isSelected = selectedColor == color;

                          return GestureDetector(
                            onTap: () =>
                                setSheetState(() => selectedColor = color),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.black87
                                      : Colors.transparent,
                                  width: 3,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: color.withOpacity(0.5),
                                          blurRadius: 8,
                                        )
                                      ]
                                    : [],
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check,
                                      color: Colors.white, size: 18)
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Save Button ───────────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _saveCategory(
                          formKey: formKey,
                          nameController: nameController,
                          selectedIcon: selectedIcon,
                          selectedColor: selectedColor,
                          existingCategory: existingCategory,
                        ),
                        child: Text(
                          isEditing ? 'Update Category' : 'Save Category',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ─── Save Category Logic ──────────────────────────────────────────────────

  Future<void> _saveCategory({
    required GlobalKey<FormState> formKey,
    required TextEditingController nameController,
    required IconData selectedIcon,
    required Color selectedColor,
    required Category? existingCategory,
  }) async {
    if (!formKey.currentState!.validate()) return;

    final name = nameController.text.trim();

    // Check for duplicate name (excluding itself if editing)
    final isDuplicate = _controller.categories.any((c) =>
        c.name.toLowerCase() == name.toLowerCase() &&
        c.id != existingCategory?.id);

    if (isDuplicate) {
      Get.snackbar(
        'Duplicate Name',
        'A category with this name already exists.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (existingCategory != null) {
      // ── Update existing ────────────────────────────────────────────────
      existingCategory.name = name;
      existingCategory.colorValue = selectedColor.value;
      existingCategory.iconCodePoint = selectedIcon.codePoint;
      await _controller.updateCategory(existingCategory);

      Get.back();
      Get.snackbar(
        'Updated',
        'Category updated successfully.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      // ── Add new ────────────────────────────────────────────────────────
      final newCategory = Category(
        id: _uuid.v4(),
        name: name,
        colorValue: selectedColor.value,
        iconCodePoint: selectedIcon.codePoint,
        isCustom: true,
      );

      await _controller.addCustomCategory(newCategory);

      Get.back();
      Get.snackbar(
        'Added',
        'Category "$name" created successfully.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  // ─── Delete Confirmation ──────────────────────────────────────────────────

  void _confirmDelete(Category category) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Category'),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black87, fontSize: 14),
            children: [
              const TextSpan(text: 'Are you sure you want to delete '),
              TextSpan(
                text: category.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: '?\n\nTransactions using this category will remain but '
                    'may show as "Unknown".',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              await _controller.deleteCategory(category.id);
              Get.back();
              Get.snackbar(
                'Deleted',
                '"${category.name}" has been removed.',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
