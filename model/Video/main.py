from ultralytics import YOLO
import cv2
import numpy as np
import torch
from torchvision.ops import nms
from datetime import datetime
from collections import deque

# 加载模型
model = YOLO("yolov8n.pt")

# 视频路径
video_path = r"D:\Project\sightiq\model\Video\video.mp4"
cap = cv2.VideoCapture(video_path)

if not cap.isOpened():
    print("无法打开视频")
    exit()

# 参数设置
fps = int(cap.get(cv2.CAP_PROP_FPS)) or 30  # 获取帧率，默认30
frame_count = 0
second_count = 0
person_counts_in_second = []

# 创建背景减除器
fgbg = cv2.createBackgroundSubtractorMOG2(history=500, varThreshold=16, detectShadows=False)

# 运动检测参数
MIN_MOTION_AREA = 500  # 最小运动区域面积阈值

# 分块配置列表 (每个元素是(rows, cols, offset_x, offset_y))
# offset是偏移量，用于错位分块 (0-1之间的小数)
grid_configs = [
    (4, 4, 0.0, 0.0),  # 正常6x6分块
    (6, 6, 0.3, 0.3),  # 横向和纵向都偏移30%
    (5, 5, 0.0, 0.0),  # 不同分块数
    (7, 7, 0.2, 0.5)  # 不同分块数+偏移
]


def detect_in_grid(frame, rows, cols, offset_x=0, offset_y=0):
    h, w = frame.shape[:2]
    block_h = h // rows
    block_w = w // cols

    # 计算偏移量(像素)
    offset_px_x = int(offset_x * block_w)
    offset_px_y = int(offset_y * block_h)

    all_boxes = []
    all_scores = []
    all_classes = []

    for i in range(rows):
        for j in range(cols):
            # 计算当前块的坐标(考虑偏移)
            x1 = j * block_w + offset_px_x
            y1 = i * block_h + offset_px_y
            x2 = (j + 1) * block_w + offset_px_x
            y2 = (i + 1) * block_h + offset_px_y

            # 确保不超出图像边界
            x1, y1 = max(0, x1), max(0, y1)
            x2, y2 = min(w, x2), min(h, y2)

            # 提取当前块
            block = frame[y1:y2, x1:x2]

            # 运动检测 - 获取前景掩码
            fgmask = fgbg.apply(block)
            fgmask = cv2.threshold(fgmask, 127, 255, cv2.THRESH_BINARY)[1]

            # 计算运动区域面积
            contours, _ = cv2.findContours(fgmask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
            motion_detected = any(cv2.contourArea(contour) > MIN_MOTION_AREA for contour in contours)

            # 只在有运动的区域进行检测
            if not motion_detected:
                continue

            # 使用YOLO检测当前块
            results = model(block, conf=0.1, iou=1, imgsz=640)[0]

            if results.boxes is not None and len(results.boxes) > 0:
                boxes = results.boxes.xyxy.cpu().numpy()
                scores = results.boxes.conf.cpu().numpy()
                classes = results.boxes.cls.cpu().numpy()

                # 转换坐标到原图坐标系
                boxes[:, 0] += x1
                boxes[:, 1] += y1
                boxes[:, 2] += x1
                boxes[:, 3] += y1

                # 收集所有检测结果
                all_boxes.extend(boxes)
                all_scores.extend(scores)
                all_classes.extend(classes)

    return all_boxes, all_scores, all_classes


while True:
    ret, frame = cap.read()
    if not ret:
        break

    frame_count += 1
    h, w = frame.shape[:2]

    all_detections = []

    # 使用不同的分块配置进行多次检测
    for config in grid_configs:
        rows, cols, offset_x, offset_y = config
        boxes, scores, classes = detect_in_grid(frame, rows, cols, offset_x, offset_y)
        all_detections.append((boxes, scores, classes))

    # 合并所有检测结果
    merged_boxes = []
    merged_scores = []
    merged_classes = []

    for boxes, scores, classes in all_detections:
        merged_boxes.extend(boxes)
        merged_scores.extend(scores)
        merged_classes.extend(classes)

    # 应用NMS合并重复检测
    final_boxes = []
    final_scores = []
    final_classes = []

    if len(merged_boxes) > 0:
        boxes_tensor = torch.tensor(merged_boxes, dtype=torch.float32)
        scores_tensor = torch.tensor(merged_scores, dtype=torch.float32)

        keep = nms(boxes_tensor, scores_tensor, iou_threshold=0.5)
        indices = keep.cpu().numpy()

        final_boxes = [merged_boxes[i] for i in indices]
        final_scores = [merged_scores[i] for i in indices]
        final_classes = [merged_classes[i] for i in indices]

    # 统计人数
    person_count = sum(1 for cls in final_classes if int(cls) == 0)

    # 绘制最终检测结果
    for box, score, cls in zip(final_boxes, final_scores, final_classes):
        if int(cls) == 0:  # 只处理Person类
            x1, y1, x2, y2 = map(int, box)
            label = f"Person {score:.2f}"
            color = (0, 255, 0)

            cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)
            cv2.putText(frame, label, (x1, y1 - 5),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.6, color, 1)

    # 显示当前帧的总人数
    cv2.putText(frame, f"Persons: {person_count}", (10, 30),
                cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)

    # 打印当前帧识别到的人数
    current_time = datetime.now().strftime("%H:%M:%S.%f")[:-3]
    print(f"[帧 {frame_count} | {current_time}] 人数: {person_count}")

    person_counts_in_second.append(person_count)

    # 每秒统计一次（保留最大人数）
    if frame_count % fps == 0:
        second_count += 1
        max_count = max(person_counts_in_second) if person_counts_in_second else 0
        print(f"=== 第 {second_count} 秒最大人数: {max_count} ===")
        person_counts_in_second.clear()

    # 显示
    cv2.imshow("Multi-Grid Detection", frame)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()