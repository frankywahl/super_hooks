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
    gsub(/^[ \t]{#{indent}}/, "")
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

    omission = options[:omission] || "..."
    length_with_room_for_omission = truncate_at - omission.length
    stop = if options[:separator]
             rindex(options[:separator], length_with_room_for_omission) || length_with_room_for_omission
           else
             length_with_room_for_omission
           end

    "#{omission}#{reverse[0, stop].reverse}"
  end

  # Truncates a given +text+ after a given <tt>length</tt> if +text+ is longer than <tt>length</tt>:
  #
  #   'Once upon a time in a world far far away'.truncate(27)
  #   # => "Once upon a time in a wo..."
  #
  # Pass a string or regexp <tt>:separator</tt> to truncate +text+ at a natural break:
  #
  #   'Once upon a time in a world far far away'.truncate(27, separator: ' ')
  #   # => "Once upon a time in a..."
  #
  #   'Once upon a time in a world far far away'.truncate(27, separator: /\s/)
  #   # => "Once upon a time in a..."
  #
  # The last characters will be replaced with the <tt>:omission</tt> string (defaults to "...")
  # for a total length not exceeding <tt>length</tt>:
  #
  #   'And they found that many people were sleeping better.'.truncate(25, omission: '... (continued)')
  #   # => "And they f... (continued)"
  def truncate(truncate_at, options = {})
    return dup unless length > truncate_at

    omission = options[:omission] || "..."
    length_with_room_for_omission = truncate_at - omission.length
    stop = \
      if options[:separator]
        rindex(options[:separator], length_with_room_for_omission) || length_with_room_for_omission
      else
        length_with_room_for_omission
      end

    "#{self[0, stop]}#{omission}"
  end
end
