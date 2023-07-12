import 'application_dto.dart';

class TaskData {
  final String taskId;
  final String taskName;
  final FlowableApplicationDto flowableApplicationDTO;

  TaskData({
    required this.taskId,
    required this.taskName,
    required this.flowableApplicationDTO
  });

}
