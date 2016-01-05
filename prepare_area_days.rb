# coding: utf-8
require 'csv'
base_area = 'chiba_wakaba_area.csv'
header = %w(地名 センター 可燃ごみ びん・缶・ペットボトル 古紙・布類 不燃ごみ・有害ごみ(危険物))
output_csv = '../data/area_days.csv'
CSV.open(output_csv, 'w') do |csv|
  csv << header
  count = 0
  CSV.foreach(base_area) do |row|
    count = count + 1
    next if count == 1
    add_row = Array.new
    row.each_with_index do |value, index|
      if index == 0
        add_row << value
        add_row << ""
        next
      end
      v = value.split('・')
      if v.count == 1
        add_row << value
        next
      end
      if v[0] =~ /[0-5]/
        base = v[1][1..-1]
        ret = base + v[0]
        ret = ret + " "
        ret = ret + base + v[1][0]
        print v, ret + "\n"
        add_row << ret
      else
        ret = "#{v[0]} #{v[1]}"
        print v, ret + "\n"
        add_row << ret
      end
    end
    csv << add_row
  end
end
