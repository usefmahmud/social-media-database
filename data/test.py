import random
import pandas as pd
from datetime import datetime, timedelta

def random_datetime(start, end):
    start_dt = datetime.strptime(start, "%Y-%m-%d %H:%M:%S")
    end_dt = datetime.strptime(end, "%Y-%m-%d %H:%M:%S")
    delta = end_dt - start_dt
    random_seconds = random.randint(0, int(delta.total_seconds()))
    return (start_dt + timedelta(seconds=random_seconds)).strftime("%Y-%m-%d %H:%M:%S")

def generate_random_text():
    words = ["Amazing", "Interesting", "Great", "Good", "Not bad", "Awesome", "Could be better", "Nice", "Well done"]
    return random.choice(words) + "."

post_backup = pd.read_csv('post_backup.csv')
public_posts = post_backup[post_backup['visibility'] == 'public']

likes_data = []
like_id = 1
for user_id in range(1, 1001):
    num_likes = random.randint(0, 20) 
    if num_likes == 0:
        continue  
    sampled_posts = public_posts.sample(num_likes)
    for _, post in sampled_posts.iterrows():
        like_type = "like" if random.random() < 0.7 else "dislike"
        likes_data.append({
            "like_id": like_id,
            "post_id": post['post_id'],
            "user_id": user_id,
            "type": like_type,
            "liked_at": random_datetime("2023-01-01 00:00:00", "2024-12-31 23:59:59")
        })
        like_id += 1

likes_df = pd.DataFrame(likes_data)
feedback = pd.read_csv('feedback.csv')

feedbacks_data = []
feedback_id = 1
dislikes = likes_df[likes_df['type'] == 'dislike']
for _, dislike in dislikes.iterrows():
    feedbacks_data.append({
        "id": feedback_id,
        "feedback_id": random.choice(feedback['feedback_id']),
        "like_id": dislike['like_id'],
        "post_id": dislike['post_id']
    })
    feedback_id += 1

feedbacks_df = pd.DataFrame(feedbacks_data)

comments_data = []
comment_id = 1
for user_id in range(1, 1001):
    num_comments = random.randint(0, 15) 
    if num_comments == 0:
        continue
    sampled_posts = public_posts.sample(num_comments)
    for _, post in sampled_posts.iterrows():
        comments_data.append({
            "comment_id": comment_id,
            "post_id": post['post_id'],
            "user_id": user_id,
            "comment_text": generate_random_text(),
            "commented_at": random_datetime("2023-01-01 00:00:00", "2024-12-31 23:59:59")
        })
        comment_id += 1

comments_df = pd.DataFrame(comments_data)

likes_df.to_csv("post_likes2.csv", index=False)
feedbacks_df.to_csv("post_feedbacks2.csv", index=False)
comments_df.to_csv("post_comments2.csv", index=False)