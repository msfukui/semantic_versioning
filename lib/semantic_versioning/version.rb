module SemanticVersioning
  VERSION = '0.0.1'.freeze

  class Version
    include Comparable

    SEMVER = /\A((\d|([1-9]\d)+)\.
                 (\d|([1-9]\d)+)\.
                 (\d|([1-9]\d)+))
              (-([0-9A-Za-z\-\.])+)?
              (\+([0-9A-Za-z\-\.]+))?\Z/x
    PRE_RELEASE_VERSION = /\A[0-9A-Za-z\-\.]+\Z/x
    BUILD_METADATA      = /\A[0-9A-Za-z\-\.]+\Z/x
    LABEL = [:major, :minor, :patch].freeze

    attr_reader :major, :minor, :patch, :pre, :build, :incremental_label

    def initialize(version, incremental_label = :patch)
      unless valid_version? version
        fail(ArgumentError, "#{version} is not a valid version string.")
      end

      unless valid_label? incremental_label
        fail(ArgumentError, "#{incremental_label} is not a valid label.")
      end

      @incremental_label = incremental_label
      @major, @minor, @patch, @pre, @build = separate_version(version)
    end

    def to_string
      ret = [@major, @minor, @patch].join '.'
      ret = "#{ret}-#{@pre}"   unless @pre.nil?
      ret = "#{ret}+#{@build}" unless @build.nil?
      ret
    end

    alias_method :to_s,   :to_string
    alias_method :to_str, :to_string

    def to_array
      [@major, @minor, @patch, @pre, @build]
    end

    alias_method :to_a,   :to_array
    alias_method :to_ary, :to_array

    def to_hash
      {
        major: @major,
        minor: @minor,
        patch: @patch,
        pre:   @pre,
        build: @build
      }
    end

    def incremental_label=(incremental_label)
      unless valid_label? incremental_label
        fail(ArgumentError,
             "#{incremental_label} is not a valid label.")
      end

      @incremental_label = incremental_label
    end

    def up!
      upgrade
      self
    end

    def up
      dup.up!
    end

    def <=>(other)
      return nil unless other.is_a? SemanticVersioning::Version

      if @major != other.major
        @major <=> other.major
      elsif @minor != other.minor
        @minor <=> other.minor
      elsif @patch != other.patch
        @patch <=> other.patch
      else
        compare_pre_release_version(@pre, other.pre)
      end
    end

    private

    def valid_version?(version)
      return false unless version =~ SEMVER

      pre = separate_version(version)[3]
      unless pre.nil?
        pre.split('.').each do |v|
          return false if numeric_string_begining_with_zero?(v)
        end
      end

      true
    end

    def numeric_string_begining_with_zero?(s)
      return false if s.nil?
      if s =~ /\d+/ && s != '0' && s =~ /^0/
        true
      else
        false
      end
    end

    def valid_label?(label)
      LABEL.include? label
    end

    def separate_version(version)
      major, minor, patch = version.split('.').map(&:to_i)
      pre, build          = version.split('+').map(&:to_s)
      pre                 = pre.split('-')[1]
      [major, minor, patch, pre, build]
    end

    def upgrade
      if @incremental_label == :major
        @major += 1
        @minor, @patch, @pre, @build = 0, 0, nil, nil
      elsif @incremental_label == :minor
        @minor += 1
        @patch, @pre, @build = 0, nil, nil
      else
        @patch += 1
        @pre, @build = nil, nil
      end
    end

    def compare_pre_release_version(me, you)
      if me.nil? && you.nil?
        0
      elsif me.nil?
        1
      elsif you.nil?
        -1
      else
        compare_pre(me.split('.'), you.split('.'))
      end
    end

    def compare_pre(me, you)
      if me[0].nil? && you[0].nil?
        0
      elsif me[0].nil?
        -1
      elsif you[0].nil?
        1
      else
        if me[0] != you[0]
          begin
            m = Integer(me[0])
            y = Integer(you[0])
          rescue ArgumentError
            me[0] <=> you[0]
          else
            m <=> y
          end
        else
          me.shift
          you.shift
          compare_pre(me, you)
        end
      end
    end
  end
end
