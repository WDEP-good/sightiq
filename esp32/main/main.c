#include "esp_camera.h"
#include <WiFi.h>
#include <WebServer.h>
#include "camera_pins.h"   // ESP32 Camera 引脚配置

#define CAMERA_MODEL_AI_THINKER // 如果你使用的是 ESP32-CAM
WebServer server(80);

void startCameraServer()
{
  server.on("/camera", HTTP_GET, []()
            {
    WiFiClient client = server.client();
    while (client.connected()) {
      camera_fb_t * fb = esp_camera_fb_get();  // 获取一帧图像
      if (!fb) {
        Serial.println("Camera capture failed");
        continue;
      }

      // 设置 MJPEG 响应头
      server.sendHeader("Content-Type", "multipart/x-mixed-replace; boundary=frame");
      server.send(200, "text/html", "");

      // 持续发送每一帧 JPEG 数据
      while (client.connected()) {
        server.sendContent("--frame\r\n");
        server.sendContent("Content-Type: image/jpeg\r\n");
        server.sendContent("Content-Length: ");
        server.sendContent(String(fb->len).c_str());
        server.sendContent("\r\n\r\n");
        server.sendContent((const char*)fb->buf, fb->len);
        server.sendContent("\r\n");

        esp_camera_fb_return(fb);
        delay(100); // 控制帧率
        fb = esp_camera_fb_get();
      }
    } });

  server.begin();
}

void setup()
{
  Serial.begin(115200);

  // 摄像头配置
  camera_config_t config;
  config.ledc_channel = LEDC_CHANNEL_0;
  config.ledc_timer = LEDC_TIMER_0;
  config.pin_d0 = 5;
  config.pin_d1 = 18;
  config.pin_d2 = 19;
  config.pin_d3 = 21;
  config.pin_d4 = 36;
  config.pin_d5 = 39;
  config.pin_d6 = 34;
  config.pin_d7 = 35;
  config.pin_xclk = 0;
  config.pin_pclk = 22;
  config.pin_vsync = 25;
  config.pin_href = 23;
  config.pin_sscb_sda = 26;
  config.pin_sscb_scl = 27;
  config.pin_reset = -1;
  config.xclk_freq_hz = 20000000;
  config.pixel_format = PIXFORMAT_JPEG; // 设置为 JPEG 格式
  config.frame_size = FRAMESIZE_VGA;    // 可根据需要设置分辨率
  config.jpeg_quality = 12;             // JPEG 压缩质量（0 - 63，值越小质量越高）
  config.fb_count = 1;

  // 初始化摄像头
  esp_camera_init(&config);

  // 连接 Wi-Fi
  WiFi.begin("yourSSID", "yourPASSWORD");
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }

  Serial.println("Connected to WiFi");

  startCameraServer();
}

void loop()
{
  server.handleClient();
}
