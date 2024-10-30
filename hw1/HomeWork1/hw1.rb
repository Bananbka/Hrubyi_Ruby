require 'date'


class DuplicateStudentError < StandardError; end

class Student
  @@students = []
  attr_accessor :surname, :name, :date_of_birth

  def initialize(surname, name, date_of_birth)
    if !is_date_valid?(date_of_birth)
      raise ArgumentError, "Invalid date of birth: #{date_of_birth}!\nPattern: \"yyyy-mm-dd\"\nDate should be from past!"
    elsif is_duplicate?(surname, name, date_of_birth)
      raise DuplicateStudentError, "Student [#{surname}, #{name}, (#{date_of_birth})] already in the list!"
    else
      @surname = surname
      @name = name
      @date_of_birth = Date.parse(date_of_birth)
      @@students << self
    end
  end

  def is_date_valid? (date_of_birth)
    begin
      date = Date.parse(date_of_birth)
      today = Date.today
      if today - date <= 0
        return false
      end
    rescue TypeError
      return false
    end
    true
  end

  def self.students
    @@students
  end

  def to_s
    "#{surname} #{self.name} (#{self.date_of_birth})"
  end

  def calculate_age
    today = Date.today
    year = today.year - self.date_of_birth.year
    month = today.month - self.date_of_birth.month
    day = today.day - self.date_of_birth.day
    if month >= 0 && day >= 0
      return year
    end
    year-1
  end

  def add_student
    if is_duplicate?(surname, name, date_of_birth)
      raise DuplicateStudentError, "Student [#{surname}, #{name}, (#{date_of_birth})] already in the list!"
    else
      @@students << self
    end
  end

  def is_duplicate? (surname, name, date_of_birth)
    @@students.each { |student|
      if student.surname == surname && student.name == name && student.date_of_birth.to_s == date_of_birth.to_s
        return true
      end
    }
    false
  end

  def remove_student!
    @@students.delete(self)
  end

  def self.get_students_by_age (age)
    student_list = []
    @@students.each { |student|
      if student.calculate_age == age
        student_list.push(student)
      end
    }
    student_list
  end

  def self.get_students_by_name (name)
    student_list = []
    @@students.each { |student|
      if student.name == name
        student_list.push(student)
      end
    }
    student_list
  end
end
