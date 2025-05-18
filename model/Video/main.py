from ultralytics import YOLO
import cv2
import numpy as np
import torch
from torchvision.ops import nms

# 加载模型
model = YOLO("yolov8m.pt")

# 视频路径
video_path = r"D:\Project\sightiq\model\Video\测试视频.mp4"
cap = cv2.VideoCapture(video_path)

if not cap.isOpened():
    print("无法打开视频")
    exit()

fps = int(cap.get(cv2.CAP_PROP_FPS)) or 30  # 获取帧率，默认 30
frame_count = 0
second_count = 0
person_counts_in_second = []

# 多尺度倍率
scales = [1.0, 1.25]

while True:
    ret, frame = cap.read()
    if not ret:
        break

    frame_count += 1
    h0, w0 = frame.shape[:2]

    all_boxes = []
    all_scores = []
    all_classes = []

    # 多尺度推理
    for scale in scales:
        scaled_frame = cv2.resize(frame, (0, 0), fx=scale, fy=scale)
        results = model(scaled_frame, conf=0.001, iou=0.3, imgsz=1280)[0]

        if results.boxes is not None and len(results.boxes) > 0:
            boxes = results.boxes.xyxy.cpu().numpy()
            scores = results.boxes.conf.cpu().numpy()
            classes = results.boxes.cls.cpu().numpy()

            boxes /= scale

            all_boxes.extend(boxes)
            all_scores.extend(scores)
            all_classes.extend(classes)

    person_count = 0
    if len(all_boxes) > 0:
        boxes_tensor = torch.tensor(all_boxes, dtype=torch.float32)
        scores_tensor = torch.tensor(all_scores, dtype=torch.float32)

        keep = nms(boxes_tensor, scores_tensor, iou_threshold=0.3)
        indices = keep.cpu().numpy()

        person_count = sum(1 for i in indices if int(all_classes[i]) == 0)
        person_counts_in_second.append(person_count)

        # 可视化
        for i in indices:
            x1, y1, x2, y2 = map(int, all_boxes[i])
            cls = int(all_classes[i])
            label = f"Person {all_scores[i]:.2f}" if cls == 0 else f"Class {cls} {all_scores[i]:.2f}"
            color = (0, 255, 0) if cls == 0 else (255, 0, 0)
            cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)
            cv2.putText(frame, label, (x1, y1 - 5), cv2.FONT_HERSHEY_SIMPLEX, 0.6, color, 1)

    # 每秒统计一次
    if frame_count % fps == 0:
        second_count += 1
        max_count = max(person_counts_in_second) if person_counts_in_second else 0
        print(f"第 {second_count} 秒识别到 {max_count} 人")
        person_counts_in_second.clear()

    # 显示
    cv2.imshow("Multi-scale YOLOv8 人物检测", frame)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
