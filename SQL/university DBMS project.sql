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

CREATE TABLE `user_interests` (
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

CREATE TABLE `user_messages` (
  `message_id` int PRIMARY KEY,
  `chat_id` int,
  `from_id` int,
  `to_id` int,
  `sent_at` timestamp,
  `message_text` varchar(255)
);

CREATE TABLE `post` (
  `post_id` int PRIMARY KEY,
  `user_id` int,
  `visibility` ENUM ('public', 'community'),
  `caption` mediumtext,
  `posted_at` timestamp
);

CREATE TABLE `post_photos` (
  `id` int PRIMARY KEY,
  `url` varchar(100),
  `post_id` int
);

CREATE TABLE `post_videos` (
  `id` int PRIMARY KEY,
  `url` text,
  `post_id` int,
  `duration` double
);

CREATE TABLE `post_likes` (
  `like_id` int PRIMARY KEY,
  `post_id` int,
  `user_id` int,
  `type` ENUM ('like', 'dislike'),
  `liked_at` timestamp
);

CREATE TABLE `feedback` (
  `feedback_id` int PRIMARY KEY,
  `feedback` varchar(100),
  `created_at` timestamp
);

CREATE TABLE `post_feedbacks` (
  `id` int PRIMARY KEY,
  `feedback_id` int,
  `dislike_id` int,
  `post_id` int
);

CREATE TABLE `post_repost` (
  `id` int PRIMARY KEY,
  `post_id` int,
  `user_id` int
);

CREATE TABLE `post_comments` (
  `comment_id` int PRIMARY KEY,
  `post_id` int,
  `user_id` int,
  `comment_text` mediumtext,
  `commented_at` timestamp
);

CREATE TABLE `tags` (
  `tag_id` int PRIMARY KEY,
  `interest_id` int,
  `tag` varchar(50)
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
  `cover_photo` varchar(100),
  `interest_id` int
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
  `max_attendees` int,
  `interest_id` int
);

CREATE TABLE `event_attend` (
  `id` int PRIMARY KEY,
  `user_id` int,
  `event_id` int,
  `status` ENUM ('interested', 'attend')
);

ALTER TABLE `user` ADD FOREIGN KEY (`invited_by`) REFERENCES `user` (`user_id`);

ALTER TABLE `user_interests` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `user_interests` ADD FOREIGN KEY (`interest_id`) REFERENCES `interest` (`interest_id`);

ALTER TABLE `user_follow` ADD FOREIGN KEY (`follower_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `user_follow` ADD FOREIGN KEY (`following_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `chat` ADD FOREIGN KEY (`user_1`) REFERENCES `user` (`user_id`);

ALTER TABLE `chat` ADD FOREIGN KEY (`user_2`) REFERENCES `user` (`user_id`);

ALTER TABLE `user_messages` ADD FOREIGN KEY (`from_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `user_messages` ADD FOREIGN KEY (`to_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `user_messages` ADD FOREIGN KEY (`chat_id`) REFERENCES `chat` (`chat_id`);

ALTER TABLE `post` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `post_photos` ADD FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`);

ALTER TABLE `post_videos` ADD FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`);

ALTER TABLE `post_likes` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `post_likes` ADD FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`);

ALTER TABLE `post_feedbacks` ADD FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`);

ALTER TABLE `post_feedbacks` ADD FOREIGN KEY (`dislike_id`) REFERENCES `post_likes` (`like_id`);

ALTER TABLE `post_feedbacks` ADD FOREIGN KEY (`feedback_id`) REFERENCES `feedback` (`feedback_id`);

ALTER TABLE `post_repost` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `post_repost` ADD FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`);

ALTER TABLE `post_comments` ADD FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`);

ALTER TABLE `post_comments` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `tags` ADD FOREIGN KEY (`interest_id`) REFERENCES `interest` (`interest_id`);

ALTER TABLE `post_tags` ADD FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`);

ALTER TABLE `post_tags` ADD FOREIGN KEY (`tag_id`) REFERENCES `tags` (`tag_id`);

ALTER TABLE `community` ADD FOREIGN KEY (`interest_id`) REFERENCES `interest` (`interest_id`);

ALTER TABLE `community_membership` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `community_membership` ADD FOREIGN KEY (`community_id`) REFERENCES `community` (`community_id`);

ALTER TABLE `community_posts` ADD FOREIGN KEY (`post_id`) REFERENCES `post` (`post_id`);

ALTER TABLE `community_posts` ADD FOREIGN KEY (`community_id`) REFERENCES `community` (`community_id`);

ALTER TABLE `event` ADD FOREIGN KEY (`creator_id`) REFERENCES `user` (`user_id`);

ALTER TABLE `event` ADD FOREIGN KEY (`interest_id`) REFERENCES `interest` (`interest_id`);

ALTER TABLE `event_attend` ADD FOREIGN KEY (`event_id`) REFERENCES `event` (`event_id`);

ALTER TABLE `event_attend` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);