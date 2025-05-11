import cv2
from ultralytics import YOLO

model = YOLO("yolov8n.pt")  # 使用 nano 模型，更轻便

cap = cv2.VideoCapture("video.mp4")  # 或者 0 表示摄像头

while True:
    ret, frame = cap.read()
    if not ret:
        break

    results = model(frame)
    annotated_frame = results[0].plot()

    # 统计人类目标
    people_count = sum(1 for r in results[0].boxes.cls if int(r) == 0)  # 0 是 'person' 类别

    cv2.putText(annotated_frame, f'People: {people_count}', (20, 40),
                cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
    cv2.imshow("YOLOv8n Human Count", annotated_frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
