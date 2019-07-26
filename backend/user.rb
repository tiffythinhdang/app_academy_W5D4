require_relative "questions_database.rb"
require_relative "question.rb"
require_relative "reply.rb"
require_relative "question_follow.rb"
require_relative "question_like.rb"

class User 
  
  attr_accessor :fname, :lname, :id

  def self.find_by_id(id)
    return_value = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT * FROM users WHERE id = ?
    SQL

    return_value.map { |hash| User.new(hash) }
  end

  def self.find_by_name(fname: nil, lname: nil)
    # fname ||= "NULL"
    # lname ||= "NULL"
    raise ArgumentError, "Wrong number of arguments" if fname.nil? || lname.nil?
    return_value = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
    SELECT * FROM users WHERE fname = ? AND lname = ?
    SQL

    return_value.map { |hash| User.new(hash) }
  end

  def initialize(hash)
    @fname = hash["fname"]
    @lname = hash["lname"]

    @id = hash["id"]
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    Reply.find_by_author_id(id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_follower_id(id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(id)
  end

  def average_karma
    return_value = QuestionsDatabase.instance.execute(<<-SQL, self.id)
      SELECT 
        COUNT(question_likes.id)/COUNT(DISTINCT(questions.id)) AS AVG
      FROM 
        questions
      LEFT JOIN
        question_likes ON questions.id = question_likes.question_id 
      WHERE 
        questions.author_id = ?
    SQL
  end

  def save!
    if id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname)
      INSERT INTO 
        users (fname, lname)
      VALUES
        (?, ?) 
      SQL
      self.id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname, self.id)
      UPDATE 
        users 
      SET
        fname = ?, lname = ?
      WHERE
        id = ?
      SQL
    end
  end
end