import csv
import pandas as pd
from datetime import datetime

def create_events():
    events_file = open('event.csv', 'r', encoding='utf8')
    events = list(csv.DictReader(events_file))

    attends_file = open('event_attend.csv', 'r', encoding='utf8')
    attends = list(csv.DictReader(attends_file))

    count = 201 * [0]
    for i in range(1, 201):
        for attend in attends:
            if attend['event_id'] == i:
                count[i] += 1


    for attend in attends:
        if count[int(attend['event_id'])] > int(events[int(attend['event_id'])]['max_attendees']):
            events[attend['event_id']]['max_attendees'] = count[int(attend['event_id'])]

    with open('events_copy.csv', 'w', encoding='utf8') as file:
        fieldnames = events[0].keys()
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(events)
        print(len(events))

def check_posts():
    generated_posts = pd.read_csv('posts_backup.csv')
    membership_data = pd.read_csv('community_membership.csv')

    user_community_map = membership_data.groupby('user_id')['community_id'].apply(list).to_dict()
    invalid_posts = []

    for _, post in generated_posts.iterrows():
        user_id = post['user_id']
        visibility = post['visibility']
        community_id = post['community_id'] if pd.notnull(post['community_id']) else None

        if visibility == 'community':
            if community_id not in user_community_map.get(user_id, []):
                invalid_posts.append(post.to_dict())
        elif visibility == 'public':
            if community_id is not None:
                invalid_posts.append(post.to_dict())

    print(len(invalid_posts))

#check_posts()

def create_posts_community():
    posts = pd.read_csv('post_backup.csv')

    community_posts = []
    i = 1

    for _, post in posts.iterrows():
        if post['visibility'] == 'community':
            community_posts.append({
                'id': i,
                'post_id': post['post_id'],
                'community_id': post['community_id']
            })
            i += 1

    df_community_posts = pd.DataFrame(community_posts)
    df_community_posts.to_csv('community_posts2.csv', index=False)
# create_posts_community()

def chage_date_format():
    posts = pd.read_csv('../data/post.csv')

    result = []
    for _, post in posts.iterrows():
        old_format = datetime.strptime(post['posted_at'], '%m/%d/%Y %H:%M')

        post['posted_at'] = old_format.strftime("%Y-%m-%d %H:%M:%S")
        result.append(post)

    new_posts = pd.DataFrame(result)
    new_posts.to_csv('../data/post1.csv', index=False)
# chage_date_format()

def recreate_post_feedbacks():
    feedbacks = pd.read_csv('../data/feedback.csv')
    post_feedbacks = pd.read_csv('../data/post_feedbacks.csv')
    print(feedbacks)

    result = []
    for _,post_feedback in post_feedbacks.iterrows():
        result.append({
            'like_id': post_feedback['like_id'],
            'feedback': feedbacks.iloc[post_feedback['feedback_id'] - 1]['feedback']
        })

    result_export = pd.DataFrame(result)
    result_export.to_csv('../data/post_feedbacks1.csv', index=False)
recreate_post_feedbacks()
'''
posts [done]
post_tags
community_posts [done]

post_likes [done]
post_feedback [done]
post_comments [done]

post_repost
'''