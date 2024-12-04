-- most active users in texting
select
	concat(user.first_name, ' ', user.last_name) as full_name,
    count(user_messages.from_id) as "from",
    count(user_messages.to_id) as "to"
from user
left join user_messages 
on user.user_id = user_messages.from_id or user.user_id = user_messages.to_id
group by user.user_id
order by count(user_messages.from_id) desc, count(user_messages.to_id) desc;

-- top 5 aquired interests
select
	interest,
    count(user_id)
from interest
left join user_interests
on interest.interest_id = user_interests.interest_id
group by interest
order by count(user_id) desc
limit 5;

-- each user with his number of invitations
select
	concat(a.first_name, ' ', a.last_name) as "Full Name",
    count(b.invited_by) as "Number of Intivations"
from user a
left join user b
on a.user_id = b.invited_by
group by a.user_id
order by count(b.invited_by) desc;

-- each user with number of attending and interested events
select
	user.first_name,
    COALESCE(sum(case when event_attends.status = 'attend' then 1 else 0 end)) as "Attending",
    COALESCE(sum(case when event_attends.status = 'interested' then 1 else 0 end)) as "Interested"
from user
left join event_attends
on user.user_id = event_attends.user_id
group by user.user_id;

-- events which have no attendees
select
	event.title
from event
left join event_attends
on event.event_id = event_attends.event_id 
	and event_attends.status = 'attend'
group by event.event_id
having count(event_attends.event_id) = 0;

-- get range of birth dates
select
	(
		select 
			min(birth_date)
		from user
	) as "Start of Range",
    (
		select
			max(birth_date)
		from user
    ) as "End of Range";
    
    
-- how many users born in each 5 years
select 
    case
        when year(birth_date) between 1990 and 1995 then '1990 - 1995'
        when year(birth_date) between 1996 and 2000 then '1996 - 2000'
        when year(birth_date) between 2001 and 2005 then '2001 - 2005'
        when year(birth_date) between 2006 and 2010 then '2006 - 2010'
    end as birth_date_range,
    count(*) as "Count of Users"
from user
group by birth_date_range;

-- get all people who "Bobbie Perrigo" talked with
select
	concat(other.first_name, ' ', other.last_name) as "Full Name"
from user person
left join chat
on (chat.user_1 = person.user_id 
	or chat.user_2 = person.user_id)
left join user other
on (other.user_id = chat.user_1 or other.user_id = chat.user_2)
    and other.user_id <> person.user_id
where person.first_name = 'Bobbie'
	and person.last_name = 'Perrigo';
    
-- top 10 ternding topics
select
	tags.tag,
    interest.interest,
    count(post_tags.post_id) as "Number of Posts"
from tags
left join interest
on interest.interest_id = tags.interest_id
left join post_tags
on post_tags.tag_id = tags.tag_id
group by tags.tag_id
order by count(post_tags.post_id) desc
limit 10;


-- each user weekly growth
with weekly_activity as (
    select
        user_id,
        year(posted_at) as year,
        week(posted_at, 1) as week,
        count(*) as activity_count
    from post
    group by user_id, year, week
),
activity_growth as (
    select
        a.user_id,
        a.year,
        a.week,
        (a.activity_count - coalesce(b.activity_count, 0)) as growth
    from weekly_activity a
    left join weekly_activity b
    on a.user_id = b.user_id 
		and a.year = b.year 
        and a.week = b.week + 1
)
select
    activity_growth.user_id,
    concat(user.first_name, ' ', user.last_name) as full_name,
    year,
    week,
    growth
from activity_growth
join user on activity_growth.user_id = user.user_id
where growth > 0
order by growth desc;


-- number of posts per user
select
	user.user_id,
	concat(user.first_name, ' ', user.last_name) as 'Full Name',
    count(post.post_id)
from user
left join post on post.user_id = user.user_id
group by user.user_id
order by count(post.post_id);

-- enagement types count per year

-- showing each post details with its engagement
select
    user.first_name,
    post.caption,
    (case when post.visibility = 'public' then 'public' else community.title end) as visibility,
    (select count(*) from post_likes where post_likes.post_id = post.post_id) as like_count,
    (select count(*) from post_comments where post_comments.post_id = post.post_id) as comment_count,
    (select count(*) from post_reposts where post_reposts.post_id = post.post_id) as repost_count
from 
    post
left join user on post.user_id = user.user_id
left join community_posts on post.post_id = community_posts.post_id
left join community on community.community_id = community_posts.community_id
order by user.first_name,like_count desc, comment_count desc, repost_count desc;


-- show users with their engagement score

select
	post.caption,
    count(post_reposts.user_id)
from post
left join post_reposts on post_reposts.post_id = post.post_id
where post.caption = 'Behind happen not environmental money cover family.';

-- top voice people in each interest


-- each community, its interest, and number of admins and members
select
	community.title,
    interest.interest,
    sum(case when community_membership.type = 'admin' then 1 else 0 end) as admins,
    sum(case when community_membership.type = 'member' then 1 else 0 end) as members
from community
left join interest 
on interest.interest_id = community.interest_id
left join community_membership
on community.community_id = community_membership.community_id
group by community.community_id
order by members desc, admins desc;

-- events that hit maximum attendees
select
	event.event_id,
	event.title,
    event.max_attendees,
    count(event_attends.user_id) as "actual attendees"
from event
left join event_attends
on event.event_id = event_attends.event_id
	and event_attends.status = 'attend'
group by event.event_id, event.max_attendees
having count(event_attends.user_id) > event.max_attendees;




SELECT
    p1.user_id,
    u.username,
    YEAR(p1.posted_at) AS year,
    WEEK(p1.posted_at, 1) AS week_number,
    COUNT(*) AS post_count
FROM
    social_media_database.post p1
JOIN
    social_media_database.user u ON p1.user_id = u.user_id
GROUP BY
    p1.user_id, u.username, year, week_number
HAVING
    COUNT(*) > 1
ORDER BY
    post_count DESC, year, week_number;








