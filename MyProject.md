# New Demands

1. 甘特图
2. 图形界面
3. 按月，周数，星期布置任务
4. 按天修正任务
5. deadline提醒
6. 加入优先级

# 实现

### 创建任务类

属性：任务名称，工作日，deadline，优先级，所属任务组，完成状态

方法：添加工作日，deadline提醒(提高优先级)，优先级初始化(有所属任务组时默认为任务组优先级)，删除工作日，完成状态判定



### 创建任务组类

属性：任务列表，deadline，完成状态

方法：添加任务，删除任务，初始化，deadline提醒，完成状态判定



### 创建日期类

属性：日期，周数，星期几，任务列表