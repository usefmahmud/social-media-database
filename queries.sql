/*
    Name: Yousef Mahmoud Abdulaziz
    Program: CS & Math
    Project: Social Media Platform
    Team: MinDB
 */
 
-- 1 - each user full name with his eduction, country, and city
select
    concat(first_name, ' ', last_name) as full_name,
    education,
    country,
    city
from user
order by full_name;

-- 2 - top 10 users active in posting
select
    user.user_id,
    concat(user.first_name, ' ', user.last_name) as 'Full Name',
    count(post.post_id) as "Number of Posts"
from user
	left join post on post.user_id = user.user_id
group by user.user_id
order by count(post.post_id) desc;


-- 3 - posts that contain word "help"
select
    post_id,
    caption,
    posted_at
from post
where caption like '%help%';



-- 4 - most liked posts
select
    post_id,
    caption,
    (select count(*) from post_likes where post_id = post.post_id) as like_count
from post
order by like_count desc
limit 5;



-- 5 - average number of likes on posts
select
    avg(likes_count) as "likes average"
from (
         select
             count(*) as likes_count
         from post_likes
         group by post_id
     ) as s;
     
     
-- 6 - list of users who joined in the last 3 months
select
    user.user_id,
    concat(user.first_name, ' ', user.last_name) as "Full Name",
    user.created_at as "Joined Date"
from user
where created_at >= now() - interval 3 month;



-- 7 - users who didn't post in the last 2 years
select
    user.user_id,
    user.first_name
from user
where user.user_id not in (
    select
        post.user_id
    from post
    where post.posted_at >= now() - interval 2 year
);



-- 8 - what is the best hour for posting?
select
    hour(posted_at) as post_hour,
    count(*) as post_count
from post
group by post_hour
order by post_count desc;



-- 9 - reposts number of the posts that have word "environmental"
select
    count(post_reposts.user_id) as "Number of Reposts"
from post
	left join post_reposts 
		on post_reposts.post_id = post.post_id
where post.caption like '%environmental%';



-- 10 - list countries whith their total interactions number
select
    user.country,
    (select count(*) from post_likes where user_id = user.user_id) +
    (select count(*) from post_comments where user_id = user.user_id) +
    (select count(*) from post_reposts where user_id = user.user_id) as total_interactions
from user
group by user.country
order by total_interactions desc;



-- 11 - each user with his number of invitations
select
    concat(a.first_name, ' ', a.last_name) as "Full Name",
    count(b.invited_by) as "Number of Intivations"
from user a
	left join user b
		on a.user_id = b.invited_by
group by a.user_id
order by count(b.invited_by) desc;


-- 12 - each user with number of attending and interested events
select
    user.first_name,
    coalesce(sum(case when event_attends.status = 'attend' then 1 else 0 end)) as "Attending",
    coalesce(sum(case when event_attends.status = 'interested' then 1 else 0 end)) as "Interested"
from user
	left join event_attends
		on user.user_id = event_attends.user_id
group by user.user_id;



-- 13 - get range of birth dates
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


-- 14 - how many users born in each 5 years
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



-- 15 - most active users in texting
select
    concat(user.first_name, ' ', user.last_name) as full_name,
    count(user_messages.from_id) as "from",
    count(user_messages.to_id) as "to"
from user
	left join user_messages
		on user.user_id = user_messages.from_id 
			or user.user_id = user_messages.to_id
group by user.user_id
order by count(user_messages.from_id) desc, count(user_messages.to_id) desc;



-- 16 - get all people who "Bobbie Perrigo" talked with
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
  

-- 17 - events created by "Ronny Bew"
select
    event_id,
    title,
    event_date
from event
where creator_id = (
    select
        user_id
    from user
    where user.first_name = 'Ronny'
      and user.last_name = 'Bew'
);
  


-- 18 events which have no attendees
select
    event.title
from event
	left join event_attends
		on event.event_id = event_attends.event_id
			and event_attends.status = 'attend'
group by event.event_id
having count(event_attends.event_id) = 0;



-- 19 - events that hit maximum attendees
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



-- 20 events will happen in next month
select
    event_id,
    title,
    event_date,
    location
from event
where event_date >= now()
  and event_date <= now() + interval 1 month;



-- 21 - average age of users
select
    round(avg(datediff(now(), birth_date) / 365))
from user;



-- 22 - most frequent age
select
    round(datediff(now(), birth_date) / 365) as age,
    count(user_id) as "Number of Users"
from user
group by age
order by count(user_id);



-- number of given feedbacks
select
    feedback,
    count(like_id) as "Given Feedbacks"
from feedback
group by feedback
order by count(like_id) desc;


-- 23 - top 5 interests for users
select
    interest,
    count(user_id)
from interest
         left join user_interests on interest.interest_id = user_interests.interest_id
group by interest
order by count(user_id) desc
limit 5;



-- 24 - Top 10 ternding topics
select
    tags.tag,
    interest.interest,
    count(post_tags.post_id) as "Number of Posts"
from tags
	left join interest 
		on interest.interest_id = tags.interest_id
	left join post_tags 
		on post_tags.tag_id = tags.tag_id
group by tags.tag_id, tags.tag, interest.interest
order by count(post_tags.post_id) desc
limit 10;




-- 25 - Show all users with their followers and following number
select
    user.user_id,
    user.first_name,
    coalesce(followers.follower_count, 0) as followers_count,
    coalesce(following.following_count, 0) as following_count
from user
    left join (
        select
            following_id as user_id,
            count(follower_id) as follower_count
        from user_follow
        group by following_id
    ) as followers  on user.user_id = followers.user_id
    left join (
        select
            follower_id as user_id,
            count(following_id) as following_count
        from user_follow
        group by follower_id
    ) as following  on user.user_id = following.user_id
order by followers_count desc, following_count desc;



-- 26 - Displaying each community, its interest, and number of admins and members
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



-- 27 - Displaying each post's details along with its engagement metrics.
select
    user.first_name,
    post.caption,
    (case when post.visibility = 'public' then 'public' else community.title end) as visibility,
    (select count(*) from post_likes where post_likes.post_id = post.post_id) as like_count,
    (select count(*) from post_comments where post_comments.post_id = post.post_id) as comment_count,
    (select count(*) from post_reposts where post_reposts.post_id = post.post_id) as repost_count
from post
	left join user 
		on post.user_id = user.user_id
	left join community_posts 
		on post.post_id = community_posts.post_id
	left join community 
		on community.community_id = community_posts.community_id
order by user.first_name,like_count desc, comment_count desc, repost_count desc;



-- 28 Number of posts associated with specific tag combinations.
select
    t1.tag as tag1,
    t2.tag as tag2,
    count(distinct pt1.post_id) as post_count
from post_tags pt1
	left join post_tags pt2
		on pt1.post_id = pt2.post_id
			and pt1.tag_id < pt2.tag_id
	join tags t1 
		on pt1.tag_id = t1.tag_id
	join tags t2 
		on pt2.tag_id = t2.tag_id
group by t1.tag, t2.tag
order by post_count desc;


-- 29 - Are there any posts discussing topics that differ from the community's main focus?
select
    community.community_id,
    post.post_id,
    post.caption,
    tags.tag as post_tag
from post
	left join post_tags
		on post.post_id = post_tags.post_id
	left join tags
		on post_tags.tag_id = tags.tag_id
	left join community_posts
		on post.post_id = community_posts.post_id
	left join community
		on community.community_id = community_posts.community_id
where tags.interest_id != community.interest_id
group by community.community_id;


-- 30 - posts with their top negative feedback
select
    post.post_id,
    post.caption,
    feedback.feedback as "Most Feedback"
from post
	left join post_likes 
		on post_likes.post_id = post.post_id
	left join feedback 
		on feedback.like_id = post_likes.like_id
where feedback.feedback = (
    select
        feedback.feedback
    from feedback
		join post_likes 
			on feedback.like_id = post_likes.like_id
    where post_likes.post_id = post.post_id
    group by feedback.feedback
    order by count(*) desc
    limit 1
)
group by post.post_id;


-- out - each user weekly growth
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


-- users who are mutual followers
select count(distinct f1.follower_id, f1.following_id)
from user_follow f1
	join user_follow f2 
		on f1.follower_id = f2.following_id 
			and f1.following_id = f2.follower_id;