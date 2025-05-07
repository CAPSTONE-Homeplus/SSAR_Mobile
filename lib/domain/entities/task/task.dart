class Task {
  final String id;
  final String? taskCode;
  final String? orderId;
  final String? employeeId;
  final String? employeeName;
  final String? taskName;
  final String? description;
  final String? priority;
  final DateTime? startDate;
  final DateTime? dueDate;
  final DateTime? completedDate;
  final String? assignedBy;
  final String? managerName;
  final String? notes;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Task({
    required this.id,
    this.taskCode,
    this.orderId,
    this.employeeId,
    this.employeeName,
    this.taskName,
    this.description,
    this.priority,
    this.startDate,
    this.dueDate,
    this.completedDate,
    this.assignedBy,
    this.managerName,
    this.notes,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      taskCode: json['taskCode'] as String?,
      orderId: json['orderId'] as String?,
      employeeId: json['employeeId'] as String?,
      employeeName: json['employeeName'] as String?,
      taskName: json['taskName'] as String?,
      description: json['description'] as String?,
      priority: json['priority'] as String?,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'].toString())
          : null,
      dueDate: json['dueDate'] != null
          ? DateTime.tryParse(json['dueDate'].toString())
          : null,
      completedDate: json['completedDate'] != null
          ? DateTime.tryParse(json['completedDate'].toString())
          : null,
      assignedBy: json['assignedBy'] as String?,
      managerName: json['managerName'] as String?,
      notes: json['notes'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'taskCode': taskCode,
    'orderId': orderId,
    'employeeId': employeeId,
    'employeeName': employeeName,
    'taskName': taskName,
    'description': description,
    'priority': priority,
    'startDate': startDate?.toIso8601String(),
    'dueDate': dueDate?.toIso8601String(),
    'completedDate': completedDate?.toIso8601String(),
    'assignedBy': assignedBy,
    'managerName': managerName,
    'notes': notes,
    'status': status,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  Task copyWith({
    String? taskCode,
    String? orderId,
    String? employeeId,
    String? employeeName,
    String? taskName,
    String? description,
    String? priority,
    DateTime? startDate,
    DateTime? dueDate,
    DateTime? completedDate,
    String? assignedBy,
    String? managerName,
    String? notes,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id,
      taskCode: taskCode ?? this.taskCode,
      orderId: orderId ?? this.orderId,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      taskName: taskName ?? this.taskName,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      completedDate: completedDate ?? this.completedDate,
      assignedBy: assignedBy ?? this.assignedBy,
      managerName: managerName ?? this.managerName,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Task && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}