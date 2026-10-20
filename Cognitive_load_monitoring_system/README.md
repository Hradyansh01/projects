# Cognitive Load Monitoring System

A wearable health-monitoring project using an ESP32 and AWS IoT, intended to flag fatigue or stress from heart rate, skin temperature, and motion.

## Status

- **ESP32 firmware (C):** Sensor reading and data transmission were written, but did not work as intended in testing.
- **AWS pipeline (IoT Core → Lambda → DynamoDB → SNS):** Built during the project, but the account is no longer accessible, so it is not included or verified here.
- **Dataset generator (Python):** Creates simulated readings to test the threshold logic.

## Dataset Generator

`generate_dataset.py` creates 10 simulated users with 100 readings each, taken every 3 minutes. Fields: `user_id`, `timestamp`, `heart_rate`, `temp`, `motion_level`.

- 95% normal: HR 68–88 BPM, temp 36.4–37.2 °C, motion 0.25–0.65
- 5% fatigue/stress: HR 92–108 BPM, temp 37.6–38.3 °C, motion 0.05–0.18

The data is randomly generated, not recorded from people. It tests the logic only and says nothing about real-world accuracy.

## Tools

ESP32, Arduino C, Python, AWS IoT Core, AWS Lambda, DynamoDB, SNS
