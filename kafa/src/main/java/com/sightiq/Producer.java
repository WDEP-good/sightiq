package com.sightiq;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.RecordMetadata;

import java.util.Properties;

public class Producer {
    public static void main(String[] args) {
        // 设置 Kafka 配置
        Properties props = new Properties();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "localhost:9092");
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG,
                "org.apache.kafka.common.serialization.StringSerializer");
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG,
                "org.apache.kafka.common.serialization.StringSerializer");

        // 创建 Producer 实例
        KafkaProducer<String, String> producer = new KafkaProducer<>(props);

        // 构建消息
        String topic = "test-topic";
        String key = "frame001";
        String value = "{\"label\":\"person\", \"x\":100, \"y\":200}";

        // 发送消息
        ProducerRecord<String, String> record = new ProducerRecord<>(topic, key, value);

        try {
            RecordMetadata metadata = producer.send(record).get();
            System.out.printf("消息已发送: topic=%s, partition=%d, offset=%d\n",
                    metadata.topic(), metadata.partition(), metadata.offset());
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            producer.close();
        }
    }
}
