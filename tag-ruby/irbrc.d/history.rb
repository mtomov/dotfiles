# Pry handles history itself
if defined?(Pry)
  Pry.config.history_file = "#{ENV["HOME"]}/.irb-save-history"
else
  # IRB.conf[:USE_READLINE] = true

  require "irb/ext/save-history"
  IRB.conf[:SAVE_HISTORY] = 1000
  # IRB.conf[:HISTORY_FILE] = Readline::History::LOG
end
