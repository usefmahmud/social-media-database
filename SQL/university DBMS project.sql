CREATE TABLE `user` (
  `user_id` int PRIMARY KEY,
  `first_name` varchar(50),
  `last_name` varchar(50),
  `username` varchar(50) UNIQUE,
  `email` varchar(100) UNIQUE,
  `password` varchar(100),
  `birth_date` date,
  `education` varchar(100),
  `country` varchar(50),
  `city` varchar(50),
  `gender` ENUM ('male', 'female'),
  `profile_photo` varchar(100),
  `profile_cover` varchar(100),
  `invited_by` int,
  `created_at` timestamp
);

CREATE TABLE `interest` (
  `interest_id` int PRIMARY KEY,
  `interest` varchar(50)
);

CREATE TABLE `user_interest` (
  `id` int PRIMARY KEY,
  `user_id` int,
  `interest_id` int
);

CREATE TABLE `user_follow` (
  `id` int PRIMARY KEY,
  `follower_id` int,
  `following_id` int,
  `followd_at` timestamp
);

CREATE TABLE `chat` (
  `chat_id` int PRIMARY KEY,
  `user_1` int,
  `user_2` int,
  `started_at` timestamp
);

CREATE TABLE `user_message` (
  `message_id` int PRIMARY KEY,
  `chat_id` int,
  `from_id` int,
  `to_id` int,
  `sent_at` timestamp,
  `message_text` longtext
);

CREATE TABLE `post` (
  `post_id` int PRIMARY KEY,
  `user_id` int,
  `visiablity` ENUM ('public', 'only_followers', 'community'),
  `caption` longtext,
  `posted_at` timestamp
);

CREATE TABLE `post_photos` (
  `id` int PRIMARY KEY,
  `url` text,
  `post_id` int
);

CREATE TABLE `post_videos` (
  `id` int PRIMARY KEY,
  `url` text,
  `post_id` int,
  `duration` double
);

CREATE TABLE `post_likes` (
  `id` int PRIMARY KEY,
  `post_id` int,
  `user_id` int,
  `type` ENUM ('like', 'dislike'),
  `liked_at` timestamp
);

CREATE TABLE `feedbacks` (
  `feedback_id` int PRIMARY KEY,
  `feedback` text,
  `created_at` timestamp
);

CREATE TABLE `post_feedback` (
  `id` int PRIMARY KEY,
  `feedback_id` int,
  `dislike_id` int,
  `post_id` int
);

CREATE TABLE `post_repost` (
  `id` int PRIMARY KEY,
  `post_id` int,
  `user_id` int,
  `reposted_at` timestamp
);

CREATE TABLE `post_comment` (
  `comment_id` int PRIMARY KEY,
  `post_id` int,
  `user_id` int,
  `comment_text` longtext,
  `commented_at` timestamp
);

CREATE TABLE `tags` (
  `tag_id` int PRIMARY KEY,
  `tag` text
);

CREATE TABLE `post_tags` (
  `id` int PRIMARY KEY,
  `post_id` int,
  `tag_id` int
);

CREATE TABLE `community` (
  `community_id` int PRIMARY KEY,
  `title` varchar(100),
  `description` mediumtext,
  `cover_photo` varchar(100)
);

CREATE TABLE `community_membership` (
  `id` int PRIMARY KEY,
  `user_id` int,
  `community_id` int,
  `type` ENUM ('admin', 'member'),
  `joined_at` timestamp
);

CREATE TABLE `community_posts` (
  `id` int PRIMARY KEY,
  `post_id` int,
  `community_id` int
);

CREATE TABLE `event` (
  `event_id` int PRIMARY KEY,
  `creator_id` int,
  `title` varchar(100),
  `description` mediumtext,
  `location` text,
  `event_date` date,
  `max_attendees` int
);

CREATE TABLE `event_attend` (
  `id` int PRIMARY KEY,
  `user_id` int,
  `event_id` int,
  `status` ENUM ('interested', 'attended')
);

CREATE TABLE `event_interests` (
  `id` int PRIMARY KEY,
  `event_id` int,
  `interest_id` int
);

ALTER TABLE `user` ADD FOREIGN KEY (`invited_by`) REFERENCES `user` (`user_id`);

ALTER TABLE `user` ADD FOREIGN KEY (`user_id`) REFERENCES `user_interest` (`user_id`);

ALTER TABLE `interest` ADD FOREIGN KEY (`interest_id`) REFERENCES `user_interest` (`interest_id`);

ALTER TABLE `user` ADD FOREIGN KEY (`user_id`) REFERENCES `user_follow` (`follower_id`);

ALTER TABLE `user` ADD FOREIGN KEY (`user_id`) REFERENCES `user_follow` (`following_id`);

ALTER TABLE `user` ADD FOREIGN KEY (`user_id`) REFERENCES `user_message` (`from_id`);

ALTER TABLE `user` ADD FOREIGN KEY (`user_id`) REFERENCES `user_message` (`to_id`);

ALTER TABLE `chat` ADD FOREIGN KEY (`chat_id`) REFERENCES `user_message` (`chat_id`);

ALTER TABLE `user` ADD FOREIGN KEY (`user_id`) REFERENCES `post` (`user_id`);

ALTER TABLE `post_photos` ADD FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`);

ALTER TABLE `post_videos` ADD FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`);

ALTER TABLE `user` ADD FOREIGN KEY (`user_id`) REFERENCES `post_likes` (`user_id`);

ALTER TABLE `post` ADD FOREIGN KEY (`post_id`) REFERENCES `post_likes` (`post_id`);

ALTER TABLE `post_feedback` ADD FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`);

ALTER TABLE `post_feedback` ADD FOREIGN KEY (`dislike_id`) REFERENCES `post_likes` (`user_id`);

ALTER TABLE `post_feedback` ADD FOREIGN KEY (`feedback_id`) REFERENCES `feedbacks` (`feedback_id`);

ALTER TABLE `post_repost` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `post_repost` ADD FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`);

ALTER TABLE `post` ADD FOREIGN KEY (`post_id`) REFERENCES `post_comment` (`post_id`);

ALTER TABLE `user` ADD FOREIGN KEY (`user_id`) REFERENCES `post_comment` (`user_id`);

ALTER TABLE `post_tags` ADD FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`);

ALTER TABLE `post_tags` ADD FOREIGN KEY (`tag_id`) REFERENCES `tags` (`tag_id`);

ALTER TABLE `user` ADD FOREIGN KEY (`user_id`) REFERENCES `community_membership` (`user_id`);

ALTER TABLE `community_membership` ADD FOREIGN KEY (`community_id`) REFERENCES `community` (`community_id`);

ALTER TABLE `community_posts` ADD FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`);

ALTER TABLE `community_posts` ADD FOREIGN KEY (`community_id`) REFERENCES `community` (`community_id`);

ALTER TABLE `user` ADD FOREIGN KEY (`user_id`) REFERENCES `event` (`creator_id`);

ALTER TABLE `event` ADD FOREIGN KEY (`event_id`) REFERENCES `event_attend` (`event_id`);

ALTER TABLE `user` ADD FOREIGN KEY (`user_id`) REFERENCES `event_attend` (`user_id`);

ALTER TABLE `event` ADD FOREIGN KEY (`event_id`) REFERENCES `event_interests` (`event_id`);

ALTER TABLE `interest` ADD FOREIGN KEY (`interest_id`) REFERENCES `event_interests` (`interest_id`);
