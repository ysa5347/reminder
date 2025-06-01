import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/category.dart';
import '../blocs/item_list/item_list_bloc.dart';
import '../blocs/item_list/item_list_event.dart';
import '../blocs/category/category_bloc.dart';
import '../blocs/category/category_state.dart';

class ItemDetailBottomSheet extends StatefulWidget {
  final Item? item;
  final Function(Item) onSave;

  const ItemDetailBottomSheet({
    Key? key,
    this.item,
    required this.onSave,
  }) : super(key: key);

  @override
  State<ItemDetailBottomSheet> createState() => _ItemDetailBottomSheetState();
}

class _ItemDetailBottomSheetState extends State<ItemDetailBottomSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dueDateController;
  late final TextEditingController _dueTimeController;

  late bool _isImportant;
  late int _priority;
  late int? _selectedCategoryId;
  late bool _hasRepeat;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item?.title ?? '');
    _descriptionController = TextEditingController(text: widget.item?.description ?? '');
    
    // Parse due date if exists
    String dueDate = '';
    String dueTime = '';
    if (widget.item?.due != null) {
      final dueParts = widget.item!.due!.split('_');
      if (dueParts.length >= 5) {
        dueDate = '${dueParts[0]}-${dueParts[1]}-${dueParts[2]}';
        dueTime = '${dueParts[3]}:${dueParts[4]}';
      }
    }
    _dueDateController = TextEditingController(text: dueDate);
    _dueTimeController = TextEditingController(text: dueTime);
    
    _isImportant = (widget.item?.flag ?? 0) == 1;
    _priority = widget.item?.priority ?? 3;
    _selectedCategoryId = widget.item?.categoryId;
    _hasRepeat = widget.item?.repeatId != null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    _dueTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Title
                  Text(
                    widget.item == null ? '새 아이템' : '아이템 수정',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Title Input
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: '제목',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '제목을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Description Input
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: '설명 (선택사항)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  
                  // Due Date and Time
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _dueDateController,
                          decoration: const InputDecoration(
                            labelText: '마감일',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: _parseDateFromController(_dueDateController.text) ?? DateTime.now(),
                              firstDate: DateTime.now().subtract(const Duration(days: 365)),
                              lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                            );
                            if (selectedDate != null) {
                              _dueDateController.text = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _dueTimeController,
                          decoration: const InputDecoration(
                            labelText: '시간',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.access_time),
                          ),
                          readOnly: true,
                          onTap: () async {
                            final selectedTime = await showTimePicker(
                              context: context,
                              initialTime: _parseTimeFromController(_dueTimeController.text) ?? TimeOfDay.now(),
                            );
                            if (selectedTime != null) {
                              _dueTimeController.text = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Flag (Important)
                  SwitchListTile(
                    title: const Text('중요 표시'),
                    subtitle: const Text('중요한 작업으로 표시'),
                    value: _isImportant,
                    onChanged: (value) {
                      setState(() {
                        _isImportant = value;
                      });
                    },
                    secondary: Icon(
                      _isImportant ? Icons.flag : Icons.flag_outlined,
                      color: _isImportant ? Colors.red : Colors.grey,
                    ),
                  ),
                  
                  // Priority
                  const Text(
                    '우선순위',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      final priority = index + 1;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _priority = priority;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: _priority == priority ? Colors.blue : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              priority.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _priority == priority ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  
                  // Category
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoaded) {
                        return DropdownButtonFormField<int>(
                          value: _selectedCategoryId,
                          decoration: const InputDecoration(
                            labelText: '카테고리',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.category),
                          ),
                          items: [
                            const DropdownMenuItem<int>(
                              value: null,
                              child: Text('카테고리 없음'),
                            ),
                            ...state.categories.map((category) {
                              return DropdownMenuItem<int>(
                                value: category.id,
                                child: Text(category.name),
                              );
                            }),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCategoryId = value;
                            });
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Repeat (placeholder for future implementation)
                  SwitchListTile(
                    title: const Text('반복'),
                    subtitle: const Text('정기적으로 반복 (추후 구현 예정)'),
                    value: _hasRepeat,
                    onChanged: (value) {
                      setState(() {
                        _hasRepeat = value;
                      });
                    },
                    secondary: const Icon(Icons.repeat),
                  ),
                  const SizedBox(height: 24),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('취소'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveItem,
                          child: Text(widget.item == null ? '추가' : '수정'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final nowString = '${now.year}_${now.month.toString().padLeft(2, '0')}_${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}_${now.minute.toString().padLeft(2, '0')}';
      
      // Parse due date time
      String? dueString;
      if (_dueDateController.text.isNotEmpty && _dueTimeController.text.isNotEmpty) {
        final dateParts = _dueDateController.text.split('-');
        final timeParts = _dueTimeController.text.split(':');
        if (dateParts.length == 3 && timeParts.length == 2) {
          dueString = '${dateParts[0]}_${dateParts[1]}_${dateParts[2]}_${timeParts[0]}_${timeParts[1]}';
        }
      }
      
      final item = Item(
        id: widget.item?.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        createdAt: widget.item?.createdAt ?? nowString, // 새 아이템인 경우 현재 시간 사용
        updatedAt: nowString,
        due: dueString,
        completedAt: widget.item?.completedAt,
        flag: _isImportant ? 1 : 0,
        priority: _priority,
        repeatId: _hasRepeat ? 1 : null, // placeholder
        parentId: widget.item?.parentId,
        categoryId: _selectedCategoryId,
      );
      
      widget.onSave(item);
      Navigator.of(context).pop();
    }
  }

  DateTime? _parseDateFromController(String dateString) {
    if (dateString.isEmpty) return null;
    try {
      final parts = dateString.split('-');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
      }
    } catch (e) {
      // ignore
    }
    return null;
  }

  TimeOfDay? _parseTimeFromController(String timeString) {
    if (timeString.isEmpty) return null;
    try {
      final parts = timeString.split(':');
      if (parts.length == 2) {
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    } catch (e) {
      // ignore
    }
    return null;
  }
}
