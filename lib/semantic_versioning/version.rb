module SemanticVersioning
  VERSION = '0.0.1'.freeze

  class Version
    SEMVER = /\A((\d|[1-9]\d+)\.(\d|[1-9][\d]+)\.(\d|[1-9][\d]+))\Z/.freeze
    LABEL = [:major, :minor, :patch].freeze

    attr_reader :major, :minor, :patch, :incremental_label

    def initialize(version, incremental_label = :patch)
      unless version =~ SEMVER
        fail(ArgumentError,
             "#{version} is not a valid Semantic Versioning string.")
      end

      unless LABEL.include? incremental_label
        fail(ArgumentError,
             "#{incremental_label} is not a valid label.")
      end

      @incremental_label = incremental_label
      @major, @minor, @patch = version.split('.').map(&:to_i)
    end

    def to_s
      [@major, @minor, @patch].join '.'
    end

    def incremental_label=(incremental_label)
      unless LABEL.include? incremental_label
        fail(ArgumentError,
             "#{incremental_label} is not a valid label.")
      end

      @incremental_label = incremental_label
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
