# coding: utf-8
require 'csv'
sites = %w(hanamigawa midori mihama tyuuou wakaba)

# for target.csv
use_target = %w(可燃ごみ びん・缶・ペットボトル 古紙・布類 不燃ごみ・有害ごみ(危険物))
target_header = %w(label name notice furigana)
base_target_csv = 'chiba_target.csv'

# for area_days.csv
area_days_header = %w(地名 センター 可燃ごみ びん・缶・ペットボトル 古紙・布類 不燃ごみ・有害ごみ(危険物))

sites.each do |site|
  site_dir = "../chiba-#{site}.5374"
  # make target.csv
  target_output_csv = "#{site_dir}/data/target.csv"
  CSV.open(target_output_csv, 'w') do |csv|
    csv << target_header
    CSV.foreach(base_target_csv) do |row|
      if use_target.include? row[0]
        csv << row
      end
    end
  end

  # make area_days.csv
  area_days_input_csv = "./chiba_#{site}_area.csv"
  area_days_output_csv = "#{site_dir}/data/area_days.csv"
  found_notice = false
  CSV.open(area_days_output_csv, 'w') do |csv|
    csv << area_days_header
    count = 0
    CSV.foreach(area_days_input_csv) do |row|
      count = count + 1
      next if count == 1
      add_row = Array.new
      row.each_with_index do |value, index|
        if value == "※"
          found_notice = true
        end
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
          add_row << ret
        else
          ret = "#{v[0]} #{v[1]}"
          add_row << ret
        end
      end
      csv << add_row
    end
  end
  if found_notice
    p "#{area_days_output_csv} で※が見つかりました。内容を確認してください"
  end
  
end
