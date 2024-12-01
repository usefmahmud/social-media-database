-- most active users in texting
select
	concat(user.first_name, ' ', user.last_name) as full_name,
    count(user_messages.from_id) as "from",
    count(user_messages.to_id) as "to"
from user
left join user_messages 
on user.user_id = user_messages.from_id or user.user_id = user_messages.to_id
group by user.user_id
order by count(user_messages.from_id) desc, count(user_messages.to_id) desc