import csv, random

def get_rand(x: int) -> int:
    r = random.randrange(1,1000)
    while r == x:
        r = random.randrange(1,1000)
    return r

def get_probability() -> bool:
    return random.choice([1,1,1,1,1,1,1,1,0,0]) # 80% chance

# fixing data tables
users_file = open('./user copy.csv','r', encoding='utf8')
users = list(csv.DictReader(users_file))

# 80% invited, 20% not-invited
freq = [0] * 1000
for user in users:
    if get_probability():
        x = get_rand(int(user['id']))
        for _ in range(random.choice([random.randint(0,5)])):
            user['invited_by'] = x
            

with open('./updated_users.csv', 'w', encoding='utf8', newline='') as output_file:
    fieldnames = users[0].keys()
    writer = csv.DictWriter(output_file, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(users)
    
# mx = 0
# for i in range(len(freq)):
#     if i:
#         mx = max(mx,freq[i])
#         print(f'{i + 1} - {freq[i]}')

# print(f'max: {mx}')