class User
  attr_accessor :name, :age
  attr_reader :id

  def initialize(name:, age:, id: nil)
    @id = id
    @name = name
    @age = age
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY,
      name TEXT,
      age INTEGER
    ) 
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS users"
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
      INSERT INTO users (name, age)
      VALUES(?, ?)
    SQL

      DB[:conn].execute(sql, self.name, self.age)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM users")[0][0]
    end
  end

  def update
    sql = <<-SQL
 UPDATE users 
 SET name = ?, breed = ? 
 WHERE id = ?
    SQL
    DB[:conn].execute(sql, self.name, self.age, self.id)
  end

  def self.find_by_id(id)
    sql = <<-SQL
    SELECT * 
    FROM users 
    WHERE id=? 
    LIMIT 1
    SQL

    DB[:conn].execute(sql, id).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.create(name, age)
    user = User.new(name, age)
    user.save
    user
  end

  def self.find_or_create_by(name:, age:)
    sql = <<-SQL
    SELECT * FROM users 
    WHERE name = ? 
    AND age = ?
    LIMIT 1
    SQL
    user = DB[:conn].execute(sql, name, age)
    if !user.empty?
      new_user = user.flatten
      user = User.new(id: new_user[0], name: new_user[1], age: new_user[2])
    else
      user = User.create(name: name, age: age)
    end
    user
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM users
    WHERE name=?
    LIMIT 1
    SQL
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end
end
