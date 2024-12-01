import csv, random, string


def get_rand(x: int) -> int:
    r = random.randrange(1,1000)
    while r == x:
        r = random.randrange(1,1000)
    return r
def get_probability() -> bool:
    return random.choice([1,1,1,1,1,1,1,1,0,0])

def generate_invited_by():
    users_file = open('../data/user.csv','r', encoding='utf8')
    users = list(csv.DictReader(users_file))
    freq = [0] * 1000
    for user in users:
        if get_probability():
            x = get_rand(int(user['user_id']))
            for _ in range(random.choice([random.randint(0,5)])):
                user['invited_by'] = x
                
    with open('../data/updated_users.csv', 'w', encoding='utf8', newline='') as output_file:
        fieldnames = users[0].keys()
        writer = csv.DictWriter(output_file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(users)


def fix_commas():
    users_file = open('../data/user.csv','r', encoding='utf8')
    users = list(csv.DictReader(users_file))

    for user in users:
        user['education'] = user['education'].replace('"', '')

        # characters = string.ascii_letters + string.digits
        # password = ''.join(random.choice(characters) for _ in range(random.randint(8, 14)))
        # print(password)
        # user['password'] = password

    with open('../data/updated_users.csv', 'w', encoding='utf8', newline='') as output_file:
        fieldnames = users[0].keys()
        writer = csv.DictWriter(output_file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(users)
        print(len(users))

fix_commas()