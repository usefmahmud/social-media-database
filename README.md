## **Intro**

## **Tools**

* diagram design: [dbdiagram.io](https://dbdiagram.io)
* sketches: [Excalidraw](https://excalidraw.com/)
* mock data using [mockaroo](https://www.mockaroo.com/)
* Python to fix and manipulate the data

## Requirements

### *Problem Statement:*

Most of social media platforms are based on different aspects

- **Facebook:** engagements.
- **Linkedin:** networking and connections.
- **Twitter:** news and discussions.
- **TikTok:** short-form video entertainment.
- **Instagram:** visuals and reels.
- **Reddit:** subcommunities.

But what about a new platform which is mainly based on the content?

### *Platform Vision and Outlines:*

* Focus on insightful and valuable content, encouraging users to share meaningful posts.
* Motivate regular participation through features like active-user streaks and badges for top contributors in different topics.
* Make trending topics and impactful posts easily discoverable.
* **Like** and **Dislike** options, with required feedback for dislikes, to support a respectful, quality-focused environment.

### *Database Requirements:*

* **User:**

  *Users can create accounts with personal information (e.g., name, email, password, profile picture, and education).
  * Can invite others to join the platform.
	* Each user must choose interest or more.
  * Following and chat with each other
* **Post:**
  * Posts must include a caption and can optionally contain media such as photos or videos.
  * Posting time should be stored for each post.
  * Posts can be tagged with one or more topics or categories.
  * Users can interact with posts through likes, dislikes (with required feedback), comments, or reposts.
* **Event Management:**
  * Users can create events associated with a specific interest or topic.
  * Events must have a title, description, location, date, and a maximum number of attendees.
  * Users can choose to attend events or express interest without committing to attendance.

* **Community:**
  * Communities should allow users to form groups around shared interest.
  * Users can create, join and participate in discussions within communities.
* **Analysis:**
  * Track user activity, including post streaks and consistency.
  * Identify and highlight top contributors (users with high engagement or posts).
  * Analyze trending topics and posts based on likes, comments, and reposts.
  * Provide insights into highly liked and disliked posts, including reasons for dislikes.
  * Recommend users to follow based on shared interests or mutual connections.
  * Identify the least active users and suggest re-engagement strategies.
  * Track events to compare predicted versus actual attendee numbers.
  * Highlight impactful posts and trending discussions on the platform.

## **ER Diagram**
![Label](./imgs/er_diagram.drawio.svg)
## **Relational Model**
![Relational Model](imgs/relational-model.png "Relational Model")
<a href="https://dbdiagram.io/d/university-DBMS-project-672a3b04e9daa85aca67484d" target="_blank">show on dbdiagram.io</a>

## **How to run this database on your machine**
You should first make sure that you have `xampp` and `mysql` are installed. After that clone the project using `git clone https:`

Finally run this command on cmd inside the `xampp\mysql\bin` directory:
```
mysql -u root -p < fullpath\to\database_creation.sql
```
it will create the database and insert all data within a few seconds.
## Queries and Analysis
1) List interests and its tags
2) Each user with its info
3) Active time for publish posts in day time slots
4) Top voice in each topic
5) Number of interests for each post
## Conclusion
