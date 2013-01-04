#!/usr/bin/env ruby
require 'rubygems'
require 'yaml'
require 'google_drive'
require 'pry'

CONFIG = YAML::load_file(File.expand_path(File.dirname(__FILE__) + '/config/config.yml'))
NETSPACE_ISSUES = "0ArzbL6-jJsFbdDVhU1JWRVlYaXZPX1U4Wmg1RF9vUEE"
NETSPACE_WORKFLOW = "0ArzbL6-jJsFbdGE4RXJkYWNneUs4ZW00Ym9DdEFic1E"

class IssueItem

  attr_reader :issue, :category, :priority, :notes, :validate, :row_index

  def initialize (issue, category, priority, notes, validate, row_index)
    @issue = issue
    @category = category
    @priority = priority
    @notes = notes
    @validate = validate
    @row_index = row_index
  end
end

class WorkFlowIssue

  attr_reader :bug_num, :status, :validation, :issue, :date, :contact, :row_index

  def initialize (bug_num, status, validation, issue, date, contact, row_index)
    @bug_num = bug_num
    @status
    @validation
    @issue = issue
    @date = date
    @contact = contact
    @row_index = row_index
  end
end

def user_input
  gets.to_i
end

def issues_worksheets
  session = GoogleDrive.login(CONFIG['user'], CONFIG['pass'])
  @i_ws = session.spreadsheet_by_key(NETSPACE_ISSUES).worksheets[0]
  @i_ws2 = session.spreadsheet_by_key(NETSPACE_ISSUES).worksheets[1]
  @i_ws3 = session.spreadsheet_by_key(NETSPACE_ISSUES).worksheets[2]
  @i_ws4 = session.spreadsheet_by_key(NETSPACE_ISSUES).worksheets[3]
end

def workflow_worksheets
  session = GoogleDrive.login(CONFIG['user'], CONFIG['pass'])
  @wf_ws = session.spreadsheet_by_key(NETSPACE_WORKFLOW).worksheets[0]
  @wf_ws2 = session.spreadsheet_by_key(NETSPACE_WORKFLOW).worksheets[1]
  @wf_ws3 = session.spreadsheet_by_key(NETSPACE_WORKFLOW).worksheets[2]
  @wf_ws4 = session.spreadsheet_by_key(NETSPACE_WORKFLOW).worksheets[3]
end

def main_menu
  while true
    puts "1: Netspace Issues"
    #puts "2: Netspace Workflow"
    puts "2: Exit"

    choice = user_input

    case choice
      when 1
        issues_menu
      #when 2
      #  workflow_menu
      when 2
        exit 0
      else
        puts "Invalid option"
    end
  end
end

def issues_menu
  issues_worksheets
  puts "1.  Update All"
  puts "2.  Input Issue"
  puts "3.  Issue Count"
  puts "4.  Validate Issue"
  puts "5.  Exit"

  choice = user_input

  case choice
    when 1
      update_all
    when 2
      input_issue
    when 3
      issue_count
    when 4
      validate_issue
    when 5
      exit 0
    else
      puts "Invalid option"
  end
end

#def workflow_menu
#  workflow_worksheets
#  while true
#    puts "1: Current Issues"
#    puts "2: Add To Current"
#    puts "3: Update Validation"
#    puts "4: Move All"
#    puts "5: Main Menu"
#
#    choice = user_input
#
#    case choice
#      when 1
#        current_wf_issues
#      when 2
#        add_current_wf
#      when 3
#        validate_wf_issues
#      when 4
#        move_all_wf
#      when 5
#        main_menu
#      else
#        puts "Invalid option"
#    end
#  end
#end

#def validate_wf_issues
#    wf_issues = []
#    valid_choice = false
#
#    for row in 2..@wf_ws.num_rows
#      wf_issues << WorkFlowIssue.new(@wf_ws[row, 1], @wf_ws[row, 2], @wf_ws[row, 3], @wf_ws[row, 4], @wf_ws[row, 5], @wf_ws[row, 6],row)
#    end
#
#    puts "Select an issue to validate"
#
#    wf_issues.each_with_index do |item, i|
#      i += 1
#      puts "#{i}: #{item.bug_num}"
#    end
#    choice = user_input
#
#    wf_issues.each do |issue|
#      if choice + 1 == issue.row_index
#        puts "#{choice}: #{issue.bug_num}"
#        while !valid_choice
#          puts "Enter validation code T = Validated In Test, C = Can't Test, V = Fully validated, P = Pending / Blocked"
#          validation = gets.strip!
#          if validation.to_s.upcase == 'T'
#            @wf_ws[issue.row_index, 3] = "(T)est"
#            valid_choice = true
#          elsif validation.to_s.upcase == 'C'
#            @wf_ws[issue.row_index, 3] = "(C)an't test"
#            valid_choice = true
#          elsif validation.to_s.upcase == 'V'
#            @wf_ws[issue.row_index, 3] = "Fully (V)alidated"
#            valid_choice = true
#          elsif validation.to_s.upcase == 'P'
#            @wf_ws[issue.row_index, 3] = "(P)ending / Blocked"
#            valid_choice = true
#          else
#            puts "Not a valid choice"
#          end
#        end
#        @wf_ws.save
#      end
#    end
#end

#def move_all_wf
#  wf_issues = []
#  wf_cant_test = []
#  wf_test_validate = []
#  wf_full_validate = []
#  wf_current = []
#
#  for row in 2..@wf_ws.num_rows
#    wf_issues << WorkFlowIssue.new(@wf_ws[row, 1], @wf_ws[row, 2], @wf_ws[row, 3], @wf_ws[row, 4], @wf_ws[row, 5], @wf_ws[row, 6], row)
#  end
#
#  wf_issues.each do |i|
#    if i.validation.contains("(T)")
#      wf_test_validate << i
#    elsif i.validation.contains("(C)")
#      wf_cant_test << i
#    elsif i.validation.contains("(V)")
#      wf_full_validate << i
#    else
#      wf_current << i
#    end
#  end
#  puts "Validated in test #{wf_test_validate.count()}"
#  puts "Can't test #{wf_cant_test.count()}"
#  puts "Fully validated #{wf_full_validate.count()}"
#  puts "Current #{wf_current.count()}"
#
#end
#
#def current_wf_issues
#  wf_issue = []
#  index = 1
#  for row in 2..@wf_ws.num_rows
#    issue = "ISSUE #{index}: #{@wf_ws[row, 1]}"
#    puts issue
#    index += 1
#    wf_issue << issue
#  end
#end

#def add_current_wf
#  new_issue = []
#  last_row = @wf_ws.num_rows + 1
#
#  puts "Bug#, Issue, Date, Last Contact"
#  input = gets.strip!
#  input = input.split(',')
#  new_issue << WorkFlowIssue.new(input[0], input[1], input[2], input[3])
#  @wf_ws[last_row, 1] = "Net-#{new_issue[0].bug_num}"
#  @wf_ws[last_row, 4] = new_issue[0].issue
#  @wf_ws[last_row, 5] = new_issue[0].date
#  @wf_ws[last_row, 6] = new_issue[0].contact
#  puts "Bug#: #{new_issue[0].bug_num}"
#  puts "Issue: #{new_issue[0].issue}"
#  puts "Date: #{new_issue[0].date}"
#  puts "Contact: #{new_issue[0].contact}"
#  puts
#  puts "ISSUE SUCCESSFULLY ADDED"
#  @wf_ws.save
#end

def issue_count
  action = 0
  review = 0

  for row in 2..@i_ws.num_rows
    if @i_ws[row, 5] == 'A' || @i_ws[row, 5] == 'a'
      action += 1
    end
    if @i_ws[row, 5] == ''
      review += 1
    end
  end
  puts
  puts "Items needing QA action: #{action}"
  puts "Items needing review: #{review}"
  puts
end

def update_all
  feedback_items = []
  main_list = []
  not_an_issue = []
  resolved_list = []
  new_feedback = false
  feedback_count = 0
  not_issue_count = 0
  resolved_count = 0

  for row in 2..@i_ws.num_rows
    if @i_ws[row, 5].upcase == 'NI'
      reload = true
      not_an_issue << IssueItem.new(@i_ws[row, 1], @i_ws[row, 2], @i_ws[row, 3], @i_ws[row, 4], 'X', 0)
    elsif @i_ws[row, 5].upcase == 'R'
      reload = true
      resolved_list << IssueItem.new(@i_ws[row, 1], @i_ws[row, 2], @i_ws[row, 3], @i_ws[row, 4], 'X', 0)
    elsif @i_ws[row, 3].to_s.downcase.include?('feedback')
      if @i_ws[row, 5].strip != '' && @i_ws[row, 5].to_s.downcase != 'r' && @i_ws[row, 5].to_s.downcase != 'ni' && @i_ws[row, 5].to_s.downcase != 'a'
        reload = true
        feedback_items << IssueItem.new(@i_ws[row, 1], @i_ws[row, 2], @i_ws[row, 3], @i_ws[row, 4], 'X', 0)
      else
        main_list << IssueItem.new(@i_ws[row, 1], @i_ws[row, 2], @i_ws[row, 3], @i_ws[row, 4], @i_ws[row, 5], 0)
      end
    else
      main_list << IssueItem.new(@i_ws[row, 1], @i_ws[row, 2], @i_ws[row, 3], @i_ws[row, 4], @i_ws[row, 5], 0)
    end

    if reload
      @i_ws[row, 1] = ""
      @i_ws[row, 2] = ""
      @i_ws[row, 3] = ""
      @i_ws[row, 4] = ""
      @i_ws[row, 5] = ""
    end
  end


  main_list.each_with_index do |item, i|
    i += 2
    @i_ws[i, 1] = item.issue
    @i_ws[i, 2] = item.category
    @i_ws[i, 3] = item.priority
    @i_ws[i, 4] = item.notes
    @i_ws[i, 5] = item.validate
  end

  @i_ws.save

  if feedback_items.count != 0
    start_index = @i_ws2.num_rows + 1
    feedback_items.each_with_index do |item, i|
      feedback_count += 1
      i += start_index
      @i_ws2[i, 1] = item.issue
      @i_ws2[i, 2] = item.category
      @i_ws2[i, 3] = item.priority
      @i_ws2[i, 4] = item.notes
      @i_ws2[i, 5] = item.validate
    end
    @i_ws2.save
  end

  if not_an_issue.count != 0
    start_index = @i_ws3.num_rows + 1
    not_an_issue.each_with_index do |item, i|
      not_issue_count += 1
      i += start_index
      @i_ws3[i, 1] = item.issue
      @i_ws3[i, 2] = item.category
      @i_ws3[i, 3] = item.priority
      @i_ws3[i, 4] = item.notes
      @i_ws3[i, 5] = item.validate
    end
    @i_ws3.save
  end

  if resolved_list.count != 0
    start_index = @i_ws4.num_rows + 1
    resolved_list.each_with_index do |item, i|
      resolved_count += 1
      i += start_index
      @i_ws4[i, 1] = item.issue
      @i_ws4[i, 2] = item.category
      @i_ws4[i, 3] = item.priority
      @i_ws4[i, 4] = item.notes
      @i_ws4[i, 5] = item.validate
    end
    @i_ws4.save
  end

  puts "************************************"

  if feedback_count > 0
    puts "#{feedback_count} items moved to the feedback sheet"
  end

  if not_issue_count > 0
    puts "#{not_issue_count} items moved to the not an issue sheet"
  end

  if resolved_count > 0
    puts "#{resolved_count} items moved to the resolved sheet"
  end

  if resolved_count == 0 && not_issue_count == 0 && feedback_count == 0
    puts "0 items moved"
  end

  puts "************************************"
end


def input_issue
  new_issue = []
  last_row = @i_ws.num_rows + 1

  puts "Issue, category, priority, notes"
  input = gets.strip!
  input = input.split(',')
  new_issue << IssueItem.new(input[0], input[1], input[2], input[3], '', 0)
  @i_ws[last_row, 1] = new_issue[0].issue
  @i_ws[last_row, 2] = new_issue[0].category
  @i_ws[last_row, 3] = new_issue[0].priority
  @i_ws[last_row, 4] = new_issue[0].notes
  @i_ws[last_row, 5] = new_issue[0].validate
  puts "Issue: #{new_issue[0].issue}"
  puts "Category: #{new_issue[0].category}"
  puts "Priority: #{new_issue[0].priority}"
  puts "Notes: #{new_issue[0].notes}"
  puts
  puts "ISSUE SUCCESSFULLY ADDED"
  @i_ws.save
end


def validate_issue
  main_issues = []
  valid_choice = false
  for row in 2..@i_ws.num_rows
    main_issues << IssueItem.new(@i_ws[row, 1], @i_ws[row, 2], @i_ws[row, 3], @i_ws[row, 4], @i_ws[row, 5], row)
  end
  puts "Select an issue to validate"

  main_issues.each_with_index do |item, i|
    i += 1
    puts "#{i}: #{item.issue}"
  end
  choice = user_input

  main_issues.each do |issue|
    if choice + 1 == issue.row_index
      puts "#{choice}: #{issue.issue}"
      while !valid_choice
        puts "Enter validation code A = Action Needed, X = Action completed, R = Resolved, NI = Not an Issue"
        validation = gets.strip!
        if validation.to_s.upcase == 'X'
          @i_ws[issue.row_index, 5] = "X"
          valid_choice = true
        elsif validation.to_s.upcase == 'A'
          @i_ws[issue.row_index, 5] = "A"
          valid_choice = true
        elsif validation.to_s.upcase == 'R'
          @i_ws[issue.row_index, 5] = "R"
          valid_choice = true
        elsif validation.to_s.upcase == 'NI'
          @i_ws[issue.row_index, 5] = "NI"
          valid_choice = true
        else
          puts "Not a valid choice"
        end
      end
      @i_ws.save
    end
  end
end

main_menu
