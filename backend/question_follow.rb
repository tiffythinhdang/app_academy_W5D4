require_relative "questions_database.rb"
require_relative "user.rb"

class QuestionFollow
  
  attr_accessor :question_id, :follower_id, :id

  def self.find_by_id(id)
    return_value = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT * FROM question_follows WHERE id = ?
    SQL

    return_value.map { |hash| QuestionFollow.new(hash) }
  end

  def self.find_by_question_id(question_id)
    return_value = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT * FROM question_follows WHERE question_id = ?
    SQL

    return_value.map { |hash| QuestionFollow.new(hash) }
  end

  def self.followers_for_question_id(question_id)
    return_value = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT 
      users.id, users.fname, users.lname 
    FROM 
      users 
    JOIN 
      question_follows ON question_follows.follower_id = users.id
    WHERE 
      question_id = ?
    SQL

    return_value.map { |hash| User.new(hash) }
  end

  def self.followed_questions_for_follower_id(follower_id)
    return_value = QuestionsDatabase.instance.execute(<<-SQL, follower_id)
    SELECT 
      questions.id, questions.body, questions.author_id, questions.title
    FROM 
      questions 
    JOIN 
      question_follows ON question_follows.question_id = questions.id
    WHERE 
      question_follows.follower_id = ?
    SQL

    return_value.map { |hash| Question.new(hash) }
  end

  def self.most_followed_questions(n)
    return_value = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT 
      questions.id, questions.body, questions.author_id, questions.title
    FROM 
      questions 
    JOIN 
      question_follows ON question_follows.question_id = questions.id
    GROUP BY 
      questions.id, questions.body, questions.author_id, questions.title
    ORDER BY 
      COUNT(*)
    LIMIT ?
    SQL

    return_value.map { |hash| Question.new(hash) }
  end

  def initialize(hash)
    @question_id = hash["question_id"]
    @follower_id = hash["follower_id"]

    @id = hash["id"]
  end
end