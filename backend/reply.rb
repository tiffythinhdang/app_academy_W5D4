require_relative "questions_database.rb"

class Reply 
  
  attr_accessor :parent_reply_id, :body, :author_id, :question_id, :id

  def self.find_by_id(id)
    return_value = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT * FROM replies WHERE id = ?
    SQL

    return_value.map { |hash| Reply.new(hash) }
  end

  def self.find_by_question_id(question_id)
    return_value = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT * FROM replies WHERE question_id = ?
    SQL

    return_value.map { |hash| Reply.new(hash) }
  end

  def self.find_by_author_id(author_id)
    return_value = QuestionsDatabase.instance.execute(<<-SQL, author_id)
    SELECT * FROM replies WHERE author_id = ?
    SQL

    return_value.map { |hash| Reply.new(hash) }
  end

  def initialize(hash)
    @parent_reply_id = hash["parent_reply_id"]
    @body = hash["body"]
    @author_id = hash["author_id"]
    @question_id = hash["question_id"]

    @id = hash["id"]
  end

  def author
  result = QuestionsDatabase.instance.execute(<<-SQL, self.author_id)
    SELECT fname || ' ' || lname AS first_last_name FROM users WHERE id = ?
    SQL

  result[0]["first_last_name"]
  end

  def question
    result = QuestionsDatabase.instance.execute(<<-SQL, self.question_id)
    SELECT title FROM questions WHERE id = ?
    SQL

    result[0]["title"]
  end

  def parent_reply
    result = QuestionsDatabase.instance.execute(<<-SQL, self.parent_reply_id)
    SELECT * FROM replies WHERE id = ?
    SQL

    Reply.new(result[0])
  end

  def child_replies
    result = QuestionsDatabase.instance.execute(<<-SQL, self.id)
    SELECT * FROM replies WHERE parent_reply_id = ?
    SQL

    result.map { |hash| Reply.new(hash) }
  end
end