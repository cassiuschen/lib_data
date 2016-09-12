require 'csv'
class University < ApplicationRecord
  has_many :surveys
  mount_uploader :logo, LogoUploader
  mount_uploader :file, CsvUploader

  TITLES = {
    "A1" => "馆舍总面积",
    "A3" => "工作人员总数",
    "A4.1" => "读者总人数",
    "B1" => "文献资源购置费",
    "B1.1" => "购纸质资源",
    "B1.2" => "购电子资源",
    "B1.3" => "购非书资料",
    "B1.4" => "其他费用",
    "B2" => "文献资源加工费",
    "D" => "文献资源累积量",
    "D1" => "图书累积总量",
    "D1.1" => "纸质图书累积量",
    "D1.2" => "电子图书累积量",
    "E1" => "读者座位总数",
    "G1" => "书刊外借量"
  }

  TAILS = {
    "A1" => "㎡",
    "A3" => "人",
    "A4.1" => "人",
    "B1" => "元",
    "B1.1" => "元",
    "B1.2" => "元",
    "B1.3" => "元",
    "B1.4" => "元",
    "B2" => "元",
    "D" => "册",
    "D1.1" => "册",
    "D1.2" => "册",
    "E1" => "个",
    "G1" => "册次"
  }

  def to_param
    code
  end

  after_save do
    #self.analyze_csv if self.data_changed?
  end

  def analyze_csv
    body = self.file
    csv = CSV.new body.read
    @array = csv.to_a

    get_data = -> (sum, arr, callback) {
      unless @array[sum][2].to_f == 0
        return @array[sum][2].send(callback)
      else
        result = 0.0
        arr.each {|i| result += @array[i][2].to_f}
        return result.send(callback)
      end
    }

    # Begin to import data
    data = {}
    # A1
    data[@array[1][1].split(" ").first] = get_data.call 1, [8, 12, 15, 18, 21, 24, 27, 30, 33, 36], "to_f"
    # A3
    data[@array[44][1].split(" ").first] = get_data.call 44, [45, 67,68,69], "to_i"
    # A4.1
    data[@array[71][1].split(" ").first] = get_data.call 71, (72..74).to_a, "to_i"
    # B1
    data[@array[85][1].split(" ").first] = get_data.call 85, (87..90).to_a + (92..96).to_a + (98..101).to_a + (103..104).to_a, "to_f"
    # B1.1
    data[@array[86][1].split(" ").first] = get_data.call 86, (87..90).to_a, "to_f"
    # B1.2
    data[@array[91][1].split(" ").first] = get_data.call 91, (92..96).to_a, "to_f"
    # B1.3
    data[@array[97][1].split(" ").first] = get_data.call 97, (98..101).to_a, "to_f"
    # B1.3
    data[@array[102][1].split(" ").first] = get_data.call 102, (103..104).to_a, "to_f"
    # B2
    data[@array[105][1].split(" ").first] = get_data.call 105, (106..107).to_a, "to_f"
    # D
    data["D"] = get_data.call 140, [143,144,145,147,148], "to_i"
    # D1.1
    data["D1.1"] = get_data.call 141, (143..145).to_a, "to_i"
    # D1.2
    data["D1.2"] = get_data.call 146, [147, 148], "to_i"
    # E1
    data["E1"] = get_data.call 168, [169, 170], "to_i"
    # E1
    data["G1"] = get_data.call 175, [175], "to_i"

    self.data = data
    self.save
  end

  def pretty_data
    data.map {|k,v| TITLES[k] + ": #{v}#{TAILS[k]}"}.join("<br />")
  end

  def view_data
    data.delete_if {|k,v| v.to_i == 0}.map {|k,v| {TITLES[k] => "#{v}#{TAILS[k]}"}}
  end

  def avg_score
    unless self.surveys.size == 0
      (self.surveys.sum(&:score) / self.surveys.size).to_i
    else
      0
    end
  end
end


##

#{
#  q1: {
#    1 => 0,
#    2 => 5,
#    3 => 10,
#    4 => 2
#  },
#  q2: {
#    1 => 10,
#    2 => 5,
#    3 => 0,
#    4 => 0
#  },
#  q3: {
#    1 => 2,
#    2 => 10,
#    3 => 5,
#    4 => 0
#  },
#  q4: {
#    1 => 2,
#    2 => 10,
#    3 => 5,
#    4 => 0
#  },
#  q5: {
#    1 => 5,
#    2 => 5,
#    3 => 0,
#    4 => 5,
#    5 => 5,
#    6 => 6,
#    7 => 5,
#    8 => 5
#  },
#  q6: {
#    1 => 0,
#    2 => 10,
#    3 => 2,
#    4 => 0
#  },
#  q7: {
#    1 => 10,
#    2 => 0
#  },
#  q8: {
#    1 => 10,
#    2 => 0
#  }
#}
