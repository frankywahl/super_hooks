# Extensions to the String class
class String
  # Strips indentation in heredocs
  #
  # Examples
  #
  #   if options[:usage]
  #     puts <<-USAGE.strip_heredoc
  #       This command does such and such.
  #
  #       Supported options are:
  #         -h         This message
  #         ...
  #     USAGE
  #   end
  #
  # The user would see the usage message aligned against the left margin.
  #
  # Technically, it looks for the least indented line in the whole string, and removes
  # that amount of leading whitespace.
  def strip_heredoc
    indent = scan(/^[ \t]*(?=\S)/).min.size || 0
    gsub(/^[ \t]{#{indent}}/, '')
  end

  # Strips out the first characters in a string
  #
  # Examples
  #
  #   "averylonstring".truncate_at_start(6, omission: '...')
  #   # => '...ing'
  #
  # Returns the new string
  #
  def truncate_at_start(truncate_at, options = {})
    return dup unless length > truncate_at

    omission = options[:omission] || '...'
    length_with_room_for_omission = truncate_at - omission.length
    stop =        if options[:separator]
                    rindex(options[:separator], length_with_room_for_omission) || length_with_room_for_omission
                  else
                    length_with_room_for_omission
                  end

    "#{omission}#{self.reverse[0, stop].reverse}"
  end
end
