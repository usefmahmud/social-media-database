import csv
import random
from datetime import datetime, timedelta

def load_posts(file_path):
    with open(file_path, "r", encoding='utf8') as file:
        reader = csv.reader(file)
        next(reader)
        return [(row[0], row[2]) for row in reader]  

# Load users.csv
def load_users(file_path):
    with open(file_path, "r", encoding='utf8') as file:
        reader = csv.reader(file)
        next(reader) 
        return [row[0] for row in reader]

# Generate a random datetime between two dates
def random_datetime(start_year, end_year):
    start = datetime(start_year, 1, 1)
    end = datetime(end_year, 12, 31, 23, 59, 59)
    delta = end - start
    random_seconds = random.randint(0, int(delta.total_seconds()))
    return (start + timedelta(seconds=random_seconds)).strftime("%Y-%m-%d %H:%M:%S")

def generate_reposts(public_posts, users):
    reposts = [("repost_id", "user_id", "post_id", "reposted_at")] 
    repost_id = 1
    for post_id in public_posts:
        if random.random() > 0.3: 
            num_reposts = random.randint(1, 30)  
            selected_users = random.sample(users, num_reposts)
            for user_id in selected_users:
                reposted_at = random_datetime(2018, 2024)
                reposts.append((repost_id, user_id, post_id, reposted_at))
                repost_id += 1
    return reposts

def write_reposts(file_path, reposts):
    with open(file_path, "w", newline="") as file:
        writer = csv.writer(file)
        writer.writerows(reposts)

posts = load_posts("../data/post.csv")
users = load_users("../data/user.csv")

public_posts = [post_id for post_id, visibility in posts if visibility == "public"]

reposts = generate_reposts(public_posts, users)

write_reposts("../data/post_repost.csv", reposts)

print("Reposts generated and saved to post_repost.csv")
