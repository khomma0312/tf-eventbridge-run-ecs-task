# tf-eventbridge-run-ecs-task

EventBridge Scheduler で ECS を定期実行する機能の Terraform コード。

## 注意点

初回の apply 時は、ECS タスク実行時に参照する ECR リポジトリも Scheduler と同時に作られるので、Scheduler 作成時に参照するイメージ、タスク定義がまだなく、途中で失敗する。

ECR を作成し、参照先のイメージ、タスク定義をプッシュした後に再度 apply を実行すると成功するので、適宜手動で必要なリソースは作成する。
