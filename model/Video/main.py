from ultralytics import YOLO

# 从头创建一个新的 YOLO 模型
model = YOLO("yolov8n.yaml")

# 加载一个预训练的 YOLO 模型（推荐用于训练）
model = YOLO("yolov8n.pt")

# 使用 'coco8.yaml' 数据集训练模型 3 个周期
results = model.train(data="coco8.yaml", epochs=3)

# 在验证集上评估模型性能
results = model.val()

# 使用模型对图像进行目标检测
results = model("https://ultralytics.com/images/bus.jpg")

# 将模型导出为 ONNX 格式
success = model.export(format="onnx")

