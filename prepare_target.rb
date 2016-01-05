# coding: utf-8
require 'csv'
base_target = 'chiba_target.csv'
use_target = %w(可燃ごみ びん・缶・ペットボトル 古紙・布類 不燃ごみ・有害ごみ(危険物))
output_csv = '../data/target.csv'
header = %w(label name notice furigana)
CSV.open(output_csv, 'w') do |csv|
  csv << header
  CSV.foreach(base_target) do |row|
    if use_target.include? row[0]
      csv << row
    end
  end
end
