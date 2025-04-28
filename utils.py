import random
def point(x, y):
    return f'point("{x},{y}")'

def rectangle(x1, y1, x2, y2):
    return f'rectangle("{x1},{y1} {x2},{y2}")'

def create_offset_rectangle(x, y):
        sigma_values = [3, 4, 5]  # Possible selectivities (σ)
        
        sigma = random.choice(sigma_values)
        width = 360 * (10 ** -sigma)
        height = 180 * (10 ** -sigma)
        
        # Ensure coordinates are floats before calculations
        center_x = float(x)
        center_y = float(y)
        
        # Calculate MBR (Minimum Bounding Rectangle)
        start_x = center_x - (width / 2)
        end_x = center_x + (width / 2)
        start_y = center_y - (height / 2)
        end_y = center_y + (height / 2)
        
        return start_x, start_y, end_x, end_y
    
    
import time
import json
import datetime
import os
class Logger:
    def __init__(self, name_separators, console_log=False):
        log_identifiers = "_".join(map(str, name_separators))
        self.log_file_path = f"./logs/benchmark/benchmark_{log_identifiers}_{str(time.time())}.log"
        self.latest_log_file_path = f"./logs/benchmark/benchmark_{log_identifiers}_latest.log"
        self.console_log = console_log
        if not os.path.exists(os.path.dirname(self.log_file_path)):
            os.makedirs(os.path.dirname(self.log_file_path))
        with open(self.latest_log_file_path, "w") as f:
            f.write("")

    def log(self, obj):
        timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        value_to_log = f"{timestamp} - INFO - {json.dumps(obj)}\n"
        
        if self.console_log:
            print(value_to_log, end="")
        with open(self.log_file_path, "a") as f, open(self.latest_log_file_path, "a") as f_latest:
            f.write(value_to_log)
            f_latest.write(value_to_log)
            f.flush()
            f_latest.flush()
    
    def error(self, obj):
        timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        value_to_log = f"{timestamp} - ERROR - {json.dumps(obj)}\n"
        
        if self.console_log:
            print(value_to_log)
        else:
            print(value_to_log, end="")
            with open(self.log_file_path, "a") as f, open(self.latest_log_file_path, "a") as f_latest:
                f.write(value_to_log)
                f_latest.write(value_to_log)
                f.flush()
                f_latest.flush()