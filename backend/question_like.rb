require_relative "questions_database.rb"
require_relative "user.rb"
require_relative "question.rb"

class QuestionLike
  
  attr_accessor :question_id, :liker_id, :id

  def self.find_by_id(id)
    return_value = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT * FROM question_likes WHERE id = ?
    SQL

    return_value.map { |hash| QuestionLike.new(hash) }
  end

  def self.find_by_question_id(question_id)
    return_value = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT * FROM question_likes WHERE question_id = ?
    SQL

    return_value.map { |hash| QuestionLike.new(hash) }
  end

  def self.likers_for_question_id(question_id)
    return_value = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT 
      users.id, users.fname, users.lname
    FROM 
      users 
    JOIN 
      question_likes ON question_likes.liker_id = users.id
    WHERE 
      question_likes.question_id = ?
    SQL

    return_value.map { |hash| User.new(hash) }
  end

  def self.num_likes_for_question_id(question_id)
    return_value = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT 
      count(*) AS counts
    FROM 
      question_likes 
    WHERE 
      question_likes.question_id = ?
    SQL

    return_value[0]["counts"]
  end

  def self.liked_questions_for_user_id(liker_id)
    return_value = QuestionsDatabase.instance.execute(<<-SQL, liker_id)
    SELECT 
      questions.id, questions.body, questions.author_id, questions.title
    FROM 
      questions 
    JOIN 
      question_likes ON question_likes.question_id = questions.id
    WHERE 
      question_likes.liker_id = ?
    SQL

    return_value.map { |hash| Question.new(hash) }
  end

  def self.most_liked_questions(n)
    return_value = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT 
      questions.id, questions.body, questions.author_id, questions.title
    FROM 
      questions 
    JOIN 
      question_likes ON question_likes.question_id = questions.id
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
    @liker_id = hash["liker_id"]

    @id = hash["id"]
  end
end