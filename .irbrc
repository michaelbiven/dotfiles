#!/usr/bin/ruby
require 'irb/completion'
require 'irb/ext/save-history'


IRB.conf[:SAVE_HISTORY] = 10000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"
IRB.conf[:PROMPT_MODE]  = :SIMPLE
IRB.conf[:AUTO_INDENT]  = true

def me
  User.find_by_login(ENV['USER'].strip)
end

def r
  reload!
end

