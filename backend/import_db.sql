PRAGMA foreign_keys = ON;

DROP TABLE question_follows;
DROP TABLE replies;
DROP TABLE question_likes;
DROP TABLE questions;
DROP TABLE users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  fname VARCHAR(255),
  lname VARCHAR(255)
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title VARCHAR(255),
  body TEXT,
  author_id INT, 
  
  CONSTRAINT fk_users
    FOREIGN KEY (author_id)
    REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  question_id INT,
  follower_id INT,

  CONSTRAINT fk_questions
    FOREIGN KEY (question_id)
    REFERENCES questions(id)
  
  CONSTRAINT fk_users
    FOREIGN KEY (follower_id)
    REFERENCES users(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  question_id INT,
  parent_reply_id INT,
  author_id INT,
  body TEXT,

  CONSTRAINT fk_questions
    FOREIGN KEY (question_id)
    REFERENCES questions(id)
  
  CONSTRAINT fk_users
    FOREIGN KEY (author_id)
    REFERENCES users(id)

  CONSTRAINT fk_replies
    FOREIGN KEY (parent_reply_id)
    REFERENCES replies(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  question_id INT,
  liker_id INT,

  CONSTRAINT fk_questions
    FOREIGN KEY (question_id)
    REFERENCES questions(id)
  
  CONSTRAINT fk_users
    FOREIGN KEY (liker_id)
    REFERENCES users(id)
);

INSERT INTO users (fname, lname)
VALUES 
('Tiffany', 'Dang'), 
('Aaron', 'Arima'),
('Kristen', 'Miller');

INSERT INTO questions (title, body, author_id)
VALUES
('Bathroom?', 'Where is the bathroom at AA', 1),
('Assessment time', 'how long is the assessment?', 2);

INSERT INTO question_follows (question_id, follower_id)
VALUES
(1, 3),
(2, 1),
(2, 2);

