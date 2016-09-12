class Survey < ApplicationRecord
  belongs_to :university
  after_create :calc_score

  def calc_score
    @score = 0
    self.answer.each do |k, v|
      if v.class == String
        @score += self.university.right_answer[k][v]
      elsif v.class == Array
        v.each {|i| @score += self.university.right_answer[k][i.to_s] unless !(self.university.right_answer[k])}
      end
    end
    self.score = @score > 100 ? 100 : @score
    self.save
  end

  def slogan
    if self.score < 60
      "不行啊，你还需要多去图书馆了解了解哦~"
    elsif self.score >= 60 and self.score < 80
      "还可以嘛，一看就是经常去图书馆的好同学！"
    else
      "相当可以，你对图书馆了如指掌！"
    end  
  end
end
