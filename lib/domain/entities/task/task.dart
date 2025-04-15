class Task {
  String? id;
  String? taskCode;
  String? orderId;
  String? employeeId;
  String? employeeName;
  String? taskName;
  Null? description;
  String? priority;
  Null? startDate;
  Null? dueDate;
  String? completedDate;
  String? assignedBy;
  String? managerName;
  Null? notes;
  String? status;
  String? createdAt;
  String? updatedAt;

  Task(
      {this.id,
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
        this.updatedAt});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskCode = json['taskCode'];
    orderId = json['orderId'];
    employeeId = json['employeeId'];
    employeeName = json['employeeName'];
    taskName = json['taskName'];
    description = json['description'];
    priority = json['priority'];
    startDate = json['startDate'];
    dueDate = json['dueDate'];
    completedDate = json['completedDate'];
    assignedBy = json['assignedBy'];
    managerName = json['managerName'];
    notes = json['notes'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['taskCode'] = this.taskCode;
    data['orderId'] = this.orderId;
    data['employeeId'] = this.employeeId;
    data['employeeName'] = this.employeeName;
    data['taskName'] = this.taskName;
    data['description'] = this.description;
    data['priority'] = this.priority;
    data['startDate'] = this.startDate;
    data['dueDate'] = this.dueDate;
    data['completedDate'] = this.completedDate;
    data['assignedBy'] = this.assignedBy;
    data['managerName'] = this.managerName;
    data['notes'] = this.notes;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}