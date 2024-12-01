import csv

files = [
    "chat", 
    "community_membership",
    "community_posts",
    "community",
    "event_attend",
    "event",
    'interest',
    'post_comments',
    'feedbacks',
    'post_likes',
    'post_photos',
    'post_tags',
    'post_videos',
    'post',
    'tags',
    'user_follow',
    'user_interests',
    'user_messages',
    'user',
    "post_repost"
]

for f in files:
    csvFile = csv.reader(open(f'../data/{f}.csv', 'r', encoding='utf8'))

    header = next(csvFile)
    headers = map((lambda x: '`' + x + '`'), header)

    insert = f'INSERT INTO {f} (' + ", ".join(headers) + ") VALUES "

    values_list = []
    for row in csvFile:
        values = []
        for value in row:
            if value.isdigit():
                values.append(value)  
            else:
                values.append('"' + value + '"') 
        values_list.append("(" + ", ".join(values) + ")")

    final_query = insert + ",\n".join(values_list) + ";"

    with open(f'../sql/{f}.sql', 'w', encoding='utf8') as sqlFile:
        sqlFile.write(final_query)

