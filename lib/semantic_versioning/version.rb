module SemanticVersioning
  VERSION = '0.0.1'.freeze

  class Version
    SEMVER = /\A(\d+\.\d+\.\d+)\Z/.freeze
    attr_reader :major, :minor, :patch

    def initialize(version)
      unless version =~ SEMVER
        fail(
          ArgumentError,
          "#{version} is not a valid Semantic Versioning string."
        )
      end

      @major, @minor, @patch = version.split('.').map(&:to_i)
    end
  end
end
