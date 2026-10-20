# Cognitive Load Monitoring System

An ESP32-based smartwatch that reads temperature, acceleration, and SpO₂ and sends the data to AWS for fatigue detection and health-status alerts.

## Design

- **Sensing:** Temperature, accelerometer, and SpO₂ sensors on an ESP32
- **Data path:** ESP32 → AWS IoT Core → Lambda → DynamoDB → SNS
- **Processing:** Real-time filtering and threshold logic to reduce false alerts

## Tools

ESP32, AWS IoT Core, AWS Lambda, DynamoDB, SNS
