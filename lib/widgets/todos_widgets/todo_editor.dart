import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/todo_data.dart';
import '../../utils/app_theme.dart';

class TodoEditor extends StatefulWidget {
  final TodoData? todo;
  final Function(TodoData) onSave;

  const TodoEditor({
    super.key,
    this.todo,
    required this.onSave,
  });

  @override
  State<TodoEditor> createState() => _TodoEditorState();
}

class _TodoEditorState extends State<TodoEditor> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagController = TextEditingController();
  final List<String> _tags = [];
  TodoPriority _priority = TodoPriority.medium;
  TodoStatus _status = TodoStatus.pending;
  DateTime? _dueDate;
  String? _category;
  bool _isShared = false;

  final List<String> _categories = [
    'İş',
    'Kişisel',
    'Alışveriş',
    'Sağlık',
    'Eğlence',
    'Ev',
    'Seyahat',
    'Diğer',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _titleController.text = widget.todo!.title;
      _descriptionController.text = widget.todo!.description ?? '';
      _tags.addAll(widget.todo!.tags);
      _priority = widget.todo!.priority;
      _status = widget.todo!.status;
      _dueDate = widget.todo!.dueDate;
      _category = widget.todo!.category;
      _isShared = widget.todo!.isShared;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Başlık çubuğu
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('İptal'),
                ),
                const Spacer(),
                Text(
                  widget.todo == null ? 'Yeni Görev' : 'Görevi Düzenle',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _saveTodo,
                  child: const Text('Kaydet'),
                ),
              ],
            ),
          ),

          // İçerik
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Başlık
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Görev Başlığı',
                      hintText: 'Görev başlığını girin...',
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Açıklama
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Açıklama',
                      hintText: 'Görev açıklamasını girin...',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                    textAlignVertical: TextAlignVertical.top,
                  ),

                  const SizedBox(height: 16),

                  // Öncelik ve durum
                  Row(
                    children: [
                      // Öncelik
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Öncelik',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<TodoPriority>(
                              value: _priority,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              items: TodoPriority.values.map((priority) {
                                return DropdownMenuItem(
                                  value: priority,
                                  child: Row(
                                    children: [
                                      Text(_getPriorityIcon(priority)),
                                      const SizedBox(width: 8),
                                      Text(_getPriorityText(priority)),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _priority = value;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Durum
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Durum',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<TodoStatus>(
                              value: _status,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              items: TodoStatus.values.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Row(
                                    children: [
                                      Text(_getStatusIcon(status)),
                                      const SizedBox(width: 8),
                                      Text(_getStatusText(status)),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _status = value;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Bitiş tarihi
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bitiş Tarihi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _selectDueDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _dueDate != null
                                    ? DateFormat('dd MMM yyyy, HH:mm').format(_dueDate!)
                                    : 'Bitiş tarihi seçin',
                                style: TextStyle(
                                  color: _dueDate != null ? Colors.black : Colors.grey[600],
                                ),
                              ),
                              const Spacer(),
                              if (_dueDate != null)
                                IconButton(
                                  icon: const Icon(Icons.clear, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      _dueDate = null;
                                    });
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Kategori
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kategori',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _category,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Kategori seçin'),
                          ),
                          ..._categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _category = value;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Tag'ler
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Etiketler',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Mevcut tag'ler
                      if (_tags.isNotEmpty) ...[
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: _tags.map((tag) {
                            return Chip(
                              label: Text(tag),
                              onDeleted: () {
                                setState(() {
                                  _tags.remove(tag);
                                });
                              },
                              deleteIcon: const Icon(Icons.close, size: 18),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 8),
                      ],

                      // Tag ekleme
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _tagController,
                              decoration: const InputDecoration(
                                hintText: 'Etiket ekle...',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              onSubmitted: _addTag,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => _addTag(_tagController.text),
                            icon: const Icon(Icons.add),
                            style: IconButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Paylaşım ayarı
                  SwitchListTile(
                    title: const Text('Sevgilinizle paylaş'),
                    subtitle: const Text('Bu görevi sevgilinizle paylaşın'),
                    value: _isShared,
                    onChanged: (value) {
                      setState(() {
                        _isShared = value;
                      });
                    },
                    activeColor: AppTheme.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPriorityIcon(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.low:
        return '🟢';
      case TodoPriority.medium:
        return '🟡';
      case TodoPriority.high:
        return '🟠';
      case TodoPriority.urgent:
        return '🔴';
    }
  }

  String _getPriorityText(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.low:
        return 'Düşük';
      case TodoPriority.medium:
        return 'Orta';
      case TodoPriority.high:
        return 'Yüksek';
      case TodoPriority.urgent:
        return 'Acil';
    }
  }

  String _getStatusIcon(TodoStatus status) {
    switch (status) {
      case TodoStatus.pending:
        return '⏳';
      case TodoStatus.inProgress:
        return '🔄';
      case TodoStatus.completed:
        return '✅';
      case TodoStatus.cancelled:
        return '❌';
    }
  }

  String _getStatusText(TodoStatus status) {
    switch (status) {
      case TodoStatus.pending:
        return 'Bekliyor';
      case TodoStatus.inProgress:
        return 'Devam Ediyor';
      case TodoStatus.completed:
        return 'Tamamlandı';
      case TodoStatus.cancelled:
        return 'İptal';
    }
  }

  void _addTag(String tag) {
    if (tag.trim().isNotEmpty && !_tags.contains(tag.trim())) {
      setState(() {
        _tags.add(tag.trim());
        _tagController.clear();
      });
    }
  }

  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _dueDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _saveTodo() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Görev başlığı gerekli'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    final todo = TodoData(
      id: widget.todo?.id ?? '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty 
          ? null 
          : _descriptionController.text.trim(),
      priority: _priority,
      status: _status,
      createdAt: widget.todo?.createdAt ?? DateTime.now(),
      dueDate: _dueDate,
      completedAt: _status == TodoStatus.completed 
          ? DateTime.now() 
          : widget.todo?.completedAt,
      tags: _tags,
      isShared: _isShared,
      assignedTo: _isShared ? 'partner_id' : null,
      createdBy: 'user_id',
      category: _category,
    );

    widget.onSave(todo);
    Navigator.of(context).pop();
  }
}
