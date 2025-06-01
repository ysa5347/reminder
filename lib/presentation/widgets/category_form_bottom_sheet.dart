import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';

class CategoryFormBottomSheet extends StatefulWidget {
  final Category? category; // null이면 새 카테고리 추가, 값이 있으면 수정
  final Function(Category) onSave;

  const CategoryFormBottomSheet({
    Key? key,
    this.category,
    required this.onSave,
  }) : super(key: key);

  @override
  State<CategoryFormBottomSheet> createState() => _CategoryFormBottomSheetState();
}

class _CategoryFormBottomSheetState extends State<CategoryFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String _selectedColor = '#2196F3';
  String _selectedIcon = 'category';

  final List<String> _colors = [
    '#2196F3', // Blue
    '#4CAF50', // Green
    '#FF5722', // Deep Orange
    '#9C27B0', // Purple
    '#FF9800', // Orange
    '#607D8B', // Blue Grey
    '#795548', // Brown
    '#E91E63', // Pink
    '#009688', // Teal
    '#FFC107', // Amber
  ];

  final List<Map<String, dynamic>> _icons = [
    {'name': 'category', 'icon': Icons.category},
    {'name': 'work', 'icon': Icons.work},
    {'name': 'person', 'icon': Icons.person},
    {'name': 'shopping_cart', 'icon': Icons.shopping_cart},
    {'name': 'fitness_center', 'icon': Icons.fitness_center},
    {'name': 'home', 'icon': Icons.home},
    {'name': 'school', 'icon': Icons.school},
    {'name': 'restaurant', 'icon': Icons.restaurant},
    {'name': 'local_hospital', 'icon': Icons.local_hospital},
    {'name': 'directions_car', 'icon': Icons.directions_car},
    {'name': 'flight', 'icon': Icons.flight},
    {'name': 'music_note', 'icon': Icons.music_note},
    {'name': 'sports_soccer', 'icon': Icons.sports_soccer},
    {'name': 'pets', 'icon': Icons.pets},
    {'name': 'book', 'icon': Icons.book},
    {'name': 'camera_alt', 'icon': Icons.camera_alt},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _descriptionController = TextEditingController(text: widget.category?.description ?? '');
    
    if (widget.category != null) {
      _selectedColor = widget.category!.color ?? '#2196F3';
      _selectedIcon = widget.category!.icon ?? 'category';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.category != null;
    
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? '카테고리 수정' : '카테고리 추가',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // 카테고리 이름
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '카테고리 이름',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '카테고리 이름을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // 설명
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: '설명 (선택사항)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              
              // 색상 선택
              const Text(
                '색상',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _colors.length,
                  itemBuilder: (context, index) {
                    final color = _colors[index];
                    final isSelected = color == _selectedColor;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Color(int.parse(color.replaceFirst('#', '0xFF'))),
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.black, width: 3)
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 24,
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              
              // 아이콘 선택
              const Text(
                '아이콘',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: _icons.length,
                  itemBuilder: (context, index) {
                    final iconData = _icons[index];
                    final isSelected = iconData['name'] == _selectedIcon;
                    final selectedColor = Color(int.parse(_selectedColor.replaceFirst('#', '0xFF')));
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIcon = iconData['name'];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? selectedColor.withOpacity(0.1)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(color: selectedColor, width: 2)
                              : null,
                        ),
                        child: Icon(
                          iconData['icon'],
                          color: isSelected ? selectedColor : Colors.grey[600],
                          size: 28,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              
              // 저장 버튼
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveCategory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(int.parse(_selectedColor.replaceFirst('#', '0xFF'))),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isEditing ? '수정하기' : '추가하기',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      final category = Category(
        id: widget.category?.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        color: _selectedColor,
        icon: _selectedIcon,
        createdAt: widget.category?.createdAt,
        updatedAt: widget.category?.updatedAt,
      );
      
      widget.onSave(category);
      Navigator.of(context).pop();
    }
  }
}
