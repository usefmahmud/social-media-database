import csv
import pandas as pd

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


check_posts()



'''
posts
post_tags
community_posts

post_likes
post_feedback
post_comments

post_repost
'''