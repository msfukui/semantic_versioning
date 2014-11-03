module SemanticVersioning
  VERSION = '0.0.1'.freeze

  class Version
    SEMVER = /\A(\d+\.\d+\.\d+)\Z/.freeze
    attr_reader :major, :minor, :patch
    attr_accessor :incremental_label

    def initialize(version)
      unless version =~ SEMVER
        fail(
          ArgumentError,
          "#{version} is not a valid Semantic Versioning string."
        )
      end

      @incremental_label = :patch

      @major, @minor, @patch = version.split('.').map(&:to_i)
    end

    def to_s
      [@major, @minor, @patch].join '.'
    end

    def up
      major, minor, patch = @major, @minor, @patch
      upgrade
      ret = SemanticVersioning::Version.new to_s
      @major, @minor, @patch = major, minor, patch
      ret
    end

    def up!
      upgrade
      self
    end

    private

    def upgrade
      if @incremental_label == :major
        @major += 1
        @minor, @patch = 0, 0
      elsif @incremental_label == :minor
        @minor += 1
        @patch = 0
      else
        @patch += 1
      end
    end
  end
end
