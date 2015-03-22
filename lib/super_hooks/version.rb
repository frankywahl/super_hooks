module SuperHooks
  # A version object
  class Version
    # Major release
    MAJOR = 0
    # Minor release
    MINOR = 0
    # Patch level
    PATCH = 2
    # Preview
    PRE = 1

    # Return the current version of SuperHooks
    # following the semantics versioning
    def self.to_s
      [MAJOR, MINOR, PATCH, PRE].compact.join('.')
    end
  end

  # The current version of SuperHooks
  VERSION = Version.to_s
end
