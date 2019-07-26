require_relative "questions_database.rb"
require_relative "question_follow.rb"
require_relative "question_like.rb"

class Question 
  
  attr_accessor :title, :body, :author_id, :id

  def self.find_by_id(id)
    return_value = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT * FROM questions WHERE id = ?
    SQL

    return_value.map { |hash| Question.new(hash) }
  end

  def self.find_by_title(title: nil)
    raise ArgumentError, "Wrong number of arguments" if title.nil?
    return_value = QuestionsDatabase.instance.execute(<<-SQL, title)
    SELECT * FROM questions WHERE title = ?
    SQL

    return_value.map { |hash| Question.new(hash) }
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def self.find_by_author_id(author_id)
    return_value = QuestionsDatabase.instance.execute(<<-SQL, author_id)
    SELECT * FROM questions WHERE author_id = ?
    SQL

    return_value.map { |hash| Question.new(hash) }
  end

  def initialize(hash)
    @title = hash["title"]
    @body = hash["body"]
    @author_id = hash["author_id"]

    @id = hash["id"]
  end

  def author
  result = QuestionsDatabase.instance.execute(<<-SQL, self.author_id)
  SELECT fname || ' ' || lname AS first_last_name FROM users WHERE id = ?
  SQL

  result[0]["first_last_name"]
  end

  def replies
    result = QuestionsDatabase.instance.execute(<<-SQL, self.id)
    SELECT * FROM replies WHERE question_id = ?
    SQL

    result.map { |hash| Reply.new(hash) }
  end

  def followers
      QuestionFollow.followers_for_question_id(id)
  end

  def likers
    QuestionLike.likers_for_question_id(id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(id)
  end

end