import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/todo_data.dart';
import '../../utils/app_theme.dart';

class TodoCard extends StatelessWidget {
  final TodoData todo;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;

  const TodoCard({
    super.key,
    required this.todo,
    this.onTap,
    this.onEdit,
    this.onToggle,
    this.onDelete,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık ve durum
              Row(
                children: [
                  // Checkbox
                  Checkbox(
                    value: todo.status == TodoStatus.completed,
                    onChanged: (_) => onToggle?.call(),
                    activeColor: AppTheme.successColor,
                  ),
                  
                  // Başlık
                  Expanded(
                    child: Text(
                      todo.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: todo.status == TodoStatus.completed
                            ? TextDecoration.lineThrough
                            : null,
                        color: todo.status == TodoStatus.completed
                            ? Colors.grey[600]
                            : null,
                      ),
                    ),
                  ),

                  // Menü
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit?.call();
                          break;
                        case 'share':
                          onShare?.call();
                          break;
                        case 'delete':
                          onDelete?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Düzenle'),
                          ],
                        ),
                      ),
                      if (todo.isShared)
                        const PopupMenuItem(
                          value: 'unshare',
                          child: Row(
                            children: [
                              Icon(Icons.share_off, size: 20),
                              SizedBox(width: 8),
                              Text('Paylaşımı Kaldır'),
                            ],
                          ),
                        )
                      else
                        const PopupMenuItem(
                          value: 'share',
                          child: Row(
                            children: [
                              Icon(Icons.share, size: 20),
                              SizedBox(width: 8),
                              Text('Paylaş'),
                            ],
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Sil', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Açıklama
              if (todo.description != null && todo.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  todo.description!,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 12),

              // Öncelik ve durum
              Row(
                children: [
                  // Öncelik
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(todo.priority).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getPriorityColor(todo.priority).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          todo.priorityIcon,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getPriorityText(todo.priority),
                          style: TextStyle(
                            color: _getPriorityColor(todo.priority),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Durum
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(todo.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusColor(todo.status).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          todo.statusIcon,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getStatusText(todo.status),
                          style: TextStyle(
                            color: _getStatusColor(todo.status),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Paylaşım durumu
                  if (todo.isShared) ...[
                    Icon(
                      Icons.share,
                      size: 16,
                      color: AppTheme.successColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Paylaşıldı',
                      style: TextStyle(
                        color: AppTheme.successColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),

              // Bitiş tarihi
              if (todo.dueDate != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: todo.isOverdue ? AppTheme.errorColor : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Bitiş: ${DateFormat('dd MMM yyyy, HH:mm').format(todo.dueDate!)}',
                      style: TextStyle(
                        color: todo.isOverdue ? AppTheme.errorColor : Colors.grey[600],
                        fontSize: 12,
                        fontWeight: todo.isOverdue ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    if (todo.isOverdue) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'GECİKME',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],

              // Tag'ler
              if (todo.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: todo.tags.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],

              // Kategori
              if (todo.category != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    todo.category!,
                    style: TextStyle(
                      color: AppTheme.secondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.low:
        return AppTheme.successColor;
      case TodoPriority.medium:
        return AppTheme.warningColor;
      case TodoPriority.high:
        return AppTheme.errorColor;
      case TodoPriority.urgent:
        return AppTheme.secondaryColor;
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

  Color _getStatusColor(TodoStatus status) {
    switch (status) {
      case TodoStatus.pending:
        return Colors.grey;
      case TodoStatus.inProgress:
        return AppTheme.primaryColor;
      case TodoStatus.completed:
        return AppTheme.successColor;
      case TodoStatus.cancelled:
        return AppTheme.errorColor;
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
}
