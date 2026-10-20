import csv
import random
import datetime

# Configuration
NUM_USERS = 10              # total users
READINGS_PER_USER = 100     # readings per user
OUTPUT_FILE = "dataset.csv"

def generate_sensor_data():
    """
    Generates simulated wearable sensor readings for multiple users.
    Balanced realistic distribution: 95% normal, 5% fatigue events.
    """
    fieldnames = ["user_id", "timestamp", "heart_rate", "temp", "motion_level"]
    start_time = datetime.datetime(2025, 10, 30, 10, 0, 0)

    with open(OUTPUT_FILE, mode="w", newline="") as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()

        for user in range(1, NUM_USERS + 1):
            user_id = f"user{user:02d}"

            for reading in range(READINGS_PER_USER):
                timestamp = (start_time + datetime.timedelta(minutes=3 * reading)).strftime("%Y-%m-%dT%H:%M:%SZ")

                # 95% normal readings
                if random.random() < 0.95:
                    hr = random.uniform(68, 88)            # normal 68–88 BPM
                    temp = random.uniform(36.4, 37.2)     # normal 36.4–37.2 °C
                    motion = random.uniform(0.25, 0.65)   # moderate motion
                else:
                    # 5% fatigue / stress spikes
                    hr = random.uniform(92, 108)          # stressed >92 BPM
                    temp = random.uniform(37.6, 38.3)     # stressed >37.6 °C
                    motion = random.uniform(0.05, 0.18)   # very low motion

                writer.writerow({
                    "user_id": user_id,
                    "timestamp": timestamp,
                    "heart_rate": round(hr, 1),
                    "temp": round(temp, 1),
                    "motion_level": round(motion, 2)
                })

    print(f"✅ Generated dataset with {NUM_USERS * READINGS_PER_USER} rows → {OUTPUT_FILE}")

if __name__ == "__main__":
    generate_sensor_data()