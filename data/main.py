import csv

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